//
//  JFSheetController.m
//  IndustryLive
//
//  Created by zz on 2018/1/17.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import "JFSheetController.h"
#import <Masonry/Masonry.h>

#pragma mark - JFBaseAnimation
@interface JFBaseAnimation ()
@property (nonatomic, assign) BOOL isPresenting;
@end

@implementation JFBaseAnimation

- (instancetype)initWithIsPresenting:(BOOL)isPresenting{
    if (self = [super init]) {
        self.isPresenting = isPresenting;
    }
    return self;
}
+ (instancetype)alertAnimationIsPresenting:(BOOL)isPresenting{
    return [[self alloc]initWithIsPresenting:isPresenting];
}
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.4;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    if (_isPresenting) {
        [self presentAnimateTransition:transitionContext];
    }else {
        [self dismissAnimateTransition:transitionContext];
    }
}
- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{}
- (void)dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{}
@end

#pragma mark - JFSheetFadeAnimation
@implementation JFSheetFadeAnimation
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    if (self.isPresenting)   return 0.45;
    return 0.25;
}

- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    JFSheetController *alertController = (JFSheetController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    alertController.backgroundView.alpha = 0.0;
    alertController.sheetView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(alertController.sheetView.frame));
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:alertController.view];
    
    [UIView animateWithDuration:0.25 animations:^{
        alertController.backgroundView.alpha = 1.0;
        alertController.sheetView.transform = CGAffineTransformMakeTranslation(0, -10.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            alertController.sheetView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }];
}

- (void)dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    JFSheetController *alertController = (JFSheetController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    [UIView animateWithDuration:0.25 animations:^{
        alertController.backgroundView.alpha = 0.0;
        alertController.sheetView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(alertController.sheetView.frame));
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}
@end


#pragma mark - JFSheetController
@interface JFSheetController ()
@property (nonatomic, strong) UIView *sheetView;
@property (nonatomic, weak) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) NSLayoutConstraint *alertViewCenterYConstraint;
@property (nonatomic, assign) CGFloat alertViewCenterYOffset;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) BOOL backgoundTapDismissEnable;
@property (nonatomic, assign) CGFloat actionSheetStyleEdging;
@end

@implementation JFSheetController

- (instancetype)init{
    if (self = [super init]) {
        [self configureController];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self configureController];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self configureController];
    }
    return self;
}


- (instancetype)initWithSheetView:(UIView *)sheetView{
    if (self = [self initWithNibName:nil bundle:nil]) {
        _sheetView = sheetView;
    }
    return self;
}

+ (instancetype)alertControllerWithSheetView:(UIView *)sheetView{
    return [[self alloc]initWithSheetView:sheetView];
}

- (void)configureController{
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    
    _backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    _backgoundTapDismissEnable = NO;
    _actionSheetStyleEdging = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self addBackgroundView];
    [self addSingleTapGesture];
    [self configureSheetView];
    [self.view layoutIfNeeded];
}

- (void)addBackgroundView {
    if (_backgroundView == nil) {
        UIView *backgroundView = [[UIView alloc]init];
        backgroundView.backgroundColor = _backgroundColor;
        _backgroundView = backgroundView;
    }
    [self.view insertSubview:_backgroundView atIndex:0];
    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setBackgroundView:(UIView *)backgroundView{
    if (_backgroundView == nil) {
        _backgroundView = backgroundView;
    } else if (_backgroundView != backgroundView) {
        [self.view insertSubview:backgroundView aboveSubview:_backgroundView];
        [backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        backgroundView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha = 1;
        } completion:^(BOOL finished) {
            [_backgroundView removeFromSuperview];
            _backgroundView = backgroundView;
            [self addSingleTapGesture];
        }];
    }
}

- (void)addSingleTapGesture{
    self.view.userInteractionEnabled = YES;
    _backgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [_backgroundView addGestureRecognizer:singleTap];
    _singleTap = singleTap;
}

- (void)configureSheetView {
    NSAssert(_sheetView, @"configureSheetViewMethod: alertView is nil");
    _sheetView.userInteractionEnabled = YES;
    [self.view addSubview:_sheetView];
}

- (void)singleTap:(UITapGestureRecognizer *)sender{
    [self dismissViewControllerAnimated:YES];
}

- (void)dismissViewControllerAnimated:(BOOL)animated{
    [self dismissViewControllerAnimated:YES completion:self.dismissComplete];
}

@end

@implementation JFSheetController (TransitionAnimate)
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [JFSheetFadeAnimation alertAnimationIsPresenting:YES];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [JFSheetFadeAnimation alertAnimationIsPresenting:NO];
}
@end

#pragma mark - UIView-JFAlertView
@implementation UIView (JFAlertView)

+ (instancetype)createViewFromNibName:(NSString *)nibName{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    return [nib objectAtIndex:0];
}

+ (instancetype)createViewFromNib{
    return [self createViewFromNibName:NSStringFromClass(self.class)];
}

- (UIViewController*)viewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)hideInController{
    if (![self isShowInAlertController]) {
        NSLog(@"self.viewController is nil, or isn't alertController");
        return;
    }
    [(JFSheetController *)self.viewController dismissViewControllerAnimated:YES];
}

- (BOOL)isShowInAlertController{
    UIViewController *viewController = self.viewController;
    if (viewController && [viewController isKindOfClass:[JFSheetController class]]) {
        return YES;
    }
    return NO;
}

- (void)hideView{
    if (![self isShowInAlertController]) {
        NSLog(@"self.viewController is nil, or isn't alertController,or self.superview is nil, or isn't showAlertView");
    }
    [self hideInController];
}

@end
