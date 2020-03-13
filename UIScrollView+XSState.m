//
//  UIScrollView+XSState.m
//  XSState
//
//  Created by mac on 2019/11/1.
//  Copyright © 2019 mac. All rights reserved.
//

#import "UIScrollView+XSState.h"
#import <objc/runtime.h>

@implementation UIScrollView (XSState)

+ (void)load {
    Class cls = [UIScrollView class];
    //  不能监听setFrame:，使用自动布局时，不会触发
    SEL sel = @selector(setBounds:);
    Method m = class_getInstanceMethod(cls, sel);
    IMP imp0 = method_getImplementation(m);
    IMP imp1 = imp_implementationWithBlock(^void(UIScrollView *scrollView, CGRect bounds){
        ((void (*)(UIScrollView*, SEL, CGRect))imp0)(scrollView, sel, bounds);
        [scrollView updateStateViewFrame];
    });
    method_setImplementation(m, imp1);
}

- (void)updateStateViewFrame {
    UIView *view = [self viewForState:self.state];
    if (view) {
        //  滑动的时候bounds.origin在不停的变化
        view.frame = (CGRect){.size = self.bounds.size};
        [self sendSubviewToBack:view];
    }
}

//_______________________________________________________________________________________________________________
//  MARK: - 伪属性

//  全局设置
+ (void)setClass:(nullable Class)cls forState:(XSScrollViewState)state {
    objc_setAssociatedObject(self, [UIScrollView keyForScrollViewState:state], cls, OBJC_ASSOCIATION_ASSIGN);
}

+ (nullable Class)classForState:(XSScrollViewState)state {
    return objc_getAssociatedObject(self, [UIScrollView keyForScrollViewState:state]);
}

//  局部设置
- (void)setView:(nullable UIView<UIScrollViewAnimate> *)view forState:(XSScrollViewState)state {
    objc_setAssociatedObject(self, [UIScrollView keyForScrollViewState:state], view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nullable UIView<UIScrollViewAnimate> *)viewForState:(XSScrollViewState)state {
    return objc_getAssociatedObject(self, [UIScrollView keyForScrollViewState:state]);
}

/**
    key 所在的内存地址必须一致。以下就不行：
    @code
        const void *key = [NSString stringWithFormat:@"kXSScrollViewState%ld", state].UTF8String;
    @endcode
    因为每次调用，key的地址不一样。
 */
+ (const void *)keyForScrollViewState:(XSScrollViewState)state {
    NSString *key = [NSString stringWithFormat:@"kXSScrollViewState%ld", (long)state];
    SEL sel = sel_getUid(key.UTF8String);
    return sel;
}


//_______________________________________________________________________________________________________________
//  MARK: - state

static const void *kXSScrollViewStateKey = &kXSScrollViewStateKey;

- (XSScrollViewState)state {
    return [objc_getAssociatedObject(self, kXSScrollViewStateKey) integerValue];
}

- (void)setState:(XSScrollViewState)state {
    //  移出之前的view
    UIView *preView = [self viewForState:self.state];
    [preView removeFromSuperview];
    if ([preView respondsToSelector:@selector(stopAnimating)]) {
        [preView performSelector:@selector(stopAnimating)];
    }
    //  取得view，没有就创建
    UIView *curView = [self viewForState:state];
    if (curView == nil) {
        Class cls = [UIScrollView classForState:state];
        UIView<UIScrollViewAnimate> *view = [cls new];
        [self setView:view forState:state];
        curView = view;
    }
    
    //  设置状态
    objc_setAssociatedObject(self, kXSScrollViewStateKey, @(state), OBJC_ASSOCIATION_ASSIGN);
    
    //  添加现在的view
    [self addSubview:curView];
    [self updateStateViewFrame];
    if ([curView respondsToSelector:@selector(startAnimating)]) {
        [curView performSelector:@selector(startAnimating)];
    }
}

@end
