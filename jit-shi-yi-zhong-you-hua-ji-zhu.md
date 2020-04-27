# JIT 是一种优化技术

JIT 是一种优化技术，是针对Interpreters 来说的。实际就是在运行时将中间码翻译为机器码执行。

## 以a+b为例子

### Interpreters 是这样工作的，有两种情况
ast-> add(a,b) 这里的add 是runtime 早就准备好的过程，直接调用。早期很多脚本语言这么干的。
ast->bytecode->add(a,b) 这里的add 是跟上面一样，也是runtime早就准备好的过程。可能会有个疑问，bytecode 不是类汇编的操作码吗，怎么会有add 这种方法，没错，这种bytecode 类汇编，但还是比汇编要抽象一些，add 这里就是bytecode 的一个指令。一般是用一个纯栈机（跟汇编代码比，没有了其它寄存器）+ 一些早就准备好的过程来实解译执行。jvm就是这么干的（注意这个纯栈机，其实也是早就准备好的过程，解释执行一般就是这么干的。专门用来解释bytecode，很爽，很像传统的执行汇编代码的模式）

**上面两种情况有一个共同点，Interpreters 无论从ast 执行代码，还是从bytecode执行代码，都是调用了vm早已经存在的过程。**

### JIT是这样工作的，也分两种
ast->native code（早期v8）
ast->bytecode->native code （典型jvm，也是目前主流模型）
一般JIT 都是以一个block 为单位去动态产生native code。在实际实现中，就是以函数为单位。
这得易于一个骚操作：
就是就是把动态产生的整个函数的native code，分配一块可执行内存，就可以调用了。在c 语言中实现大致为
搞个char 数组，来装动态产生的native code，再用mmap 分配一块可执行内存，然后把char数组里的东西装进分配的内存。
最后将分配的内存首地址强制转为函数指针，就可以调用了。参考项目https://github.com/sol-prog/x86-64-minimal-JIT-compiler-Cpp/blob/master/part_1/hello_3.cpp
不过这种骚操作，在一些平台不一定能实现，一些平台（例如：iOS、智能电视、游戏控制台）需要禁止非特权应用对可执行内存的写权限，在此之前使用 V8 是无法实现的，而且禁止可执行内存的写权限能够减少应用的被攻击渠道。所以必须走解释执行了。https://juejin.im/entry/5c89c2c16fb9a04a0f660d7a

### v8的骚实现
早期v8，直接采用了JIT，没有Interpreters。而且还是暴力的JIT，中间没有bytecode，即ast->nativecode。
后来发现这玩意儿有弊端，主要来自两方面：

如果我们把脚本的运行分为两个阶段：转换过程+代码执行，发现nativecode虽然代码真正执行时比Interpreters快。但是ast->bytecode vs ast->nativecode这种转换过程，前者更快。所以整体速度，尤其第一次运行代码，不一定JIT就比Interpreters快了。另外JIT这种开辟内存存储nativecode这种机制比Interpreters更占用内存，在一些内存要求比较高的设备，这比较致命。

另一方面是，脚本语言需要去优化。js 是弱类型语言。过程优化时，必须确定类型。啥意思呢？
func（a,b) {
	if(tyeof a == int && tyeof b == int){ return add(a, b)}
	if(tyeof a == string && tyeof b == int){ return concat(a, b) }
}
这个函数由于兼容各种参数类型，代码变得很冗余。如果函数的参数类型是确定的，我们就没必要过多分支去判断参数类型，是不是代码可以简化很多？
没错，这是一个很重要的优化点。所以v8生成native code 时只针对特定参数类型优化代码。但是脚本语言参数类型可能改变，这个时候咱们生成的优化代码，就不能用了。得重新生成。这个过程叫去优化。那从哪里开始从新生成呢，ast 还是bytecode ？很明显，从bytecode效率更高，bytecode能提供更简洁更不容易出错的执行模型,使得去优化机制更容易实现。

所以v8最后的模型也变成了ast->bytecode->(Interpreters | nativecode)

# 参考
https://metebalci.com/blog/demystifying-the-jvm-jvm-variants-cppinterpreter-and-templateinterpreter/
https://metebalci.com/blog/demystifying-the-jvm-interpretation-jit-and-aot-compilation/
https://stackoverflow.com/questions/56823223/how-native-code-is-converted-into-machine-code-in-jvm/56834686#56834686
https://solarianprogrammer.com/2018/01/10/writing-minimal-x86-64-jit-compiler-cpp/