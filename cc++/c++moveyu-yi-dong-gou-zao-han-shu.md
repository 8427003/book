# c++move与移动构造函数

  
各种构造函数  
[https://blog.csdn.net/jofranks/article/details/17438955](https://blog.csdn.net/jofranks/article/details/17438955)  
[https://blog.csdn.net/fengbingchun/article/details/52558914](https://blog.csdn.net/fengbingchun/article/details/52558914)  
[https://www.ibm.com/developerworks/cn/aix/library/1307\_lisl\_c11/](https://www.ibm.com/developerworks/cn/aix/library/1307_lisl_c11/)  
[https://www.ibm.com/developerworks/cn/aix/library/1307\_lisl\_c11/index.html](https://www.ibm.com/developerworks/cn/aix/library/1307_lisl_c11/index.html)

总结：构造函数分好几种: 构造函数，移动构造函数，移动赋值操作符，复制构造函数，赋值操作符，析构函数  
由于c++11中提出了右值引用（只是这样理解，右值引用这个定义是否是c++11中提出没有考证），与之对应  
移动构造函数，移动赋值操作符 被提出。比如int a=1，我们将a成为左值，将1称为右值。当在构造一个对象时，传入的参数是右值还是左值，  
会调用不的构造函数。左值一般走复制构造函数，赋值操作符，右值就走 移动构造函数，移动赋值操作符。  
比如代码：  
int a=1;  
customPrint\(a\) // 左值，  
customPrint\(1\) // 右值，  
左右值调用cutomPrint类的构造函数是不一样的。  
Std:move函数可以将一个左值强制转为右值。



**最清楚的左值 vs 右值**  
[https://www.youtube.com/watch?v=UTUdhjzws5g](https://www.youtube.com/watch?v=UTUdhjzws5g)  
[https://www.youtube.com/watch?v=IOkgBrXCtfo](https://www.youtube.com/watch?v=IOkgBrXCtfo)  
 个人理解，通常地，等式左边的，代表了一块儿地址的（能够被赋值的）变量或者表达式被称为左值。不能被赋值的表达式，被看作右值。区别关键在于是否代表了一块儿内存，且能够被赋值改变内存的值。

为啥会出现右值引用概念？从代码中不难看出，右值通常地只在代码中使用一次就不使用了。如等式 Obj o = objxxx，如果按之前的语法来看，objxxx不区分左右值，那么这将是一个复制行为，且通常为深拷贝。现在的语法，我们可以为右值新增一个单独的构造函数，当遇到一个复合类型右值，我们可以在构造函数中，直接将右值的孩子对象作为新值的孩子对象（直接指针指过去），而免去深拷贝（因为反正右值也不再使用），效率和存储都有很大提升。

