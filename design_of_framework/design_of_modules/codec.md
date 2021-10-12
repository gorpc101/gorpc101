# codec

## 模块设计：codec

### codec做什么

网络通信过程中，数据都是以二进制数据的形式进行发送的，这里的二进制数据是由我们内存中的数据结构经过一定的序列化、压缩、协议编码来生成的。数据发送方、接收方必须采取匹配的序列化方式、压缩解压缩算法、协议，才能正确地完成通信。

为了说清楚这个过程，我们不妨举个例子来说明下这里的逻辑。这里将使用google protocolbuffers（以下简称pb或protobuf）作为IDL（Interface Definition Language）来说明我们的服务接口，如果读者对pb的使用还有些陌生的话，可以参考[pb的官方文档](https://developers.google.com/protocol-buffers)。

```
syntax = "proto3";
package helloworld;

message HelloRequest {
  string msg = 1;
}

message HelloResponse {
  int32 err_code = 1;
  string err_msg = 2;
}

service HelloService {
  rpc Hello(HelloRequest) returns(HelloResponse);
}
```

以上pb中定义了一个服务接口Hello，该接口的请求参数为HelloRequest，响应为HelloResponse。实际编码过程中，HelloRequest、HelloResponse不过是内存中定义的一种struct数据结构，在真正的网络通信开始前，必须将这种内存struct数据类型转换为二进制表示的数据流，然后才能发送；服务端发送响应结果之前亦如是。

* 序列化/反序列化：pb是一种数据交换格式，protoc编译器会将pb文件转换为go代码，对应的message定义会被转换为struct数据类型，而且该类型还包括了Marshal/Unmarshal方法，以完成序列化、反序列化操作；
* 数据压缩/解压缩：在使用浏览器访问web页面时我们有时可以看到开启了gzip压缩，这是为了提高数据传输效率对数据进行了压缩，当然压缩、解压缩会耗点服务端、浏览器端的cpu，但是这点开销可以接受。类似http，如果我们希望能够提高数据传输效率，开启数据压缩也是可以考虑的；
* 应用层协议：只会讲中文的同学和只会讲英文的同学几乎是无法沟通的，两个人要想能够正常通信，必须在交流的语言上达成统一。网络通信双方要能正确理解双方发送的数据，也必须采用相同的应用层协议，才能从网络通信介质收取到的数据中正确地提取出信息；

严谨一点，序列化/反序列化、压缩/解压缩与应用层协议编解码是不同的层面，但是从通信数据的组织、操作而言，他们有着比较强的相关性，所以为了描述、实现方便，我们在模块codec中对serialization、compression一起进行描述。

### 序列化/反序列化

序列化/反序列化过程，本质上是内存数据对象如何在内存中用二进制数据表示，以及如何通过这些二进制数据还原为内存数据对象的问题。常见的技术也有很多了，像应用比较广泛的json、xml、protobuf、flatbuffer、thrift等等。

关于有哪些序列化/反序列化方式，以及它们各自适用的场景、性能的对比（速度和压缩率），可以[参考维基百科以及相关文章](https://en.wikipedia.org/wiki/Comparison_of_data-serialization_formats)，这里就不过多展开了。

我们只阐述下选择pb作为待开发微服务框架默认序列化方式的原因：

* 消息自描述：pb是自描述性很强的消息格式，用来描述服务接口以及接口请求、响应参数非常合适；
* 成熟工具链：pb提供了专门的protoc编译器，用以解析pb并将其转换为编程语言对应的桩代码，而且提供了插件机制允许为定制化代码生成插件，如protoc-gen-go；
* 极佳的效率：在序列化、反序列化操作方面，pb有着极高的操作效率；
* 合适的压缩率：由于采用了合理的编码技术，如varint、zigzag等对小整数、负整数进行了更短的编码；对string采用了utf8编码，每个字符1\~4个字节，也是变长编码；其他的就不深究了；
* 协议可扩展：后续做协议调整时，如请求体里面增加一个新参数，只要保持字段的tag number保持递增，就不会引发协议不兼容问题，双方协议升级后即可正常访问新增字段；

pb现在也是很多微服务框架首选的数据交换格式，如google出品的gRPC自不必多说了，micro、百度brpc、字节kitex、腾讯goneat、trpc也是做了相同选择。

### 压缩/解压缩

在完成序列化之后，为了进一步减少网络通信数据传输，还可以考虑对序列化后的数据进一步压缩。当然如果开启了压缩之后，对端也需要采用相对应的解压缩算法来完成数据的解压缩。

数据压缩/解压缩算法，考虑的也无非这两点：

* 数据压缩率：这个关系到对数据压缩后可以节省多少传输的数据量；
* 压缩、解压缩的速度：这个关系到给通信延迟额外带来多少开销；

RPC通信中常用的压缩/解压缩算法包括：

* gzip，其实gzip也支持不同级别的压缩，如gzip -3 或 gzip -4分别代表了两种不同压缩等级；
* snappy，google从lz77思想中设计而来，在google内部系统、RPC中应用广泛，重速度而非压缩率；
* lz4；
* lz4\_fragmented；
* 其他；

这里就不详细展开了，感兴趣地读者可以自行了解相关算法的更多信息。

下面简单介绍下框架将默认支持snappy、gzip的原因：

* snappy在算法速度、压缩率方面平衡的不错，我们会考虑优先予以支持；
* 另外，gzip算法由于支持不同的压缩等级，在RPC通信场景中也能通过灵活调整压缩等级来对算法速度、压缩率做出调整、平衡，而且其应用广泛，框架也会支持；
* 其他压缩/解压缩算法，框架将允许通过插件的形式来支持；

### 通信协议设计

通信协议的目的是什么呢？就像汉语规定了句子如何组织一样，通信协议规定了数据如何组织才是能被理解的，只有能被理解的数据才是有效的数据。协议设计好之后，编解码逻辑就应该按照这个规范去实现编码、解码的动作。

通信协议设计时要注意什么？

* 协议中必须包含包体长度信息，这样解码动作才能正确地从收到的数据中解包；
* 协议中必须包含请求唯一标识，如request id，这样在tcp连接复用时（同一个tcp连接多发多收）才能正确地识别response和request的对应关系；
* 协议中必须包含错误信息，如errtype、errcode、errmsg，以方便区分是否发生了错误、发生了何种类型的错误、错误具体类型及描述是什么；
* rpc通信超时控制，timeout控制rpc多久超时，或者deadline控制rpc必须何时结束；
* 安全校验用的魔数（幻数），攻击者精心构造的包是有可能被识别为正常请求响应的，协议上增加魔数校验环节，一定程度上可以降低风险；
* 要支持流式呢，那可能还要支持流id、流操作等相关的字段，参考gRPC协议设计；
* alignment & padding，协议对应内存数据类型，为了方便访问要注意alignment & padding的问题；
* reserved bytes/bits，如果将来有打算对协议做能力上的扩展，也可以设置保留字段/bits；
* 其他；

这算是一个相对比较完整的协议设计的checklist了，大家进行应用层协议设计时可以参考。

### 模块设计

理解了上述内容之后，我们继续来看下codec模块的设计，如下图所示：

![codec模块设计](<../../.gitbook/assets/image (36).png>)

从上图不难看出，其包括核心接口Codec、Compressor、Serializer、Session、SessionBuilder，以及将其整合在一起的MessageReader，我们详细解释这么设计的原因及工作过程。

### 参考内容

1. google protocolbuffers, [https://developers.google.com/protocol-buffers](https://developers.google.com/protocol-buffers)
2. comparison of data serialization formats, [https://en.wikipedia.org/wiki/Comparison_of_data-serialization_formats](https://en.wikipedia.org/wiki/Comparison_of_data-serialization_formats)
3. Cap'n Proto, FlatBuffers, and SBE, [https://capnproto.org/news/2014-06-17-capnproto-flatbuffers-sbe.html](https://capnproto.org/news/2014-06-17-capnproto-flatbuffers-sbe.html)
4. gRPC compression, [https://grpc.github.io/grpc/core/md_doc_compression.html](https://grpc.github.io/grpc/core/md_doc_compression.html)
5. RPC compression, [https://github.com/scylladb/seastar/blob/master/doc/rpc-compression.md](https://github.com/scylladb/seastar/blob/master/doc/rpc-compression.md)
6. snappy compression, [https://en.wikipedia.org/wiki/Snappy\_(compression)](https://en.wikipedia.org/wiki/Snappy_\(compression\))
