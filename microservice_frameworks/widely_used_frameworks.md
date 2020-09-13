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

Helidon微服务框架是由Oracle开发的，它包含了一系列的Java库来写微服务。Helidon有两个版本，Hlidon MP以及Helidon SE。拿Helidon和Spring Boot做个对比，Spring Boot在很多地方要做的更好，Helidon相比来说还是一个比较“年轻”的框架，文档也不是很健全，遇到问题定位、解决起来会比较困难。

Helidon SE采用了最新Java SE的特性（响应式stream、异步编程、函数编程、流式API等），实现了一个精简的工具集。Helidon SE支持GraalVM native镜像，占用空间小，启动超快。Helidon SE中Helidon WebServer提供了REST的支持，基于Netty构建，采用了一种简单直接的请求路由API。

下面是Helidon MP构建微服务的一些特点：

* 云原生支持：可与云原生场景下的一些流行工具进行互操作，如docker、k8s、prometheus、opentracing、etcd；
* gRPC支持：Helidon gRPC Server支持创建gRPC应用程序；
* 配置管理：配置组件提供了一个Java API来加载、解析配置（kv形式的）；
* 健康检查：支持通过外部工具（如k8s）来定期检查、报告服务健康状态；
* 分布式跟踪：Helidon内部通过标准的Opentracing API包含了对tracing的支持，tracing已经集成到了WebServer、gRPC Server、Security等组件中；
* 安全性：支持认证（Authentication）、授权（Authorization）、审计（Audit）；

## GoMicro \(Golang Microservices framework\)

![GoMicro](../.gitbook/assets/image%20%2820%29.png)

Go Micro是一个支持可插拔的微服务框架，它支持服务发现（通过consul实现）、支持http通信、支持Google Protocol Buffer、JSON序列化，也支持发布订阅模式。

Go Micro解决了构建可扩展系统的一些关键问题。它采用微服务架构模式并将其转换为一组工具，这些工具充当平台的构建块。Micro处理分布式系统的复杂性，并建立了一些开发人员容易理解的抽象设计。

技术在不断发展，技术栈也总是在变化的，Micro通过可插拔的插件来解决此类问题，想构建面向未来的系统可以考虑Go Micro。

Go Micro具有如下一些特点：

* API网关：Micro的API提供了强大的请求路由能力，主要是借助服务发现以及可插拔的handlers，能够支持http、grpc、websockets、发布事件等；
* 交互式命令行：该工具提供了一些命令来帮助我们了解Micro微服务运行的具体情况；
* 服务代理：通过Go Micro构建的一个透明代理，整合服务发现、负载均衡、编解码、中间件、transport、消息broker等插件，可以独立运行，也可以随应用一起运行；
* 服务模板：根据协议描述文件快速生成服务模板，只需简单几个步骤就可以快速投入到编码过程中。每次开发新的Go Micro服务也总是相同的操作流程，习惯之后非常方便；
* Slack机器人：提供了一个Slack机器人，允许在您的平台上运行，并让您从Slack中轻松管理应用程序。该微型机器人启用了ChatOps，并使您能够通过消息与团队一起完成所有工作；
* Web仪表盘：使您可以浏览服务，描述其endpoint、请求和响应格式，甚至直接查询它们。

准确地说，Go Micro并不只是一个框架，或者一个工具集，它提供了一个相对比较完整的生态，如丰富的插件支持、Slack机器人、Web仪表盘等这些关乎业务定制化、运维效率、服务质量的相关建设。如果技术栈是Go的话，可以考虑选择Go Micro。

## Moleculer \(NodeJS Microservices framework\)

![Moleculer](../.gitbook/assets/image%20%2827%29.png)

Moleculer是一个基于NodeJS开发的微服务框架，NodeJS现在很流行，如果你或者团队技术栈是JavaScript的话，那么Moleculer这个框架就很合适，它也是一个快速、现代、强大的微服务框架，可以帮助构建高性能的、可靠的、可扩展的服务。

Moleculer的几个主要特点：

* 事件驱动架构；
* 内置的服务注册、动态服务发现；
* 请求负载均衡（基于roundrobin、random、cpu使用率、latency、sharding等）；
* 容错能力（断路器、隔板、重试、超时、降级等）；
* 内置的缓存方案（内存缓存、内存LRU缓存、Redis等）；
* 可插拔的logger实现（Console、File、Pino、Bunyan、Winston、Debug、Datalog、Log4js）；
* 内置的metrics，支持对接不同监控平台；
* 内置的tracing，支持对接不同分布式跟踪平台（Console、datalog、Event、Jaeger、Zipkin）；

## Quarkus Microservices framework

![Quarkus](../.gitbook/assets/image%20%2826%29.png)

这个框架是相当新的，非常适合Kubernetes爱好者。Quarkus是Red Hat开发的微服务框架，用于编写Java应用程序，另外，它推崇云原生、容器优先。Quarkus是专为GraalVM和HotSpot量身定制的Kubernetes原生Java框架，它是由同类最佳的Java库和标准共同精心打造的。Quarkus的目标是使Java成为Kubernetes和Serverless环境中的领先平台，同时为开发人员提供统一的编程模型，更好地解决分布式应用架构问题。

