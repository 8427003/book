# 1.最简单原型继承

```javascript

function Super () {
    this.name = 'name';
    this.colors = ['red', 'black']
}
Super.prototype.getName = function () {
    return this.name;
}

function Sub () {
}
Sub.prototype = new Super();
```

缺点：

1. 不能向Super传递参数。
2. 引用类型属性被实例共享。


# 2.借用构造函数（伪造对象、经典继承）

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
缺点：

1. 要求所有类的方法必须在构造函数中定义,如同Super中的`getAge`方法。
2. 函数被重复创建。
3. Sub也不能调用Super原型里的方法.


# 3.组合继承

```javascript

function Super () {
    this.name = 'name';
    this.colors = ['red', 'black'];
}
Super.prototype.getName = function () {
    return this.name;
}

function Sub () {
    Super.call(this);
}
Sub.prototype = new Super();

```
优点： 解决了属性为引用类型时实例是共享的问题（原型中的引用被实例中的引用值覆盖），子类也能用使用原型中的方法。比较常用。

缺点：

1. Super被调用重复调用2次

---

# 4.原型式继承（道格拉斯）

```javascript

function object (o) {
    function F () {}
    F.prototype = o;
    return new F();
}

var person = {
    name: 'name',
    friends: ['A', 'B']
}

var person1 = object(person);
person1.name = 'name1';
person1.frends.push('C');

var person2 = object(person);
person2.name = 'name2';
person2.frends.push('D');

// A B C D
console.log(person.frends);
```



适用场景：不必兴师动众创建构造函数，只是想让一个对象与另一个对象保持类似的情况下。

说明： 在ECMAScript5得到规范 `Object.create()`

缺点：

1. 依然存在引用类型属性共享问题。

# 5. 寄生式继承

```javascript

function object (o) {
    function F () {}
    F.prototype = o;

    return new F();
}

function createAnother (original) {
    var clone = object(original);
    clone.sayHi = function () {
        alert("hi");
    }

    return clone;
}

var person = {
    name: "Nicholas",
    friends: ["Shelby", "Court", "Van"]
}

var person1 = createAnother(person);
person1.friends.push('person1');
person1.sayHi();


var person2 = createAnother(person);

// "Shelby", "Court", "Van", "person1"
console.log(person2.friends);
```

缺点：函数`sayHi()`依然被重复创建，引用类型属性依然存在共享问题。


# 6. 寄生组合式继承

```javascript

function object (o) {
    function F () {}
    F.prototype = o;
    
    return new F();
}

function inheritPrototype (Sub, Super) {
    var proto = object(Super.prototype);
    proto.constructor = Sub;
    Sub.prototype = proto;
}

function Super () {
    this.
}

function Sub () {
    Super.call(this);
}
inheritPrototype(Sub, Super);

```






