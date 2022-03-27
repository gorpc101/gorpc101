# Table of contents

- [作者简介](Author.md)

* [本书简介](README.md)
* [本书前言](preface.md)

## 第1章 服务架构演变

* [软件服务架构演变](1-architectures/evolution_of_architectures.md)
* [微服务架构优势及挑战](1-architectures/pros_and_cons.md)

## 第2章 微服务框架调研

* [框架该如何选型](2-research/howto-choose-framework.md)
* [流行微服务框架](2-research/widely_used_frameworks.md)
* [自研微服务框架](2-research/why_develop_another_one.md)

## 第3章 微服务框架设计

* [设计目标](3-framework/design-goal.md)
* [设计方法](3-framework/design-methods.md)
* [整体设计](3-framework/arch-overview.md)
* [模块设计](3-framework/modules/README.md)
  * [config](3-framework/modules/config.md)
  * [logging](3-framework/modules/logging.md)
  * [errors](3-framework/modules/errors.md)
  * [codec](3-framework/modules/codec.md)
  * [...]
* [打磨设计](3-framework/design-review.md)
  * [...]

## 第4章 微服务框架实现

* [框架实现](4-devel/modules/README.md)
  * [helloworld](4-devel/modules/helloworld.md)
  * [errs](4-devel/modules/errs.md)
  * [server](4-devel/modules/server.md)
  * [client](4-devel/modules/client.md)
  * [transport](4-devel/modules/transport.md)
  * [codec](4-devel/modules/codec.md)
  * [log](4-devel/modules/log.md)
  * [config](4-devel/modules/config.md)
  * [naming](4-devel/modules/naming.md)
  * [plugin](4-devel/modules/plugin.md)
  * [filter](4-devel/modules/filter.md)
  * [admin](4-devel/modules/admin.md)
  * [metrics](4-devel/modules/metrics.md)
  * [pool](4-devel/modules/pool.md)
  * [...]
* [服务demo](4-devel/examples/README.md)
  * [demo1](4-devel/examples/demo1.md)
  * [demo2](4-devel/examples/demo2.md)
  * [demo3](4-devel/examples/demo3.md)
  * [...]

## 第5章 微服务框架优化

* [内存分配优化](5-optimize/mem/README.md)
  * [socket收发包buffer分配优化]
* [网络相关优化](5-optimize/network/README.md)
  * [tcpclient连接池连接管理优化]
  * [tcpclient连接复用多发多收]
  * [tcpserver空闲连接检测剔除优化]
  * [udpserver端口重用网络性能优化]
  * [超大连接数管理go/net性能优化]
* [RPC相关优化](5-optimize/rpc/README.md)
  * [重试对冲]
  * [模调监控]
  * [可观测性]
* [健壮性优化](5-optimize/robustness/README.md)
  * [tcpserver过载保护优化]
  * [服务SIGUSR2热重启优化]
* [安全性优化](5-optimize/security/README.md)
  * [模块鉴权]
  * [认证鉴权]
* [协议层优化](5-optimize/codec/README.md)
  * [最大包大小限制]
  * [协议包魔数校验]
  * [...]
* [其他优化](5-optimize/other/README.md)

## 第6章 框架研发质量

* [交付前必验证](6-quality/testing/README.md)
  * [单元测试](6-quality/testing/unit_test.md)
  * [基准测试](6-quality/testing/benchmark.md)
  * [集成测试](6-quality/testing/ji-cheng-ce-shi.md)
  * [压力测试](6-quality/testing/ya-li-ce-shi.md)
* [流程必规范化](6-quality/automate_the_workflow.md)
* [科学版本管理](6-quality/version.md)
* [珍视用户反馈](6-quality/feedback.md)

## 第7章 框架生态建设

* [完善框架文档](7-ecosystem/documentation.md)
* [代码生成工具](7-ecosystem/generator.md)
* [协议管理平台](7-ecosystem/protomgr.md)
* [丰富插件生态](7-ecosystem/plugins.md)
* [引领最佳实践](7-ecosystem/practices.md)
* [保持社区活跃](7-ecosystem/community.md)

## 第8章 开源协作管理

* [项目贡献方式](8-cooperation/contribution.md)
* [规划及里程碑](8-cooperation/milestone.md)
* [代码版本控制](8-cooperation/cvs.md)
* [Git Workflow](8-cooperation/workflow.md)
* [做好代码评审](8-cooperation/codereview.md)
* [培养新贡献者](8-cooperation/newbies.md)
* [有理有据说不](8-cooperation/sayno.md)

***

## [致谢](thanks/README.md)

## 附录

* [参考文献](appendix/references.md)
