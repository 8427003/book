一、框架期望实现的效果

1、前端项目是spa项目，且具有资源按页分包加载特性。

2、服务端不参与webpack编译。即只编译前端工程，编译好的产物作为一个中间件引入服务端项目。

3、spa项目最好只编译一次，不因为是否作为ssr项目模式而区别编译。

4、ssr项目模式和普通spa模式项目能无缝互转。实现开发还是走普通的spa的模式，只是生产可以快速构建为ssr模式项目。前端项目能够独立运行，包括开发和生产阶段在没有后端项目时能够独立运行。且加上后端项目后能够简单转变为ssr项目模式。

二、关键实现与思路

**1、选择spa项目**。spa项目跟多页项目具有较大不同。spa项目必定包含路由模块，最终向外暴露一个app。多页项目，最终向外暴露每个页面模块。在作为服务端项目依赖时，spa项目作为更单一模块被引入，而多页项目必须再次架构与封装访问url与页面的对应关系，这个过程恰好是重写一个路由。如果多页项目不考虑这步封装，那么只有硬编码url 与页面模块绑定，会增加开发阶段工作量。

**2、将spa路由按页分包异步转为同步化。**由于spa项目多采用按页分包加载。这种情况下，路由path不直接和页面组件绑定，而是和一个“高阶组件”绑定。这个“高阶组件“其实是一个占位作用。当用户访问url，路由先渲染高阶组件，由这个高阶组件去异步获取该url对应模块的分包。当分包下载完毕且模块加载ready后，高阶组件重新渲染真正的模块。这个高阶占位组件我们使用的是开源库react-loadable，实现并不复杂。react-loadable 也有ssr方案，其实这套方案就是解决异步转为同步问题，但是这个套方案使用并不不友好。所以我们重写了。以上我们介绍了react-loadable的原理，下面我们来具体分析如何实现异步转同步。

往简单说，当输入一个url给咱们的路由模块时，路由应该返回给我们url对应的模块组件 。然后咱们拿这个模块组件去调用服务端渲染api，就可以得到字符串dom。但是你会发现基于代码按页分包路由，你只会得到“占位组件“。除非你实现一个占位组件，把两部分切割开。第一部分，你先让占位组件加载分包组件，然后回调你并表明此时分包已下载，组件已经ready。第二部，当你再次调用这个占位组件，让它自动检测，是否你需要的模块已经ready，如果ready直接返回真正的url对应的模块组件。占位组件由于第一步去访问网络了，第二部就不用访问网络，所以就是同步了。

**3、从访问url，得到匹配的页面模块**。
有两种方式可以从url得到对应模块。react 中可以用context实现在子组件挂载时通知最顶层父组件，我们暂时称这种方式为`捕获`。具体实现可以参考
https://loadable-components.com/docs/server-side-rendering/
https://github.com/jamiebuilds/react-loadable
这两个组件都是这种实现方式。但是我们的实现用了另一种方式，`react-router`有一个被大多忽视的方法`matchPath` 参考
https://reacttraining.com/react-router/web/api/matchPath
这个静态方法匹配的结果，和路由匹配的结果一致。我们可以利用它来提前得到匹配的具体组件模块。为什么我们选择这个方式？大家都知道在前端项目使用react-router中，组件能从props获得额外的match 对象。这个是react-router赋予的能力。我们想和前端项目保持一致。否则我们可能只能拿到url。

