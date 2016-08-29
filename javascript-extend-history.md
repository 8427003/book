# 1.最简单原型继承

```javascript

function Super () {
    this.name = 'name';
}
Super.prototype.getName = function () {
    return this.name;
}

function Sub () {
}
Sub.prototype = new Super();
```

缺点：不能向Super传递参数，因此有了借用构造函数


# 2.借用构造函数



```javascript

function Super () {
    this.name = 'name';
    this.getAge = function () {
        retrun 18;
    }
}
Super.prototype.getName = function () {
    return this.name;
}

function Sub () {
    Super.call(this);
}

```
缺点：要求所有类的方法必须在构造函数中定义,如同Super中的`getAge`方法。Sub也不能调用Super原型里的方法。


# 3.组合继承

```javascript

function Super () {
    this.name = 'name';
}
Super.prototype.getName = function () {
    return this.name;
}

function Sub () {
    Super.call(this);
}
Sub.prototype = new Super();

```








