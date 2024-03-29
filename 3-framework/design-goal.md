# 设计目标

前面我们列举了业界比较流行的一些微服务框架，一个研发框架的选型不仅要考察框架本身，也要考虑其后续的维护，以及团队技术栈和未来技术的演进方向。我们在前面介绍了如何对框架进行选型，也提到了在团队必要情况下也可以考虑自研一个框架。

## 心目中的框架是什么样的

自研一个微服务框架时，首先要明确的就是设计目标：**要实现一个怎样的框架**？

我们进行框架选型时，结合团队实际需要，脑海中其实已经列了一个checklist，结果发现没有框架可以很好地支持，那自然而然这些checklist也就成为了我们自研框架的必要指标：

| concerns \ framework | Spring Boot | Go Micro | BRpc | GRPC |
| -------------------- | ----------- | -------- | ---- | ---- |
| multi languages      | N           | N        | N    | Y    |
| unary rpc            | Y           | Y        | Y    | Y    |
| stream rpc           | Y           | Y        | Y    | Y    |
| naming service       | Y           | Y        | Y    | Y    |
| logging              | Y           | Y        | Y    | Y    |
| tracing              | Y           | Y        | Y    | Y    |
| ...                  | ...         | ...      | ...  | ...  |
| tcp transport        | Y           | Y        | Y    | N    |
| udp transport        | Y           | Y        | Y    | N    |
| http/2 transport     | Y           | Y        | Y    | Y    |
| grpc integration     | Y           | Y        | Y    | -    |

> ps: 说点题外话，参与框架设计开发时经常听到“比之某某某框架何如”之类的评价，借此说下个人看法。
>
> 近几年，我开始花更多的时间来思考“业务架构”与“技术架构”、“业务复杂度”与“技术复杂度”，不要过分追求技术完美主义，完美的技术方案好不好？好，但是要做到它是有成本的。在投入、产出之间需要最大化对业务的正向价值。大而全、插件化设计良好的框架固然好，但是它本身也存在“抽象”引入的复杂度。
>
> 现在的很多看上去很火的框架，设计上都有自己的微创新，要说什么重大创新，从18年开始搞框架到现在，真的那种让人眼前一亮的创新是极少的。“解决问题”才是做框架的初衷。要说做框架高大上，不如说业务背景、面临问题的多样性，使得它显得“高大上”。以至于到后面几年，给自己的定位也开始多了些“服务人员”的角色。
>
> 当开始把目标放在“解决问题”，而非“具体途径”，心态就会放宽，也会听得进不同意见，结果反而好。

## 明确功能性、非功能性指标

在明确微服务框架的设计目标时，要给出一个checklist。先列出我们需要的功能性指标，以及其他非功能性指标。框架整体也是由不同部分构成，各部分通过特定的协作共同完成必要的处理。**框架设计，就是要通过合理的设计将上述功能性指标、非功能性指标在不同的抽象层次进行妥善地解决**。

gorpc101系列，其初衷是系统性介绍过去这些年在如何保质保量自研微服务框架方面的一些经验，会提供一些演示性质的demo，但并非以超越、替代某个流行的rpc框架为目的。相反，我会介绍在不同rpc框架中学到的创新性设计。

回头再说我们gorpc框架设计的一些具体的功能性、非功能性需求：

* 功能完整：框架提供相对完整的能力，并提供默认实现，开箱即用；
  * 支持tcp/udp/http等transport，支持扩展传输类型；
  * 支持rpc通信方式，并提供灵活的rpc控制能力，如指定超时时间等；
  * 支持服务注册发现，支持扩展服务注册发现方式，如借助consul、zipkin、etcd等；
  * 支持codec，支持扩展协议类型；
  * 支持logging，支持扩展目的输出类型，如console、file、syslog等类型；
  * 支持metrics，支持扩展目的输出类型，如prometheus等类型；
  * 支持tracing，支持扩展目的输出类型，如zipkin、jaeger等类型；
  * 支持filter，提供常用filters，支持扩展filter来丰富能力，如rpc耗时上报；
  * 支持config，支持扩展不同输入来源，如ini、toml、yaml文件以及配置中心；
  * 支持audit，提供常见认证方式，支持扩展；
  * 支持broker，支持消息发布、接受，支持扩展以支持不同消息队列；
  * 支持admin，支持对运行时服务进行管理，如修改运行时配置、查看运行时状态；
* 插件化：框架提供核心能力，允许插件化定制各组件，以更好适应不同场景；
* 高性能：框架需具备业界领先或近似的处理性能；
* 可测试：框架、基于框架开发的服务必须可测试、方便测试；
* 易使用：基于框架开发微服务时应该很简单、省时省力省心；
* go开发：使用go语言开发该微服务框架，主要面向go后端开发者；

总结一下，gorpc要遵循 **“小而美”** 的设计，提供灵活的扩展能力以适应不同的研发运营场景，从而让开发人员从琐碎的工作中解脱出来真正地专注于服务质量本身。

## 关于重复造轮子的问题

开发人员经常会遇到“重复造轮子”的问题，比如我们这里新开发一个微服务框架。“重复造轮子”通常带了点贬义，用来讽刺开发人员经常做些同质化的工作。

如何看待这个问题呢？我的理解是，如果一个轮子不好用，且在可预见的时间内又得不到较好支持，自身需求无法得到满足，那换一个更合适的轮子也没错。如果团队有这样的技术储备，自研也没问题。

> ps：在腾讯内部，关于开发trpc框架也存在类似的争议，直到今天在“脉脉”等平台还是能看到不少同事吐槽，借此机会也表达下我的看法。
>
> 以腾讯为例，在公司内部，存在很多古老的协议、框架、服务，新生代的基于HTTP/2的grpc实现是不能与存量的TCP/UDP服务互通的，协议层面也不能互通。抛开这些问题，微服务架构模式下也要求框架具备灵活的扩展能力，以允许不同团队对接不同的监控、日志等运营体系。有些视频类业务也希望用到流式处理。跨团队协作越来越普遍，也希望新协议能化解之前存量协议互通带来的合作困难。现在很多团队都有不同技术栈背景，框架支持多语言版本也在情理之中。
>
> 而从开发人员角度来说，也希望在后续的开发、联调过程中更加顺畅，对于服务接口的描述也需要一定的规范化。开发过程中也希望能更加关注，协议的定义、代码的生成、测试等等，也需要有工具来支撑。
>
> 综上，我认为，至少trpc框架这个轮子值得造，造的值！



