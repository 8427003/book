# 理解javascript 异步中异常不能不捕获

#### 背景

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

**我们不禁会问，异步代码中，throw 抛出的异常为何捕获不到，它到底抛到什么地方去了？**



#### 理解异常模型

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



![](/assets/exception-run.png)

模型只是用来帮助理解异常的，让你并不害怕它。模型中我们提到一个重要概念，**try-catch通常高级语言才有，由脚本解释器实现。 **

对于后面的概念理解有很大帮助。

#### 

#### 接下来我们看js中异步代码为何捕获不到异常

js 的异步跟事件循环有莫大关系，事件循环伪代码如下

```cpp
var event;
while (event = getNextEvent()) {
    getListeners(event).forEach(function(listener){
        listener(event);
    });
}
```



