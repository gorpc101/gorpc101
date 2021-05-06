# 架构设计

## 反复推敲

一个大型软件系统的设计，通常需要经过**“架构模式、设计模式、Idioms”**这三个阶段的不断打磨：

* 架构模式，强调整体的设计原则，影响系统整体及其子系统、组件；
* 设计模式，关注各个子系统、组件及其之间的关系；
* Idioms，关注如何用编程语言的特性，来实现子系统、组件及其之间的关系；

一个框架的设计也是类似的过程，首先需要有一个顶层设计，大致阐述系统的设计原则、设计目标，并给出框架中核心组件之间的大致交互过程，并且组件之间的交互过程要反复推敲，过程中势必会涉及到组件之间依赖关系的变化。

在这里的依赖关系未最终敲定下来之前，可以写伪代码验证设计，但是不能启动开发。因为这里依赖关系的变动，最终具体到模块或组件时会影响到一些核心接口的设计，过早投入开发会因为接口变动导致代码大范围重写。要反复推敲，直到各个核心接口都稳定下来（接口中定义的方法签名不再变化或变化很小）之后，再投入开发。

框架架构设计中的这一过程，与大型软件系统的设计并无二致，都需要经历一个自顶向下、层层分解、逐步细化的过程，最终才是使用特定的编程语言来实现特定的功能。伪代码验证设计的合理性，是一个比较快速有效的方法，但有经验的架构师却可以在架构设计过程中就提前意识到设计的合理与否。

> ps: 不妨也提下网络上比较流行的问题。不会写代码的架构师不是好的架构师？架构师不需要写代码？我对这个问题的看法是，it depends，这里也有提到架构设计的不同层次，不同设计层次要求关注的点确实是不一样的，对于Idioms这个层次是必须要熟悉编程语言及平台的特性才能很好地解决问题的，如C++开发网络服务如何实现高效网络IO，Linux下通过epoll、BSD下通过kqueue。
>
> 一个好的架构师，我认为是在对技术细节有了一定的积累之后，逐步把关注的目标从点变成线、面、体的过程，而不是丢弃细节空谈架构，那样的架构就无异于“空中楼阁”了。

## 整体架构



```text
@startuml

package "helloworld" {

    interface GreeterService {
        +Hello(ctx, *Request) (*Response, error)
    }

    class GreeterServiceImpl {
        +Hello(ctx, *Request) (*Response, error)
    }
    GreeterServiceImpl -up-|> GreeterService

    class GreeterServiceDesc {
        Name
        Methods map[strin]HandleFunc
    }
}
note right of helloworld
    通常我们由google protobuf作为IDL:
    - 指导服务api的定义
    - 指导client和server stub生成
end note


package "server" {

    class Server {
        +modules []*ServerModule
        +Start()
        +Stop()
        +Handle(h Handler)
    }

    interface ServerModule {
        +Start()
        +Stop()
    }

    Server "1" *-down- "N" ServerModule
    note right of Server
        包含多个ServerModule
        各ServerModule各司其职
    end note

    class PacketServer {
        svr *Server
    }
    PacketServer -up-|> ServerModule

    class StreamServer {
        svr *Server
    }
    StreamServer -up-|> ServerModule

    class HttpServer {
        svr *Server
    }
    HttpServer -up-|> ServerModule

    Server -up-> GreeterServiceImpl
    'note left of Handler : type GreeterService struct{} \nfunc (s *GreeterService) Hello(ctx, req) (rsp, error)

    Server -up-> GreeterServiceDesc

    interface Router {
        Route(rpc string) (Method, error)
    }
    Server -left-> Router

    interface Interceptor {
    }
    interface Auth {
    }
    interface Breaker {
    }
    interface Limiter {
    }

}

package "codec" {

    interface Session {
        TraceContext() (interface{}, error)
        ParseRequestBody(req interface{}) error
        Request() interface{}
        Response() interface{}
        Logger() logger
    }

    interface Codec {
        Encode(v interface{}) ([]byte, error)
        Decode([]byte) (interface{}, error)
    }

    interface MessageReader {
        Codec
        Read(net.Conn) (interface{}, error)
    }

    interface SessionBuilder {
    	Build(req interface{}) (Session, error)
    }

    MessageReader -right-> Codec
    MessageReader -left-> SessionBuilder
    SessionBuilder -left-> Session

    StreamServer -down-> MessageReader
    PacketServer -down-> MessageReader
    HttpServer -down-> MessageReader
}

package "registry" {
    interface Registry {
        +Register(*Service, opts ... RegisterOption) error
        +DeRegister(*Service) error
        +GetService(string) ([]*Service, error)
        +ListServices() ([]*Service, error)
        +Watcher() (Watcher, error)
    }
    Registry "1" *-down- "1" Watcher

    interface Watcher {
        +Next() (*Result, error)
        +Stop()
    }
    Watcher -right-> Result

    class Result {
        +Action ActionType
        +Service *Service
    }
    enum ActionType {
        CREATE
        UPDATE
        DELETE
    }
    Result -up-> ActionType
}
note top of registry
naming service
end note

package "client" {

    interface Client {
        Invoke(ctx, req) (rsp, error)
    }

    interface Transport {
        Send(ctx, req) (rsp, error)
    }
    class TcpTransport {
        pool *TcpConnectionPool
        rd *MessageReader
    }
    TcpTransport "1" --> "TcpConnectionPool"
    TcpTransport -up-|> Transport

    class UdpTransport {
        pool *UdpSocketPool
        rd *MessageReader
    }
    UdpTransport "1" --> "UdpSocketPool"
    UdpTransport -up-|> Transport


    interface ConnectionPool {
        +GetConn() (net.Conn, error)
        +FreeConn(net.Conn)
    }
    TcpConnectionPool --|> ConnectionPool
    UdpSocketPool --|> ConnectionPool

    TcpConnectionPool "1" --> "N" Endpoint
    UdpSocketPool "1" --> "N" Endpoint

    class Endpoint {
        -conn net.Conn
        +Read([]byte) (n, error)
        +Write([]byte) (n, error)
    }

    class ClientAdapter {
        name string
        codec Codec
        selector Selector
        trans Transport
        +Invoke(ctx, req) (rsp, error)
    }
    note left: general client

    ClientAdapter -right-|> Client
    ClientAdapter -up-> MessageReader
    ClientAdapter --> Transport
    ClientAdapter --> Selector

    package "selector" {
        interface Selector {
	        Select(service string, opts ...SelectOption) (Next, error)
	        Mark(service string, node *registry.Node, err error)
	        Reset(service string)
	        Close() error
        }

        SimpleSelector -up-|> Selector
        ConsulSelector -up-|> Selector
        EtcdSelector -up-|> Selector
        Selector -up-> Registry
        note bottom of EtcdSelector
            loadbanlancer based on NamingService
        end note

    }
}

package "gorpc" {
    class Wrapper {
        +NewService(name, addr, version string)
        +Run()
        +NewServiceClient(name, version string)
    }
    Wrapper --> Service

    class Service {
        +Name string
        +Version string
        +Run(svr *Server)
    }

    Service -left-> helloworld
    Service -left-> Server
}
note left of Wrapper
    gorpc.NewService注册新服务
    Run运行服务实例
    NewClient创建rpcclient
end note

package "broker" {
    interface Broker {
        ServerModule
        Subsribe(ctx, topic, gp) (<-chan interface{}, error)
        Publish(ctx, topic, req) error
    }
    Broker -right-|> ServerModule

    class NATS {
        NewBroker(masterAddr) (Broker, error)
    }
    NATS -up-|> Broker

    class Kafka {
        NewBroker(masterAddr) (Broker, error)
    }
    Kafka -up-|> Broker
}
note top of Broker
message bus
end note

package "tracing" {
    interface Tracer {
        Begin(session)
        Finish(session)
    }

    Server -right-> Tracer
    ClientAdapter -up-> Tracer
}
note right: tracing definition

@enduml
```



