# 1.原型继承

说明：这是最初用原型链来实现的继承

```javascript

function Super() {
    this.name = 'name';
}
Super.prototype.getName = function() {
    return this.name;
}

function Sub() {
}
Sub.prototype = new Super();
```

2.
