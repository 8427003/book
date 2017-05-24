# 理解javascript 异步代码异常不能被捕获

## 背景

你有一个代码块可能抛出异常，于是在代码块外层用try..catch来捕获异常。这在同步代码中没有问题，但是异步代码中使用try..catch会导致程序退出。你仅仅被告诉不要在异步代码中使用try..catch，但不知道其中的原理！

```js
try {
    setTimeout(function(){ 
        throw "exception"
    }, 1000)
}
catch(e){
    console.log(e);
}
//不能捕获异常，且会导致程序异常
```

## 理解异常模型

try..catch这种语法**通常是在高级语言中出现**（c语言没有try..catch\)。我们可以大致猜想，在脚本语言（比如javascript\)中，try..catch的实现应该是**脚本解释器完成的**。这个语法的行为有点类似于goto语句，当程序往下执行到throw 语句时，跳转到去执行catch部分的代码指令。

```js
try {
    console.log(1);
    throw "exception";
    console.log(2);
}
catch(e) {
    console.log(3);
    console.log(4);
}
```

这段代码看起来像这样的执行顺序

![](/assets/try-catch-2.png)

当解释器在执行try block 内指令时，如果遇到throw 语句，或者程序执行异常，就会跳转到对应catch block。模型只是用来帮助理解异常的，让你并不害怕它。模型中我们提到一个重要概念，**1.try-catch通常（注意在这里是“通常”）高级语言才有，由脚本解释器（或者运行时环境）层实现。 2.在try block 内才跳转到对应的catch block 块。**对于后面的概念理解有很大帮助。

#### 

## js中异步代码为何捕获不到异常

js 的异步跟事件循环有莫大关系，事件循环伪代码如下

```cpp
var event;
while (event = getNextEvent()) { // 一直循环是否有事件
    getListeners(event).forEach(function(listener){ //一个事件可以绑定多个listener，所以是循环这里！
        listener(event);
    });
}
```

js中执行一个异步代码块，实际会经历多次事件循环。我们把先前的异步代码切分成两份，**蓝色**部分和**红色**部分。

![](/assets/try-catch-splite-2.png)

伪代码分两次事件循环执行如下：

```cpp
// 第一次循环时执行蓝色部分
var event;
while (event = getNextEvent()) { 
    getListeners(event).forEach(function(listener){ 
       try {
            setTimeout(..., 1000)
        }
        catch(e){
            console.log(e);
        }
    });
}

// 第二次循环时执行红色部分
var event;
while (event = getNextEvent()) { 
    getListeners(event).forEach(function(listener){ 
       throw "exception"
    });
}
```

当第一次进入事件循环时，try block 里的指令`setTimeout`表示此次不执行函数参数里的指令，延长1000毫秒执行。基于事件循环机制，这将会把函数参数里的指令块`throw "exception"`放到下一次循环，或者下下一次循环（这主要看延迟多少时间执行了）。当执行完`setTimeout`时，意味着try block 内所有指令执行完毕（这里try block 块里只有一条指令），此时是没有抛出任何异常。所以没有执行catch block里的指令。

假设当第二次进入事件循环时，执行到throw指令，此时发现并没有一个try..catch为它“服务”了。此时程序也不会再往下执行，整个事件循环终止，程序异常退出。这就是try..catch 捕获不到异步执行抛出的异常的原因。

#### 此时我们要问，throw 把异常抛到什么地方去了，怎样才能捕获这种异常？

1.抛到什么地方去了？

有人说抛到**全局**去了。全局这个概念很模糊，浏览器的全局是window对象。当我们对`window.addEventListener('error', function(e){});`一样捕获不到异常。个人理解，异常抛出并没有抛到某个地方的说法。异常的抛出跟try相关，如果执行的指令在try block 内抛出异常，那么异常后面指令不会被执行，转而执行对应的catch block内指令。如果最外层都找不到一个try block，那么程序异常抛出时意味着整个程序终止。但我相信如果业务层代码没有catch异常，那么它的底层比如运行时层（或者说脚本解释器层）也会捕获，如果这层还没有，那么操作系统层也有对应捕获异常机制以便告诉我们程序真的执行不下去了。

2.怎样才能捕获这种异常

拿js举例，我们只有在事件循环代码层作手脚才行，如下代码所示

```cpp
try {
    var event;
    while (event = getNextEvent()) { // 一直循环是否有事件
        getListeners(event).forEach(function(listener){ //一个事件可以绑定多个listener，所以是循环这里！
            listener(event);
        });
    }
}catch (e) {
    
}
```

在想想办法，怎么把捕获到的这种异常返回到js层。nodejs 里处理异常有个模块[domain](https://nodejs.org/dist/latest-v7.x/docs/api/domain.html)，虽然没有看它实现原理，但大胆猜想它的实现应该和我们的思路差不多（只是猜想，不对请指正）。



## 参考

https://nodejs.org/dist/latest-v7.x/docs/api/domain.html

https://bytearcher.com/articles/why-asynchronous-exceptions-are-uncatchable/

