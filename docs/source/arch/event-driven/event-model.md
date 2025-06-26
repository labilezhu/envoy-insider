---
typora-root-url:/home/labile/envoy-insider/docs/source
to-be-english: true
---





# 事件驱动框架

## 设计







:::{figure-md} 图: 事件驱动框架设计

<img src="/arch/event-driven/event-driven.assets/event-model.drawio.svg" alt="图: 事件驱动框架设计">

*图: 事件驱动框架设计*
:::
*[用 Draw.io 打开](https://app.diagrams.net/?ui=sketch#Uhttps%3A%2F%2Fenvoy-insider.mygraphql.com%2Fzh_CN%2Flatest%2F_images%2Fevent-model.drawio.svg)*



1. Dispatcher 线程事件循环。`Dispatcher Thread` 等待事件（epoll wait) 并在等待超时或事件发生后处理事件。

2. 有以下事件唤醒 epool wait:

   - 收到线程间 post callback 消息。主要用于 Thread Local Storage(TLS) 的数据更新。如 Cluster/Stats 信息更新
     - Dispatcher 为线程间事件

   - timer timeout 事件

   - file/socket/inotify 事件
   - internal active event。内部其它线程，或者本 dispatcher 线程，程序显式调用函数，触发事件

3. 处理事件

一次事件处理的 loop 过程，包含上面三步。三步完成合称为一个 `event loop` , 有时，也叫 `event loop iteration`。



## 实现

上面主要在 kernel syscall 层面上介绍事件处理的底层过程。下面介绍在 Envoy 代码层面，如何抽象和封装事件。

Envoy 使用了 libevent 这个 C 编写的事件 library。还在其上作了 C++ OOP 方面的封装。


:::{figure-md} 图: Envoy 事件的抽象封装模型

<img src="/arch/event-driven/event-driven.assets/abstract-event-model.drawio.svg" alt="图 - Envoy 事件的抽象封装模型">

*图: Envoy 事件的抽象封装模型*
:::
*[用 Draw.io 打开](https://app.diagrams.net/?ui=sketch#Uhttps%3A%2F%2Fenvoy-insider.mygraphql.com%2Fzh_CN%2Flatest%2F_images%2Fabstract-event-model.drawio.svg)*


如何快速在一个重度（甚至过度）使用 OOP 封装和 OOP Design Pattern 的项目中读懂核心流程逻辑，而不是在源码海洋中无方向地漂流? 答案是：找到主线。 对于 Envoy 的事件处理，主线当然是 `libevent` 的 `event_base` ，`event` 。如果你对 libevent 还不了解，可以看看本书的 `libevent 核心思想` 一节。

- `event` 封装到 `ImplBase` 对象中。 
- `event_base` 包含在 `LibeventScheduler` <- `DispatcherImpl` <- `WorkerImpl` <- `ThreadImplPosix` 下

然后，不同类型的 `event` ，又封装到不同的  `ImplBase` 子类中：
- `TimerImpl` - 基于定时的功能都会使用它。如连接超时，闲置超时等等
- `SchedulableCallbackImpl` - 设计上，在高负载时，Envoy 需要平衡事件处理的响应时间和吞吐量。为平衡每次  `event loop` 的工作量及避免一次 `event loop`处理太久而影响其它未处理事件的响应时效。有的内部发起的、或定时发起的处理过程，可以选择在当前`event loop` 的最后一个完成，也可以 “延后” 到下一个 `event loop` 。`SchedulableCallbackImpl`  封装这种可调度的任务。应用场景有：thead callback post / 请求重试等等
- `FileEventImpl` - file / socket 事件





其它信息上图已经比较详细，不再多言了。





## 扩展阅读

如果有兴趣研究实现细节，建议看看我 Blog 的文章：

 - [逆向工程与云原生现场分析 Part3 —— eBPF 跟踪 Istio/Envoy 事件驱动模型、连接建立、TLS 握手与 filter_chain 选择](https://blog.mygraphql.com/zh/posts/low-tec/trace/trace-istio/trace-istio-part3/)
 - [逆向工程与云原生现场分析 Part4 —— eBPF 跟踪 Istio/Envoy 之 upstream/downstream 事件驱动协作下的 HTTP 反向代理流程](https://blog.mygraphql.com/zh/posts/low-tec/trace/trace-istio/trace-istio-part4/)

与 Envoy 作者 Matt Klein 的： [Envoy threading model](https://blog.envoyproxy.io/envoy-threading-model-a8d44b922310)