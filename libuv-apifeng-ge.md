# libuv-helloworld

### io事件通知模型
libuv 是nodejs衍生出来的一个库。关于io事件，历史上操作系统有两种处理模型。通俗讲就是当有一个io消息来时，操作系统如何通知你？

第一种方式，进程阻塞。操作系统初期，当你有一个可读或者可写io时，一般会搞一个新的进程，当你系统调用read 或者write时会被阻塞住，操作系统会标记这个进程为阻塞进程。当io完成后，操作系统会把标记为阻塞的进程标记去掉。这样，你的进程将进入待执行队列。当然还有一种情况时非阻塞的，就是read或者write时，直接返回。但是需要你自己去死循环check这个io操作是否有新的状态。

第二种方式，多路复用。后来啊，人们觉得前一种方式搞了太多的进程或者线程出来。进程间切换，以及进程本身需要占用一定量内存开销。这对于当有大量高并发io场景比较吃力。所以操作系统提供了第二种方式，多路复用。即操作系统提供了另外一种api，select。这个api一次可以监听多个io 描述符。io有状态变化时才通知用户进程。就不需要开辟很多进程了。当然随着对性能要求更高，操作系统不断优化api，从select 到poll，再到epoll等等。

咱们nodejs当然会选择后一种事件模型，但是有个问题，刚才说epoll这种只是linux的。其它平台有自己的实现。比如其它类unix的是Kqueue，window是IOCP。最开始nodejs选择libev的库,这个库不兼容windows平台。所以自己搞了一个libuv。
参考：http://nikhilm.github.io/uvbook/introduction.html

### libuv api风格

libuv helloworld代码
```
#include <stdio.h>
#include <stdlib.h>
#include <uv.h>

int main() {
    uv_loop_t *loop = malloc(sizeof(uv_loop_t));
    uv_loop_init(loop);

    printf("Now quitting.\n");
    uv_run(loop, UV_RUN_DEFAULT);

    uv_loop_close(loop);
    free(loop);
    return 0;
}
```

libuv timer
```
  
#include <assert.h>
#include <sys/time.h>
#include "uv.h"


// gcc -Wall timer.c -o  timer -luv

int repeat_cb_called = 0;

static long timestamp() {    
    struct timeval tv;
    gettimeofday(&tv,NULL);
    return tv.tv_sec*1000 + tv.tv_usec/1000;  //毫秒
}

static void repeat_close_cb(uv_handle_t* handle) {
    printf("REPEAT_CLOSE_CB\n");
}


static void repeat_cb(uv_timer_t* handle) {
    printf("[%ld]REPEAT_CB %d \n",timestamp(),repeat_cb_called+1);
  
    assert(handle != NULL);
    assert(1 == uv_is_active((uv_handle_t*) handle));
  
    repeat_cb_called++;
  
    if (repeat_cb_called == 5) {
      uv_close((uv_handle_t*)handle, repeat_close_cb);
    }
}


int main() {
    uv_timer_t once;
    int ret;
    ret = uv_timer_init(uv_default_loop(), &once);
    printf("[%ld]start timer\n",timestamp());
    ret = uv_timer_start(&once, repeat_cb, 100,1000); // 100毫秒之后第一次触发，之后的每1000毫秒触发一次
    uv_run(uv_default_loop(), UV_RUN_DEFAULT);
    // uv_run(uv_default_loop(), UV_RUN_ONCE); // 只运行一次
}
```
从上面两个例子中，我们找出了规律。
**第一，你会发现一个uv_xxx_t结构体，并且一定有一个uv_xxx_init。**
**第二，从下面的参考更多例子中，你会发现有很多这样的结构体，why？**

我们先回答第一个问题，其实答案已经在第一个代码demo中。c语言风格的程序，内存管理需要透明。这种设计可以使我们自由为uv_xxx_t分配以及释放内存。

第二个问题，为啥有一堆uv_xxx_t这样的结构体呢? libuv从用户角度划分了多种业务类型。但是这些业务类型又不能高度抽像为同一个结构体比如timer 和 tcp 肯定有不同的业务属性，所以抽像了不同的结构体。

# 参考：

官方文档

http://docs.libuv.org/en/v1.x/api.html

基本概念，自定义的内存管理

https://github.com/feixiao/Chinese-uvbook/blob/master/source/basics_of_libuv.md

更多例子
https://github.com/feixiao/learning-libuv/blob/master/ReadMe.md