# UIScrollView+XSState

给`UIScrollView`、`UITableView`、`UICollectionView`展示状态信息（比如：加载中、数据为空、加载失败、网络异常等）

## 为什么重复造轮子

给UITableView展示空数据的有[`DZNEmptyDataSet`](https://github.com/dzenbot/DZNEmptyDataSet)、[`LYEmptyView`](https://github.com/dev-liyang/LYEmptyView)，都为开发者提供了常见的提示UI，但使用起来比较繁琐，需要对其提供的UI进行定制。  

## 设计原则
-  保持精简，源代码只有100行左右。
-  使用方便，提供的接口少。
-  提供扩展，开发者可任意定制任何状态的下的UI。

## 使用

### 1.  设置state对应的view

**在设置state前，需要设置state对应的view，<u>state对应的view完全有开发者提供。</u>**  
提供两种设置view的方式：  

-  **全局设置**  

``` objc
[UIScrollView setClass:[CustomEmptyView class] forState:XSScrollViewStateEmpty];
[UIScrollView setClass:[CustomLoadingView class] forState:XSScrollViewStateLoading];
[UIScrollView setClass:[CustomFailedView class] forState:XSScrollViewStateFailed];
```

-  **局部设置** 

``` objc
[_scrollView setView:[CustomEmptyView new] forState:XSScrollViewStateEmpty];
[_scrollView setView:[CustomLoadingView new] forState:XSScrollViewStateLoading];
[_scrollView setView:[CustomFailedView new] forState:XSScrollViewStateFailed];
```

局部设置的优先级高于全局设置。

### 2.  更新state

设置好了state对应的view，更新state，即可显示。

``` objc
_scrollView.state = XSScrollViewStateEmpty;
```

**如果某种状态正常显示`UIScrollView`、`UITableView`、`UICollectionView`，则该状态不需要设置对应的view**，例如：`XSScrollViewStateNormal`状态下就不需要设置对应的view。  

## 状态
 
状态`XSScrollViewState`与程序的实现无关，可任意添加、删除、更名。

## 动画

如果自定义的view需要动画，实现`UIScrollViewAnimate`协议即可。
