# 流行微服务框架

![](../.gitbook/assets/image%20%2815%29.png)

现在来看，微服务框架或者可以用来写微服务的组件包，真的是非常多，有很多甚至闻所未闻。思考了下，一方面是因为技术栈的原因，对技术栈以外的框架确实涉猎没有那么多，另一方面是因为真的是数量太多了。很多微服务框架的诞生都是源自微创新的驱动，并不是很有必要去深入了解太多。

当然，了解微创新的问题背景、解决问题的思路，我认为是很有趣的。正是“能工模型，巧匠窃意”。

## Spring Boot with Spring Cloud

![Spring Framework](../.gitbook/assets/image%20%2828%29.png)

Spring Boot是用于编写微服务的一个流行的Java框架，它提供了各种扩展以助力构建全栈微服务。 Spring Boot可以通过从多个协作组件的组合协作来实现一个简单的应用，并支持进一步构建更大型的系统。它可以用于构建小型和大型系统。通过控制反转（IoC），Spring Boot也很容易与其他流行的框架集成。

Spring Boot本身对各层次进行了抽象设计，通过插件的方式来实现定制化扩展，如：

* 数据管理层面，借助Spring JDBC、Spring JPA、Spring MongoDB、Spring Apache Cassandra等于各类存储组件进行对接；
* 失败策略层面，通过集成Resilience4J来支持分布式系统中的故障处理，支持熔断、重试、超时、频控、降级（fallback handler）、隔板（bulkhead）等；
* 可观察性层面，Spring Boot Actuator支持运行时健康检查、查看日志、Metrics；
* 网络通信层面，Spring可以构建响应式（reactive）应用程序，通过Spring MVC构建Rest API也容易，与MQ可以很方便地集成以构建异步工作模式的服务，还具有构建SOAP应用程序的模块支持；
* 消息中间件层面，支持通过插件与Apache Kafka、AMQP、RabbitMQ、ActiveMQ集成；
* 监控平台层面，支持通过插件与Consul、Prometheus、Jaeger、Grafana集成；
* 云原生层面，它也易于在docker、k8s上部署，也支持opentracing、etcd、DevOps；
* 安全性层面：Spring Security对OAuth2、会话管理也都有支持，易于构建有状态和无状态的服务、Key Vault、网关模式；
* 配置管理层面，Spring Cloud Config支持分布式配置管理；
* 服务发现层面，支持客户端、服务端的服务发现；
* 性能相关层面，也支持缓存、负载均衡、集群管理等；
* 数据格式层面，支持常见的JSON、XML等；
* 测试层面，Spring Testing、mock测试、profiling分析测试等；

经过这么多年的发展，Spring Boot已经发展的相当完善，也有非常广泛的应用，并且因为是模块化的，相对来说学习难度也不大。

## Eclipse Vert.X Microservices framework

![Vert.X](../.gitbook/assets/image%20%2816%29.png)

另一个流行的微服务服务框架Vert.X，它出自Eclipse基金金，该框架支持多种编程语言。因此，如果您的研发团队拥有Java、Kotlin、JavaScript技术栈的开发人员，那么此微服务框架应该是他们的理想选择，用Vert.X工具包构建运行在JVM上的响应式微服务。

Eclipse Vert.X是事件驱动和非阻塞的，这意味着应用程序可以使用少量的内核线程来处理大量并发。Vert.X使应用程序可以使用最少的硬件进行扩展。

Vert.X具有如下特点：

* 轻量级：Vert.X核心代码只有650KB大小；
* 高性能：这里有些框架性能的对比，[https://www.techempower.com/benchmarks/](https://www.techempower.com/benchmarks/)；
* 模块化：按需使用Vert.X中的模块；
* 简单但强大：允许简单方便地创建强大的应用程序；

Vert.X是构建轻量级、高性能微服务的理想选择，并且它还支持多语言。Vert.X还海通了各种组件、库来简化构建微服务的工作，这里列几个常见的了解下。

* 服务发现：该组件允许发布、查询、绑定任意类型的服务；
* 熔断器：提供了一种熔断器模式的组件实现；
* 配置：提供了一种可扩展的方式来配置应用程序；
* 集群伸缩：提供开箱即用的集群、高可用方案，集群管理通过集群manager中实现的，默认是Hazelcast，也可使用Apache Zookeeper、Ignite等代替；
* 可观测：健康检查组件提供了一种简单的方式来对外输出检查结果，表明服务状态up/down；
* 测试：Vertx Unit吸取了JUnit、QUnit的的思想，并结合了Vertx中的实践，允许通过多语言API编写异步的单测用例并在JVM中运行；
* 支持gRPC：Vertx gRPC模块支持Google gRPC；
* 服务代理：允许有选择地暴露某个服务给其他服务访问；
* DevOps：Vertx提供了一些组件来保证线上应用程序的正常运行，如Micrometer、Dropwizard等；

和Spring Boot相比，Vertx的一大优势就是它支持多语言版本。

## Oracle Helidon Microservices framework

![Helidon](../.gitbook/assets/image%20%2825%29.png)

## GoMicro \(Golang Microservices framework\)

![GoMicro](../.gitbook/assets/image%20%2820%29.png)

## Moleculer \(NodeJS Microservices framework\)

![Moleculer](../.gitbook/assets/image%20%2827%29.png)

## Quarkus Microservices framework

![Quarkus](../.gitbook/assets/image%20%2826%29.png)

## Micronaut framework

![Micronaut](../.gitbook/assets/image%20%2814%29.png)

## Lightbend Lagom Microservices framework

![Lagom](../.gitbook/assets/image%20%2822%29.png)



## AxonIQ Microservices framework

![AxonIQ](../.gitbook/assets/image%20%2824%29.png)

## Ballerina Microservices Language

![Ballerina](../.gitbook/assets/image%20%2821%29.png)





## 参考文献

1. Top 10 Microservice Frameworks for 2020, [https://medium.com/microservices-architecture/top-10-microservices-framework-for-2020-eefb5e66d1a2](https://medium.com/microservices-architecture/top-10-microservices-framework-for-2020-eefb5e66d1a2)
2. Awesome Microservices, [https://github.com/mfornos/awesome-microservices\#platforms](https://github.com/mfornos/awesome-microservices#platforms)
3. Ballerina, [https://ballerina.io/](https://ballerina.io/)

