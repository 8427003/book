# NAN VS N-API 从源码分析差异性

#### 这里我们有必要提下什么是node扩展

node扩展实际上是一个动态库，跟linux 上的.so文件，windows上的.dll文件没有啥本质区别，只是名字变成了.node。可以从nodejs源码得到应证，nodejs通过libuv提供的dlopen接口加载动态库。所以它本质就一个动态库。

#### 原生模块开发方式变迁

**1. 封建时代**  
在最开始我们写nodejs扩展的时候，我们直接引入的是node或者v8的头文件。这样写出来的扩展兼容性差，容易被废弃。由于node，或者v8的版本迭代非常快，所以头文件暴露出来的API有很大程度随着版本的迭代不可用。  
有人可能会说，一般的系统api变化都不是很大，而且可能会向前兼容。对于一个发展成熟的系统的确是这样的。但是光v8来说，由于那个时代发展都是初期，所以里面的api变化非常大，甚至一些关键的设计概念，在新版本中都被废弃掉。  
一个扩展写好了，没过几天，所以依赖的api升级。扩展不可用了，怎么办呢？

**2. 城堡时代-NAN**  
其实不是啥大问题。屏蔽一层就行了。这是今天我们要分析的一个点。怎么做呢？  
**在c和c++的世界里也很容易，就是用宏来实现。**  
跟据不同的nodejs 版本或者v8版本，上层提供一个统一的宏，下层按版本走不一样的api。参考代码  
[https://github.com/nodejs/nan/blob/master/nan.h](https://github.com/nodejs/nan/blob/master/nan.h)  
我们从中取一段：

```
inline uv_loop_t* GetCurrentEventLoop() {
#if NODE_MAJOR_VERSION >= 10 || \
  NODE_MAJOR_VERSION == 9 && NODE_MINOR_VERSION >= 3 || \
  NODE_MAJOR_VERSION == 8 && NODE_MINOR_VERSION >= 10
    return node::GetCurrentEventLoop(v8::Isolate::GetCurrent());
#else
    return uv_default_loop();
#endif
}
```

这是一个获取默认事件循环实例的api。可见老版本获取实例需要调用

```
node::GetCurrentEventLoop(v8::Isolate::GetCurrent());
```

而较新版需要调用

```
uv_default_loop();
```

很黄很暴力。这样的解决方案不失为一种办法。但是同时有很多小瑕疵。  
1.  这种宏的玩法通常是在编译前期完成。这要求我们的扩展如果运行在不同nodejs版本下需要从新编译。（这种宏变量通常是编译时注入的）  
2. nodejs “野心很大”。nodejs一开始就定位自己为一个跨平台产物-自己不满足libev搞了个libuv，有兴趣的可以自行了解这段儿。它可不仅仅想兼容一种vm（v8js引擎）。这个时候如果我们扩展里硬编码引用一些v8的api是无论如何也难切换引擎的。

当然还有很多小的瑕疵，我这里也研究不是很透彻。但我个人理解这两个已经足以说明问题。  
面对以上的问题，该如何破呢？

**3.帝国时代-N-API**  
针对NAN时代的问题，nodejs在新的版本提出N-API，针对NAN加强或者说优化。本质还是为了解决平台或者版本差异性带来的扩展不可通用问题。

同样是搞一层，**但是这次不用宏了，因为宏太薄弱了。提出了一个概念叫`ABI`.** 只要ABI版本不变，你的扩展在 同平台同指令集下，可以在多个不同nodejs版本下运行。而且不需要重新编译。话说这个ABI是个啥东西，很好奇。我还是从源码来看  
[https://github.com/nodejs/node-addon-api/blob/master/napi.h](https://github.com/nodejs/node-addon-api/blob/master/napi.h)

```
/// A JavaScript string value.
  class String : public Name {
  public:
    /// Creates a new String value from a UTF-8 encoded C++ string.
    static String New(
      napi_env env,            ///< N-API environment
      const std::string& value ///< UTF-8 encoded C++ string
    );

    /// Creates a new String value from a UTF-16 encoded C++ string.
    static String New(
      napi_env env,               ///< N-API environment
      const std::u16string& value ///< UTF-16 encoded C++ string
    );

    /// Creates a new String value from a UTF-8 encoded C string.
    static String New(
      napi_env env,     ///< N-API environment
      const char* value ///< UTF-8 encoded null-terminated C string
    );

    /// Creates a new String value from a UTF-16 encoded C string.
    static String New(
      napi_env env,         ///< N-API environment
      const char16_t* value ///< UTF-16 encoded null-terminated C string
    );

    /// Creates a new String value from a UTF-8 encoded C string with specified length.
    static String New(
      napi_env env,      ///< N-API environment
      const char* value, ///< UTF-8 encoded C string (not necessarily null-terminated)
      size_t length      ///< length of the string in bytes
    );

    /// Creates a new String value from a UTF-16 encoded C string with specified length.
    static String New(
      napi_env env,          ///< N-API environment
      const char16_t* value, ///< UTF-16 encoded C string (not necessarily null-terminated)
      size_t length          ///< Length of the string in 2-byte code units
    );
```

这是我们随便截取的一段。即使不熟悉node扩展的同学也可以看出，大概是创建一个字符串。在NAN年代，没有这么细力度api，你还得引v8的API去完成。看NAN时代的例子

```
#include <node.h>

namespace demo {

using v8::FunctionCallbackInfo;
using v8::Isolate;
using v8::Local;
using v8::NewStringType;
using v8::Object;
using v8::String;
using v8::Value;

void Method(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
    args.ToLocalChecked();
    args.GetIsolate();
  args.GetReturnValue().Set(String::NewFromUtf8(
      isolate, "hello world", NewStringType::kNormal).ToLocalChecked());
}

void Initialize(Local<Object> exports) {
  NODE_SET_METHOD(exports, "hello", Method);
}

NODE_MODULE(NODE_GYP_MODULE_NAME, Initialize)

}  // namespace demo
```
致此，我相信ABI是个啥基本明了。**本质是作了一个抽象层,与NAN时期的实现方式不同，一个用宏，另一个用了一堆运行时代码。**这个抽象层对vm（使用抽象层api，不用直接面对v8的api），node 本身，libuv等都有覆盖。说得更直白，是你的扩展调用这个抽象层的API，这个抽象层去帮你桥接其他底层API。做到版本，平台的屏蔽。更加强大，更加灵活，甚至可以把api作到更加简单（不像直接使用v8api那样晦涩）。

#### 总结
nan 与 n-api的本质都是一个抽象层。区别是nan用的宏实现，简单暴力。n-api搞了一运行时代码实现。更强大灵活，所以能解决的问题更多。
另外要注意一个点，很多文章说，n-api可以做到一次编译，到处运行。这是不可能的。
从代码跨平台角度讲，这跟操作系统和硬件指令集有关系。n-api能做到的仅仅是在相同操作系统下，相同硬件下，不同nodejs版本不需要多次编译即可运行。

#### 参考

代码为何不能跨操作系统运行

https://www.quora.com/What-are-the-differences-between-a-linux-binary-and-a-windows-binary-file-Why-cant-we-run-one-on-other-e-g-exe-file-on-linux

只能是同系统，同硬件，不同nodejs版本，不需要多次编译

https://medium.com/the-node-js-collection/n-api-next-generation-node-js-apis-for-native-modules-169af5235b06

https://github.com/msatyan/MyNodeC#why-n-api-

实验是否NAN需要多次编译在不同nodejs版本

https://juejin.im/post/5de484bef265da05ef59feb5

原生模块开发方式变迁

https://cnodejs.org/topic/5957626dacfce9295ba072e0	
