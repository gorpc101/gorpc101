# 软件服务架构演变

## 简介

服务架构的演变，并不是偶然，它是由诸多因素共同驱动的，比如要解决的问题规模、团队采用的技术栈、追求更快速的交付，希望保证可维护性、可扩展性、可伸缩性，等等。这些因素决定了我们必须要在软件架构上进一步优化，才能应对面临的挑战。

大致上，软件服务架构经历了单体架构、SOA架构、微服务架构这几种形式。

## 单体架构

单体架构，指的是在一个应用程序中打包业务场景涉及到的所有功能。如将一个电商系统完整打包在一个WAR包，然后在Web容器中运行。

当软件规模不是很大的时候，单体架构是比较合适的，开发、测试、部署、监控等相对来说也是比较方便的。但是随着软件规模的扩大，变得比较或者很复杂，情况就会发生改变。

* 新人很难快速掌握，很难快速支持新特性开发、调整、优化；
* 多个团队负责、同时开发，代码冲突、测试冲突问题频发，影响开发效率；
* 采取集群部署来提升并发处理能力，单体应用难以细粒度伸缩，如A、B模块扩容不同节点数；
* 云计算如日中天，服务上云成为趋势，单体应用每次变更、升级都要完整部署整个应用，效率低；
* 单体应用一般采用相同的技术栈，不能灵活选择更合适的技术来解决个别部分的问题；
* 其他；

单体架构有它的简单的优势，这个我们是很容易体会到的。但是，还是要结合业务场景、未来规划来科学评估系统复杂度、未来支撑业务量级以对软件架构做出更科学合理的规划。

## SOA架构

## 微服务架构



## 参考文献

1. Micro Services - Java the Unix Way, [http://2012.33degree.org/pdf/JamesLewisMicroServices.pdf](http://2012.33degree.org/pdf/JamesLewisMicroServices.pdf)
2. Micro-Service Architecture, [https://archive.oredev.org/oredev2012/2012/sessions/micro-service-architecture.html](https://archive.oredev.org/oredev2012/2012/sessions/micro-service-architecture.html)
3. Microservices: A Definition of this New Architectural Term, [https://martinfowler.com/articles/microservices.html](https://martinfowler.com/articles/microservices.html)