**4、从页面模块，得到对应分包资源**。因为服务端渲染api 实际上只是为你拼接一个字符串。当这个字符串到前端后，需要显示样式，响应事件等。所以这个页面组件对应css 和 js 资源必须手动挂在到相应的位置。从url找出页面模块很容易，比如react-router 就提供了一个静态方法matchPath，所以可以很容分析到访问的url命中哪个页面模块。但是从页面模块找到具体的分包有点难度。import\('模块路径‘\)， 这就是我们模块。第一难点，如果我们要找某个模块的分包（在webpack里叫bundle），那以什么为key去找呢？模块路径，模块在webpack里唯一的标识符？要处理这个问题的前置条件是对webpack的stats.json需要充分了解和分析。我们利用了webpack 特殊参数会产生一个stats.json。里面的数据结构大致是 \[ { bundle: \["xxxx.js",  "xxx.css"\], origin: {}, modules:\[\]\]，咱们通过modules 节点，判断这个moudles是否包含咱们的页面模块，是可以查出这个bundle的。也可以通过origin节点，'模块路径‘ 也可以找出这个bundle。我们用的是后者，但是这两种方法都有一定风险。因为一个module 可以被多个bundle 引用。咱们约定下只有页面module才用import（）api吧。刚才提到，key的问题，我们的key现在确定了，可以有两种。第一种是moduleId，第二种是requestText（就是import\(）的参数\)。这里虽然我们只用到了第二种，但是我们提供了一个babel插件，把component:\(\) =&gt; import（）这个语句重新改写了，加上了，moduleId，和requestText（免得用户要写两次这个字符串） 变成了
```
componet: () => { 
     moduleId: () => getMoudleId(),
     requestText: () => getRequestText(),
     module: import()
}
```
在新版本的构建中，我们发现webpack
```
import(/* webpackChunkName: "OtherComponent" */ './OtherComponent')
```
可以给注释，通过注释，我们在stats.json文件中将会得到特殊节点`namedChunkGroups`, 静态资源会groupBy webpackChunkName。从实现一遍这个babel插件意义不大，所以我们就用了`@loadable/babel-plugin` 具体可参考https://loadable-components.com/docs/babel-plugin/

**5、初始化数据。**一般spa项目中，咱们获取服务端数据会放在didMount生命周期中。如果是服务端渲染api，这个生命周期是不走的。咱们的解决方案和nextjs 一样，作为页面组件的静态方法，并且建议使用axios这种在浏览器和nodejs环境都能运行的http库。没错现在阶段仅支持http。rpc是一种很流行的方案，但是目前阶段没在项目中尝试过。服务端和浏览器端可以通过typeof window来判别，或者是服务端host映射，走更稳定的内网环境。总之这不是我们考虑的范围。当页面组件被下载ready后，我们会调用他的静态方法来获取服务端数据。细心的小伙伴可能发现了一个优化点，就是服务端数据和页面组件分包是串连下载的。如果我们把静态方法放到和页面组件路由配置地方，是可以解决这个问题的。但是main包可能会随着业务增大。
**
6、导出前端产出，作为库供后端项目引入**。这个点需要考验webpack功底了。webpack 有一套简单的数据结构来装载模块。简单说就是require一个模块时，webpack需要知道这个模块的bundle有没有下载下来。如果没有下载，需要先去下载bundle。存放的这些数据的数据结构通常挂在全局对象上，浏览器挂载window下，nodejs挂在global。这是你为什么buidle nodejs时需要设置target为node的原因之一。我们这里不设置这个target为node，因为我们不区别编译。要想两端都能跑，还可以设置globalObject这个属性为`"\(typeof window !== 'undefined' ? window : global\)"`, 就能自动识别全局环境了。还有一个地方有同样的问题，就是`mini-css-extract-plugin`产生的代码，它需要判断css是否加载。如果没有,会创建并挂载 link 标签到window下。如果是服务端，咱们可没有window对象，也不能创建link标签，必定报错。所以我们在服务端需要跳过这个逻辑，毕竟服务端拼字符串时不需要关注css。我们和`mini-css-extract-plugin` 提issu了，但是并没有采纳我们意见。只有自己发布一个`mini-css-extract-plugin-ssr`，只改了一行代码。仅仅为了跳过这个逻辑。ok最后一步，咱们把index.js作为umd模块导出，为啥作为umd，因为umd包括commonjs所以能作为库云行，又能在没有模块规范时自动运行。即既能作为库，又能作为一个自执行代码，这个特性很重要。我们这里不讨论amd，跟它没一毛钱关系。

#### 用一段话来总结服务端渲染实现的重难点：
通常现在的react项目都是SPA形式存在，SPA有一个重要的性能依赖是根据页面模块进行代码分包。从代码实现上讲，这里存在一个异步操作，就是main-app需要先去拉取相关页面模块的资源，加载页面组件模块资源后才能实例化组件进行渲染。这通常会使用一个高阶占位组件来实现，就是react-loadable类似组件。而服务端渲染必须是同步的（因为react 框架服务端渲染api仅仅简单滴把组件render函数调用即表明渲染结束，不会等来自异步setState引起的render作为渲染结果），所以实现服务端渲染，必须react-loadable支持类似Generator Yield类似的分步调用API。以至于服务端渲染时，第一步，加载被分包的组件。第二步，实例化组件render ，以消除异步。除了这个主要的问题以外，构建还需要解决： 1. url 到 分包资源的映射。2.初始化数据如何传递，以至于服务端和前端能够产生一样的dom字符串。3.以及构建后，需要封装一些工具方法，让服务端能够优雅滴集成前端的构建产物，做到仅构建一次就可以同时在服务端和前端跑，且能够快速降级切换。


#### 具体实现
https://github.com/8427003/react-ssr-build