更多相关信息可以参考：[https://www.thoughtworks.com/radar/languages-and-frameworks/quarkus](https://www.thoughtworks.com/radar/languages-and-frameworks/quarkus)。

## Micronaut framework

![Micronaut](../.gitbook/assets/image%20%2814%29.png)

Micronaut是一个现代的、基于JVM的、全栈式的微服务框架，用于构建模块化、易测试的微服务程序。

Micronaut是由Grails框架的创建者开发的，并且吸收了多年来从单体架构演变到微服务架构过程中Spring、Spring Boot、Grails构建微服务的一些好的思想。

Micronaut主要致力于提供一些必要的能力来构建功能完备的微服务程序，包括：

* 依赖注入（DI）和控制反转（IoC）；
* 合理的默认配置、自动配置；
* 配置和配置共享；
* 服务发现；
* HTTP请求路由；
* HTTP client，支持客户端负载均衡；

同时Micronaut也避免了Spring、Spring Boot、Grails框架的一些不足之处，Mironaut提供了：

* 快速启动；
* 减少内存占用；
* 尽量少用反射；
* 尽量少用代理；
* 单测更简单；

## Lightbend Lagom Microservices framework

![Lagom](../.gitbook/assets/image%20%2822%29.png)

Lagom是一个开源框架，使用Java、Scala来构建响应式微服务，Lagom构建在[Akka](https://akka.io/)和[Play](https://www.playframework.com/)之上，这些都是在生产环境中接受过检验的技术。

Lagom还提供了一个集成开发环境，允许开发人员将关注点聚焦在业务逻辑处理上，而不是将多个服务绑定在一起。一行命令就可以完成工程构建、组件的启动、服务的启动，以及准备好整个Lagom基础设施。程序运行期间，如果检测到代码有变动，会自动重新编译并完成热加载。

使用Lagom创建的大小合适的微服务，使得我们可以：

* 更好地定义服务职责边界，方便团队维护，有助于“敏捷”；
* 能以较低风险更频繁快速地交付，有助于快速产品完善投放市场；
* 具有响应质量的系统：响应式、弹性、可伸缩性和弹性，有助于充分利用现代计算环境并满足苛刻的用户期望；

## AxonIQ Microservices framework

![AxonIQ](../.gitbook/assets/image%20%2824%29.png)

Axon提供了一种统一、高效的开发Java应用程序的方法，该Java应用程序可以在无需大量重构的情况下从单体式架构演进为事件驱动的微服务架构。

Axon同时包含编程模型和专用的基础设施，这些配套的基础设施提供了企业级的运营支持，尤其是在扩展和分发关键业务应用程序时。 Axon框架提供了编程模型，而Axon Server是Axon的基础，全部开源。

Axon Framework是一个Java微服务框架，可帮助您根据域驱动设计（DDD）原则构建微服务架构。除了DDD外，Axon Framework还允许您实现微服务模式，例如命令-查询-责任-隔离（CQRS）和事件驱动的架构。

Axon能够满足最苛刻的企业要求，例如存储扩展、安全性、集群、负载平衡、服务发现、全球分布的数据中心、第三方集成、指标监控metrics和监视等等。

## Ballerina Microservices Language

![Ballerina](../.gitbook/assets/image%20%2821%29.png)



Ballerina并不是一个微服务框架，而是一个用来编写分布式程序的分布式编程语言。使用Ballerina可以构建松耦合的微服务，使用它来编写一些网络程序是非常方便的。Ballerina是一个开源的编程语言，也是一个云时代背景下开发人员用来构建分布式软件的平台吧。

Ballerina包含了很多对线程、流式、安全等方面的支持，篇幅原因就不展开了，从整体来看，Ballerina主要提供了：

* 用于网络请求、提供网络服务的语言级别的程序结构；
* 用于并发、网络交互相关的抽象和语法，这些可表示成时序图，支持源码文本和时序图的互相转换；
* 提供了更灵活的结构化类型系统，和传统的静态类型语言相比，耦合度更低；
* 支持更现代的研发周期，提供了包括持续集成、持续交付（CI/CD）相关的工具如Jenkins、Travis、Codefresh，还有系统观测工具如Prometheus、Zipkin、Honeycomb，还有面向云的容器编排工具如K8S。

本节对业界比较流行的微服务框架进行了简单的总结和对比，可以看到它们有很多的共性，也有自己特有的微创新。正所谓能工模型、巧匠窃意，能认识到别人工作的价值，并综合起来为自己所用，更好地服务于业务才是最重要的。

## 参考文献

1. Top 10 Microservice Frameworks for 2020, [https://medium.com/microservices-architecture/top-10-microservices-framework-for-2020-eefb5e66d1a2](https://medium.com/microservices-architecture/top-10-microservices-framework-for-2020-eefb5e66d1a2)
2. Awesome Microservices, [https://github.com/mfornos/awesome-microservices\#platforms](https://github.com/mfornos/awesome-microservices#platforms)
3. Microservices with Oracle Helidon, [https://www.baeldung.com/microservices-oracle-helidon](https://www.baeldung.com/microservices-oracle-helidon)
4. Go Micro, [https://github.com/micro](https://github.com/micro)
5. Microservices in Go using Micro, Brian Ketelsen, [https://www.youtube.com/watch?v=OcjMi9cXItY](https://www.youtube.com/watch?v=OcjMi9cXItY)
6. Quark, [https://www.thoughtworks.com/radar/languages-and-frameworks/quarkus](https://www.thoughtworks.com/radar/languages-and-frameworks/quarkus)
7. Lagom, [https://www.lagomframework.com/](https://www.lagomframework.com/)
8. Ballerina, [https://ballerina.io/](https://ballerina.io/)

