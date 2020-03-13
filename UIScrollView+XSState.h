//
//  UIScrollView+XSState.h
//  XSState
//
//  Created by mac on 2019/11/1.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UIScrollViewAnimate;

NS_ASSUME_NONNULL_BEGIN

//  状态
typedef NS_ENUM(NSInteger, XSScrollViewState) {
    XSScrollViewStateNormal,        //  正常
    XSScrollViewStateLoading,       //  加载中
    XSScrollViewStateEmpty,         //  空
    XSScrollViewStateFailed,        //  失败
    XSScrollViewStateNoNetwork,     //  没有网络
};


/**
    状态显示。默认是Normal状态，不会添加视图
 
    @note   setView:forState: 会持有view
 */
@interface UIScrollView (XSState)

//  全局设置
+ (void)setClass:(nullable Class)cls forState:(XSScrollViewState)state;
+ (nullable Class)classForState:(XSScrollViewState)state;

//  局部设置。改变view后，需要调用setState:方法刷新显示。局部设置的优先级大于全局设置。
- (void)setView:(nullable UIView<UIScrollViewAnimate> *)view forState:(XSScrollViewState)state;
- (nullable UIView<UIScrollViewAnimate> *)viewForState:(XSScrollViewState)state;

@property (nonatomic) XSScrollViewState state;

@end


/// 如果需要动图，实现该协议即可
@protocol UIScrollViewAnimate <NSObject>
@optional
- (void)startAnimating;
- (void)stopAnimating;
@end

NS_ASSUME_NONNULL_END
