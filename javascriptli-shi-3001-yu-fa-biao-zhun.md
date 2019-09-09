javascript 历史
https://benmccormick.org/2015/09/14/es5-es6-es2016-es-next-whats-going-on-with-javascript-versioning/（英文大致介绍）
https://www.jianshu.com/p/2e58f0b9ee99（中文详细介绍, ES262 vs ES402）
https://www.zhihu.com/question/39993685/answer/84166978?from=profile_answer_card(从 ES2016 开始，ECMAScript 标准的制定原则是成文标准要从事实标准中诞生，实现先于标准存在,注意es2015的实现还是按以前的套路先标准后实现，所以Finished Proposals(https://github.com/tc39/proposals/blob/master/finished-proposals.md， 中没必要包括2015年以及之前的年份的语法特性)
http://exploringjs.com/es2016-es2017/ch_tc39-process.html(英文专业介绍）

babel 官网插件集合速查
http://babeljs.io/docs/plugins#syntax-plugins-experimental

ES的5个阶段:
ECMAScript实现先于标准存在, 那么在提出语言新特性，然后实现，最终通过标准的整个时间周期分为：
0-Strawman, 
1-Proposal,
2-Draft
3-Candidate
4-Finished
每个阶段的具体说名请详细参考https://tc39.github.io/process-document/。

这5个阶段，在github中又被分为4类Proposals（这个分类是自己根据github文档的理解）
Stage 0 Proposals(https://github.com/tc39/proposals/blob/master/stage-0-proposals.md)，包括：0-Strawman, 
Active proposals(https://github.com/tc39/proposals)，包括1-Proposal, 2-Draft， 3-Candidate
Finished Proposals(https://github.com/tc39/proposals/blob/master/finished-proposals.md) 包括：4-Finished， 历年通过的都在这里(从 ES2016 开始，ECMAScript 标准的制定原则是成文标准要从事实标准中诞生，实现先于标准存在,注意es2015的实现还是按以前的套路先标准后实现，所以Finished Proposals 中没必要包括2015年以及之前的年份的语法特性。)
当一些特性没通过审核，被拒绝或打回的称作：
Inactive Proposals(https://github.com/tc39/proposals/blob/master/inactive-proposals.md)

与babel的关系
babel出现的历史原因： ES5 也就是ECMAScript的第5个版本发布09年，只有现代浏览器（>=IE9)支持。而ES6（ES2015)是一个跨度比较大的版本，
这个版本规范提了很多新的高级的语法规范。目前的浏览器比如iE9支持的程度是相对低的，低得可以忽略。babeljs 实现了ES2015的大量语法特性，它实际是一个预处理js的工具。
能够将ES2015的语法转为ES5（这样在IE9上也跑了，请注意，它的定位就是转换成的产物，能在支持ES5的环境运行js，达不到ES3,  详细请参考http://babeljs.io/docs/usage/caveats/#es5)。ES3才是几乎所有浏览器都实现的语法规范（包括iE6），ES5是现代浏览器实现较好的语法规范，所以IE9是语法规范支持的一个分水岭。
babeljs 靠一系列列语法插件来实现ES2015里的各个语法特性，考虑到使用情况，babeljs 为这些插件贴了一个标签，比如 babel-preset-es2015，这表示实现es2015插件集合。咱们使用babel的时候只需要记住这个标签名称就行，而不用去记住每个插件的名称。
举例：Stage 2 preset(https://babeljs.io/docs/plugins/preset-stage-2/)
整个集合包括了syntax-dynamic-import, transform-class-properties 两个插件。那么在配置文件中，这样使用就时多余重复的( 因为：@babel/preset-stage-2 包括了@babel/plugin-syntax-dynamic-import）

	file .babelrc:
	{
                    presets: ["@babel/preset-stage-2"],
                    plugins: [
                            "@babel/plugin-syntax-dynamic-import",
                    ]
     }

除了 babel-preset-es2015 还有  babel-preset-es2016，  babel-preset-es2017 其中比较特殊的标签是 babel-preset-latest，它实际包括 es2015，es2016，es2017 等随最新年份发布的规范版本插件集合。现在 babel-preset-latest 废弃改名为 babel-preset-env了。


babel-stage-x
babel-preset-env 值得注意的是，它只包括纳入规范的语法特性。也就是4-Finished 阶段的语法特性。它不包括0-Strawman, 1-Proposal,2-Draft 3-Candidate阶段的。
如果要使用这些阶段的必须另外有babel-preset-stage-1, 注意babel-preset-stage-2包括babel-preset-stage-3。   babel-preset-stage-1 包括 babel-preset-stage-2 和 babel-preset-stage-3.(眨眼一看，顺序反了？其实没有，你使用越初期阶段的api，肯定也要想用越成熟阶段的api，所以你引入babel-preset-stage-1，实际上它会包括babel-preset-stage-2， babel-preset-stage-3)。以此类推。babel只是实现了绝大多数ES的语法，并非100%。实现的语法插件与github一一对应，可以查看到。当然在建议阶段的规范是不断变化的，又可能现在处理了2阶段，过断时间就在3阶段了。babel更新有可能不及时，有可能在babel-preset-stage-2的需要在3阶段才能找到匹配的规范。具体可以通过babel的插件http://babeljs.io/docs/plugins#syntax-plugins-experimental  去规范https://github.com/tc39/proposals中查找。

Typescript 对于这块怎么处理的？typescript 默认采用stage-3 and later，如果需要stage-1，stage-2有参数打开！
https://github.com/Microsoft/TypeScript/issues/19044


从哪里可以看到ES2016， ES2017新增的语法规范有哪些？
在 finished Proposals 中可根据年份检索  https://github.com/tc39/proposals/blob/master/finished-proposals.md

where is ES4
https://auth0.com/blog/the-real-story-behind-es4/
https://www.quora.com/Why-was-ECMAScript-4-ES4-never-implemented-outside-ActionScript-3-at-Adobe
https://auth0.com/blog/a-brief-history-of-javascript/
https://medium.com/@Pier/ecmascript-4-was-too-ahead-of-its-time-799e59232db0


ES版本的时间梳理
- [ ] For its initial release in 1995 as part of Netscape Navigator
- [ ]  In 1996 Netscape submitted JavaScript to ECMA International for standardization  => ECMAScript
- [ ]   After the initial version of ECMAScript, work on the language continued and two more versions were quickly published
- [ ]  1999 ECMASCript 3 came out in （很大一部分时间喜欢用ES3的语法，是支持最广的，IE6都支持）
- [ ]   (之后大概10年不更新了,各大厂商在3的基础上扩展自己的）
- [ ]    ECMAScript 5 was published in 2009 (这是就是 ECMASCript 5 （ES5)
- [ ]    这个标准出来后，厂商花了好几年来实现这个标准。（IE9部分支持, 以至于我们喜欢用ES3的语法）
- [ ]    Around 2012 things started to change, 大家发动运动，干掉老浏览器。
- [ ] 

