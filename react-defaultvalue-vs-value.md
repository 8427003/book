# **React defaultValue vs value**

  
**React 中为何需要defaultValue？**

defaultValue 一般用于表单，给表单元素一个初始化值。注意，只是初始化，如果defaultValue值发生变化，表单里的值不会被改变。



**value也可以做到，为何还要defaultValue呢？**

表单分两种，一种是受控表单，一种是非受控表单。仅用value，使用者会误以为value值改变，表单显示的值也会跟着变，这实际上是受控表单的行为，完全符合期望。但是，非受控表单，props.value变化，其表单显示的值不会跟着变（因为表单内部有自己的state），为了区别这两种场景，所以引入了defaultValue，表示只给默认值。



**举个例子**：

简单来讲，如果只有value时。当既想给input赋予初始值（这是一个很普通场景），又不想input 作为受控表单（受控表在某些极端场景下，性能存在问题）你会写出

`<input value={this.state.value} />`这时不能够同时满足两种场景，你会发现这是受控表单，必须绑定change事件，维护state，如果是大数组列表，可能有性能问题。为了解决这个问题，用defaultValue 来表示初始值，`<input defaultValue={this.state.value} />`你不必绑定change事件，这是一个非受控表单。



不受控制组件通常有个defaultValue

[https://reactjs.org/blog/2018/06/07/you-probably-dont-need-derived-state.html\#recommendation-fully-uncontrolled-component-with-a-key](https://reactjs.org/blog/2018/06/07/you-probably-dont-need-derived-state.html#recommendation-fully-uncontrolled-component-with-a-key)

