Fastclick


https://thx.github.io/mobile/300ms-click-delay

https://zhuanlan.zhihu.com/p/66845055

1. 300ms 是为了解决缩放 ios 引入的，后期其它浏览器厂商模仿
2. 后来网页生产者适配了手机屏幕，不再强依赖缩放，所以300ms延迟没有意义。其它厂商开始干掉通过viewpot init-scale
3. 后来，chrome 觉得通过init-scaless=1干掉不好，因为缩放可能还是有一些必须的，所以通过with=device-width干掉
4. ios uivebview 一直没干掉。
5. ie touch-action 解决问题

```
import attachFastClick from 'fastclick';

function startApp() {
    ReactDOM.render(
        <App />,
        document.getElementById('root')
    );
    attachFastClick.attach(document.body);
}
```