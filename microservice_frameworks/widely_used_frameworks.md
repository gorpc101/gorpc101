# 微服务框架一览

近些年来涌现出了非常多的微服务框架，其中也不乏国人主导或者深度参与开发的框架。框架之多，令人目不暇接，既看到了不同框架之间的微创新，偶尔也会有些选择困难症。结合团队技术栈及未来业务走向，提前规划、做出更合理的选择是有必要的。

![](../.gitbook/assets/image%20%2815%29.png)

## 影响框架选型的因素

笔者在腾讯工作期间，先后经历了众多的研发框架，C++的就有好几种：ServerBench Plus Plus（简称SPP）、MCP，Go的GoNeat、Going，Java的JavaNeat、Jungle，还有其他语言的。看似很多编程语言都有几种可选项，但是考虑到团队技术栈、业务场景，能达到可用标准的就真的不多了。而这些影响因素，也同样适用于对业界开源框架的选择。

有哪些因素需要考虑呢（排列部分先后）？

* 团队技术栈是比较纯粹还是比较多元，未来走势；
* 框架可扩展性如何，是否方便定制化；
* 框架生态是否健康，是否有丰富的插件可供选择使用；
* 框架有无专业团队维护，问题响应是否够快；
* 框架性能、健壮性如何，是否满足要求；
* 框架文档、示例是否齐全，方便快速上手；
* 其他；

笔者工作的中心包括了多地多个团队，上百人，有算法、算法工程、后台、前端等多个不同的团队，技术栈包括Python、Java、C++、Go、PHP、Node，未来趋势是朝Python、Go、Node方向演进。

我们希望能发挥不同技术栈同学的长处，同时又避免因为不同技术栈采用的框架的能力无法对齐所引入的运营效率折损。设想下，假如有些框架具备了metrics、tracing等监控能力，但是某些框架缺失这些能力，那对于一个庞大的系统（100+微服务），运营监控将会变得异常困难，将不得不针对这些特殊的服务实例进行额外的改造，如通过监控平台SDK进行metrics、tracing的埋点。即便如此，也大大影响研发效率。

一个经过统筹规划、统一设计、支持多语言版本的微服务框架对我们来说更有吸引力，这样工程同学在涉及到服务交接、服务维护时就会简单很多。很庆幸地是，有幸见证了腾讯tRPC微服务框架的诞生，截止现在推广不到半年已经成功支持了10K+个服务实例的稳定运行。

## 业界流行微服务框架

现在来看，微服务框架或者可以用来写微服务的组件包，真的是非常多，有很多甚至闻所未闻。我思考了下，一方面是因为技术栈的原因，作为一名后端工程师，我的技术栈主要是Go、CC++、Java，对其他语言相关的框架确实涉猎没有那么多，另一方面是因为真的就是太多了，很多微服务框架的诞生都是源自微创新的驱动，并不是很有必要去深入了解太多。

当然，了解微创新的问题背景、解决问题的思路，我认为是很有趣的。“能工模型，巧匠窃意”，说的就是这个意思。

### Spring Boot with Spring Cloud

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

### Eclipse Vert.X Microservices framework

![Vert.X](../.gitbook/assets/image%20%2816%29.png)

### Oracle Helidon Microservices framework

![Helidon](../.gitbook/assets/image%20%2825%29.png)

### GoMicro \(Golang Microservices framework\)

![GoMicro](../.gitbook/assets/image%20%2820%29.png)

### Moleculer \(NodeJS Microservices framework\)

![Moleculer](../.gitbook/assets/image%20%2827%29.png)

### Quarkus Microservices framework

![Quarkus](../.gitbook/assets/image%20%2826%29.png)

### Micronaut framework

![Micronaut](../.gitbook/assets/image%20%2814%29.png)

### Lightbend Lagom Microservices framework

![Lagom](../.gitbook/assets/image%20%2822%29.png)



### AxonIQ Microservices framework

![AxonIQ](../.gitbook/assets/image%20%2824%29.png)

### Ballerina Microservices Language

![Ballerina](../.gitbook/assets/image%20%2821%29.png)





## 参考文献

1. Top 10 Microservice Frameworks for 2020, [https://medium.com/microservices-architecture/top-10-microservices-framework-for-2020-eefb5e66d1a2](https://medium.com/microservices-architecture/top-10-microservices-framework-for-2020-eefb5e66d1a2)
2. Awesome Microservices, [https://github.com/mfornos/awesome-microservices\#platforms](https://github.com/mfornos/awesome-microservices#platforms)
3. Ballerina, [https://ballerina.io/](https://ballerina.io/)