## 参考文献

1. [Regine Meunier](https://www.google.com/search?newwindow=1&sxsrf=ALeKk00tC6aVFqglc__GX3fxQx_9ukk-2g:1600609025720&q=Regine+Meunier&stick=H4sIAAAAAAAAAOPgE-LRT9c3NErKzU5OyTZS4gXxDJPK08oKy83jtWSyk630k_Lzs_XLizJLSlLz4svzi7KtEktLMvKLFrHyBaWmZ-alKvimluZlphbtYGUEAMQxpKBRAAAA&sa=X&ved=2ahUKEwipv5uj7ffrAhUNqJ4KHTtZBBoQmxMoATCCAXoECA8QAw), [Frank Buschmann](https://www.google.com/search?newwindow=1&sxsrf=ALeKk00tC6aVFqglc__GX3fxQx_9ukk-2g:1600609025720&q=Frank+Buschmann&stick=H4sIAAAAAAAAAOPgE-LRT9c3NErKzU5OyTZSgvAKLJMtCgqqtGSyk630k_Lzs_XLizJLSlLz4svzi7KtEktLMvKLFrHyuxUl5mUrOJUWJ2fkJubl7WBlBAC-azEKUQAAAA&sa=X&ved=2ahUKEwipv5uj7ffrAhUNqJ4KHTtZBBoQmxMoAjCCAXoECA8QBA), [Hans Rohnert](https://www.google.com/search?newwindow=1&sxsrf=ALeKk00tC6aVFqglc__GX3fxQx_9ukk-2g:1600609025720&q=Hans+Rohnert&stick=H4sIAAAAAAAAAOPgE-LRT9c3NErKzU5OyTZS4gXxDNMMjczKTIvitWSyk630k_Lzs_XLizJLSlLz4svzi7KtEktLMvKLFrHyeCTmFSsE5WfkpRaV7GBlBADx7_iFTwAAAA&sa=X&ved=2ahUKEwipv5uj7ffrAhUNqJ4KHTtZBBoQmxMoAzCCAXoECA8QBQ), [Peter Sommerlad](https://www.google.com/search?newwindow=1&sxsrf=ALeKk00tC6aVFqglc__GX3fxQx_9ukk-2g:1600609025720&q=Peter+Sommerlad&stick=H4sIAAAAAAAAAOPgE-LRT9c3NErKzU5OyTZSAvMykvPKknPNcrVkspOt9JPy87P1y4syS0pS8-LL84uyrRJLSzLyixax8geklqQWKQTn5-amFuUkpuxgZQQAjf0aZFEAAAA&sa=X&ved=2ahUKEwipv5uj7ffrAhUNqJ4KHTtZBBoQmxMoBDCCAXoECA8QBg), [Michael Stal](https://www.google.com/search?newwindow=1&sxsrf=ALeKk00tC6aVFqglc__GX3fxQx_9ukk-2g:1600609025720&q=Michael+Stal&stick=H4sIAAAAAAAAAOPgE-LRT9c3NErKzU5OyTZS4tLP1TdIT8syNy3RkslOttJPys_P1i8vyiwpSc2LL88vyrZKLC3JyC9axMrjm5mckZiaoxBckpizg5URADspXHNMAAAA&sa=X&ved=2ahUKEwipv5uj7ffrAhUNqJ4KHTtZBBoQmxMoBTCCAXoECA8QBw), Pattern-Oriented Software Architecture : A System of Patterns, 1995



