# nodejs源码分析

版本：0.10，github下载

工具：clion , 主要靠全文搜索关键字从入口开始分析函数调用路径

入口文件：src/node_main.cc

关键字：

```
return node::Start(argc, argv);
int Start(int argc, char *argv[]) {
	char** Init(int argc, char *argv[]) {      //初始化libuv
	Handle<Object> SetupProcessObject(int argc, char *argv[]) {  // 设置process对象
		  static Handle<Value> Binding(const Arguments& args) {
			 node_module_struct* get_builtin_module(const char *name) //一些内置模块比如fs等在这里挂载实现
	void Load(Handle<Object> process_l) {
		// ..加载了一个node.js 文件（此时由于process上挂在了很多c++底层函数），所以轻松实现了commonjs
```

### 分析总结：
**nodejs 其实很简单,分为4部分：**
1. 首先初始化了libuv 事件循环
2. 然后接着初始化v8
3. 封装了process 对象在v8全局上下文中
4. 通过nodejs文件（此时由于process上挂在了很多c++底层函数）实现了commonjs

commonjs 的require 具体实现是nodejs文件+module.js文件
  function startup() {
	function evalScript(name) { // 加载了module.js根据文件扩展名分发不同类型模块
1. 普通js 文件，主要通过process 上暴露v8的compile实现 runInThisContext
2. 内置模块，process 对象有个binding方法很重要，
```
   static Handle<Value> Binding(const Arguments& args) {
	 node_module_struct* get_builtin_module(const char *name) //一些内置模块比如fs等在这里挂载实现
```
3.addon 扩展模块，具体封装在module.js中，走了libuv的dlopen 打开动态连接库实现

所以单从这个版本看nodejs的实现是非常简单的，也没有复杂的设计在里面，是一个入门级c++项目，主要的设计和难点在libuv和v8引擎上。