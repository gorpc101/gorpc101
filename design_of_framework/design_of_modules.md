# 模块设计

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

