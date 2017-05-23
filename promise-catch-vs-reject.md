## **背景**

今天在一个技术群里被问到 _**Promise 中 .then 的第二个参数与 .catch有什么区别？ **_在我的脑海里，catch是这样用的

```js
var p = new Promise(function (resove, reject){

   throw new Error('hehe');
})

p.then(function success(e){
    console.log(e);
}, function fail(e){
    console.log(e);
}).catch(function (e){
    console.log(e); // 认为这里会打印hehe，是一个兜底处理异常的方式
})
```

其实不是的，promise作为一个链式处理时，这里的catch实际作用对象是p.then返回的promise，而非p实例。实际是

```js
var p = new Promise(function (resove, reject){

   throw new Error('hehe');
})

p.then(function success(e){
    console.log(e);
}, function fail(e){
    console.log(e); // 实际这里会打印hehe
}).catch(function (e){
    console.log(e); // 这里不执行
})
```

# reject  vs _**catch**_

引用标准文档[https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global\_Objects/Promise/catch](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/catch)

_The catch\(\) method returns a Promise and deals with rejected cases only. It behaves the same as calling Promise.prototype.then\(undefined, onRejected\)._

**其实reject跟catch是一个东西，无论throw 还是reject 都会执行onRejected调用。它们的区别在于throw不能用于异步调用中**

如下代码所示，catch回调是**不执行的**

```js
var p1 = new Promise(function(resolve, reject) {
  setTimeout(function() {
    throw 'Uncaught Exception!';
  }, 1000);
});

p1.catch(function(e) {
  console.log(e); // This is never called
});
```

而reject回调是执行的

```js
var p2 = new Promise(function(resolve, reject) {
  setTimeout(function() {
    reject('oh, no!');
  }, 1000);

});

p2.catch(function(e) {
  console.log(e); // "oh, no!"
})
```

深入理解 [javascript异步异常处理](/javascript-asynchronous-exception-handling.md)

# 参考

[https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global\_Objects/Promise/catch](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/catch)

