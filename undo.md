## 背景

当我们在normal使用```u```时，可以撤销一些写入操作。

比如insert模式下输入了：

```
1
2
3
4
```

这时按一下```u```时，变为了:


```
1
2
3
```

如果你继续```u```时，你可以撤销一直到空。但是，中途如果文件被关闭，然后重新打开（我们经常去编辑其它文件，返回来重新打开先前的文件编辑），你会发现，不能再```u```了。
我们很期望重新打开文件后，可以继续```u```。这时你需要Vim 7.3+的undo持久化功能。

## 实践日志

### 1.在.vimrc加如下配置：

```
if has('persistent_undo') "check if your vim version supports it 
    set undofile "turn on the feature 
    set undodir=$HOME/.vim/undo "directory where the undo files will be stored 
endif
```

### 2.一定要手动创建到```$HOME/.vim/undo```目录


最后，尽情享受undo持久化吧。