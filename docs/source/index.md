![Book Cover](./book-cover-mockup.jpg)

# 前言

## 本书概述

本书名为《Envoy 内幕》，英文名《Envoy Proxy Insider》。这是一本编写中的书，现在草稿阶段。它是一本专注于 Envoy Proxy 机制和实现深入探讨的书。内容主要源于我之前写的《[Istio & Envoy 内幕》](https://istio-insider.mygraphql.com/zh-cn/latest/)一书。现在把 Envoy 部分单独抽出来，重新整理成一本书。这样做的目的是为了让读者更专注于 Envoy 的内容，而免受 Istio 的干扰。有些内容也是 Istio 无关或不适用的。所以现在独立成书。**以后《Istio & Envoy 内幕》一书将只更新 Istio 相关的内容。而把 Envoy 相关的内容更新都移到这本书《Envoy 内幕》上。**

### 本书是什么

本书内容包括：Envoy 源码分析、深入 Envoy 基本原理解构与分析。但不是一本传统的《深入 xyz 源码》类型的书。甚至可以说，我尽了最大的努力少在书中直接贴源码。看源码是掌握实现细节必须的一步，但在书中浏览源码的体验一般非常糟糕，本书更多使用源码导航图来让读者了解实现的全流程，而非迷失于碎片式的源码片段细节当中而忘记全貌。

本书中，我尝试以设计与实现角度，尽量系统地去说明：
- Envoy 设计/进化的原由
- Envoy 的设计与实现细节


书里说的，只是在我研究与使用了 Istio 一段时间后，的思考与记录。我只是排查过一些 Istio/Envoy 相关的功能与性能问题，浏览和 Debug 过一些 Istio/Envoy 的代码。

在研究 Istio 过程中。发现网上是有很多非常有价值的资讯。但是，要么主要是从使用者出发，没说实现机理；要么就是说了机理，也说得很好，但内容缺少系统化和连贯性。

### 本书不是什么

本书不是一本使用手册。更不是从使用者角度，教如何深入浅出学习 Envoy。不会布道 Envoy 有如何如何强大之功能，更不会教如何使用 Envoy

> 🤷 : [Yet, another](https://en.wikipedia.org/wiki/Yet_another) Envoy User Guide?  
> 🙅 : No!



### 读者对象

本书主要讲 Envoy 的设计、实现机制。假设读者已经有一定的 Envoy 使用经验。并有兴趣进一步研究其实现机理。

### 书的访问地址

- [https://envoy-insider.mygraphql.com](https://envoy-insider.mygraphql.com)
- [https://envoy-insider.readthedocs.io](https://envoy-insider.readthedocs.io)
- [https://envoy-insider.rtfd.io](https://envoy-insider.rtfd.io)



本书同步在以下平台发布：

- [Envoy Insider English Edition on Amazon Kindle](https://www.amazon.com/dp/B0D6KZ3RNN)
- [《Envoy 内幕》中文版本 @ salttiger.com](https://salttiger.com/istio-envoy-%e5%86%85%e5%b9%95/#more-22178)



在这里感谢 https://salttiger.com/ 站长为本书提供了更多被读者了解的机会。在大平台被垄断的时代，为知识提供了一个平凡人可及的平台更是难得。



### 关于作者

我叫 Mark Zhu，一个中年且头发少的程序员。我不是 Envoy 专家，充其量只是 Envoy Docs 的 Contributors。连互联网大厂员工也不是。

为什么水平有限还学人家写书？因为这句话：
> 你不需要很厲害才能開始，但你需要開始才會很厲害。

Blog: [https://blog.mygraphql.com/](https://blog.mygraphql.com/)  
为方便读者关注 Blog 与本书的更新，开了个同步的 微信公众号：Mark的滿紙方糖言

:::{figure-md} 微信公众号: Mark的滿紙方糖言

<img src="_static/my-wechat-blog-qr.png" alt="my-wechat-blog-qr.png">

*微信公众号: Mark的滿紙方糖言*
:::




### 参与编写
如果你也对编写本书有兴趣，欢迎联系我。本书的出发点不是刷简历，也没这个能力。而且，这样的非`短平快` 且 `TL;DR` 书籍注定是小众货。


#### 感谢提出 Issue 的同学 🌻
- [使众行者](https://github.com/tanjunchen)：对阅读体验和排版提出很多非常好的意见。

### Dedication 💞

First, to my dear parents, for showing me how to live a happy
and productive life. To my dear wife and our amazing kid – thanks for all your love and patience.

### Copyleft 声明
无论是文字还是图片，如果转载或修改，请注明原出处。

### 意见反馈

由于自称是开源交互图书，读者的反馈当然非常重要。如果你发现书中的错误，或者有更好的建议，不妨来这里提 Issue:  
[https://github.com/labilezhu/envoy-insider/issues](https://github.com/labilezhu/envoy-insider/issues)



## English version

There is an English version: [https://envoy-insider.mygraphql.com/en/latest/](https://envoy-insider.mygraphql.com/en/latest/)


![](wechat-reward-qrcode.jpg)

![Book Cover](./book-cover-800.jpg)


# 目录


```{toctree}
:caption: 目录
:maxdepth: 5
:includehidden:

ch0/index
envoy-overview.md
envoy-istio-conf-eg.md
envoy-high-level-flow/envoy-high-level-flow.md
arch/arch.md
req-resp-flow-timeline/req-resp-flow-timeline.md
connection-life/connection-life.md
envoy-istio-metrics/index.md
upstream/upstream.md
socket/socket.md
performance/performance.md
disruptions/disruptions.md
observability/observability.md
troubleshooting/troubleshooting.md
dev-envoy/dev-envoy.md
```
