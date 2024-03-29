# 框架该如何选型

近些年来涌现出了非常多的微服务框架，其中也不乏国人主导或者深度参与开发的框架。框架之多，令人目不暇接，既看到了不同框架之间的微创新，偶尔也会有些选择困难症。结合团队技术栈及未来业务走向，提前规划、做出更合理的选择是有必要的。

## 影响框架选型的因素

笔者在腾讯工作期间，先后经历了众多的研发框架，C++的就有好几种：ServerBench Plus Plus（简称SPP）、MCP，Go的GoNeat、Going，Java的JavaNeat、Jungle，还有其他语言的。看似很多编程语言都有几种可选项，但是考虑到团队技术栈、业务场景，能达到可用标准的就真的不多了。而这些影响因素，也同样适用于对开源框架的选择。

**有哪些因素需要考虑呢？**

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

开发多语言版本的微服务框架，是需要大量的技术人员的投入才可以实现的，腾讯内部也是通过自上而下为主的全面的技术治理才做到的，而不仅仅是微服务框架，还涉及到微服务的整个运营体系。很多企业团队不一定有这个人力和时间来做这个事情。

有的团队会考虑先用某种语言实现一个相对完整的框架，用它来作为服务端的proxy，然后实现一个多语言版本的相对精简的框架，用来开发业务逻辑处理服务worker。proxy、worker之间可以选择通过共享内存等方式进行通信。通过这种方式简化了开发多个完整多语言框架的工作量。

## 现代微服务治理方案

微服务治理不断进化，现在进化到了**Service Mesh**，目标是**将微服务治理体系下沉为与业务无关的基础设施**。但是不管微服务治理体系如何演进，一个健壮、高性能、可扩展的微服务框架是必不可少的。

或者说，微服务框架所要解决的问题，至少在某个层面上要通过类似的方法去解决，比如Mesh这样，便可以弱化对一个大而全的框架的要求。

以目前比较流行的服务网格解决方案Istio为例，Istio是一个开源的服务网格，它提供了一种简单的方式来管理和控制微服务的网络交互。使用Istio，你可以使用任何你喜欢的编程语言来开发微服务，包括但不限于Java、Go、Python、Node.js、C#等。Istio并不对开发微服务的框架有特定的要求。

在网络通信方面，Istio提供了丰富的特性，包括流量管理、安全性、观察性等。你不需要在你的框架代码中显式地处理这些网络通信的细节，Istio会自动地为你的服务添加一层代理（叫做sidecar），这个代理会拦截所有的进出网络流量，并按照你的配置来管理这些流量。

例如，你可以使用Istio的流量管理规则来实现蓝绿部署、金丝雀发布等高级部署策略。你也可以使用Istio的安全性特性来实现服务间的mTLS通信。此外，Istio还提供了丰富的观察性工具，如日志、指标、追踪等，帮助你更好地理解和监控你的服务。你也不需要在框架中额外支持这些。

总的来说，使用Istio，你可以专注于你的业务逻辑，而将网络通信的复杂性交给Istio来处理。通过将微服务治理体系下沉为基础设施，自然而然降低了对框架大而全的要求。
