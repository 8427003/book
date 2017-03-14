# 背景

git是一个庞大的工具，我们要开始扫盲一些常用的命令。回滚代码在项目中必然会遇到，下面我们介绍在git中如何回滚代码。

# revert 

```
A <- B <- C <- D

```
说明：尖头方向表示parent节点，及`A <- B` 表示先提交了A，再提交了B


**情况一：现在不想要D了**

```
git revert hash(D) 

```
执行命令后会让填写 message, 相当于一次commit, 此时多了一次提交F，如下 

```
A <- B <- C <- D <- E(revert)

```

但是 D 这次的提交会被干掉，于是回滚成功。

**回到之前， **

```
A <- B <- C <- D

```
**情况二：然后这次想回滚到C（注意是回滚到C，及 C、D都不要了）**

```
git revert hash(B)..HEAD 

```
注意这个hash的取值，是B， 不是C的commit hash

执行命令后会让你填写2次message, 最后提交记录也有两次

```
A <- B <- C <- D <- E(revert) <- F(revert) 

```
**回到之前 **

```
A <- B <- C <- D

```

**情况三：然后这次想回滚C（注意是回滚C，及 C不要了，但是D还需要），其实跟情况一是同样的**

```
git revert hash(C) 

```
执行命令后填写1次message

```
A <- B <- C <- D <- E(revert)
 
```

**小结：**

`revert hash` 这个hash为对应想删除的commit

`revert hash..HEAD` 这个hash对应的commit不会被删除，会删除到它的后一次commit

revert 会产生新的提交，并不会真正删除history。

# reset

同样，假设有如下commit记录

```
A <- B <- C <- D

```

**想删除到C(及C、D都不要了）**

```
git reset hash(B) --hard

```
执行命令后本地的commit history就被干掉了
当执行 `git push` 的时候，会被提示不能提交。但凡修改历史跟origin有冲突的，都必须强项覆盖提交，这时大胆执行`git push -f`同步到origin.
