//
//  JFSheetController.h
//  IndustryLive
//
//  Created by zz on 2018/1/17.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenW  [UIScreen mainScreen].bounds.size.width
#define kScreenH   [UIScreen mainScreen].bounds.size.height

@interface JFBaseAnimation : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign, readonly) BOOL isPresenting;
+ (instancetype)alertAnimationIsPresenting:(BOOL)isPresenting;
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;
@end

@interface JFSheetFadeAnimation : JFBaseAnimation
@end

@interface JFSheetController : UIViewController
@property (nonatomic, strong, readonly) UIView *sheetView;
@property (nonatomic, copy) void (^dismissComplete)(void);
@property (nonatomic, strong) UIView *backgroundView;
+ (instancetype)alertControllerWithSheetView:(UIView *)sheetView;
- (void)dismissViewControllerAnimated: (BOOL)animated;
@end

@interface JFSheetController (TransitionAnimate)<UIViewControllerTransitioningDelegate>
@end

@interface UIView (JFAlertView)
+ (instancetype)createViewFromNib;
+ (instancetype)createViewFromNibName:(NSString *)nibName;
- (UIViewController*)viewController;
- (void)hideView;
- (void)hideInController;
@end
