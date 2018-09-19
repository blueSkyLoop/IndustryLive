//
//  HNNavigationController.m
//  HuaiNan
//
//  Created by Lol on 2018/1/12.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import "JFNavigationController.h"
#import "MHMacros.h"
@interface JFNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIButton * backBtn ;
@end

@implementation JFNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = self;
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
    self.navigationBar.translucent = NO;
    //去掉导航底部黑线
    UIImageView *bottomLineView = [self findHairlineImageViewUnder:self.navigationBar];
    if(bottomLineView){
        bottomLineView.hidden = YES;
    }
    
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        
        return (UIImageView *)view;
        
    }
    
    for (UIView *subview in view.subviews) {
        
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        
        if (imageView) {
            
            return imageView;
            
        }
        
    }
    
    return nil;
    
}


+ (void)load{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:MColorTheme];
//    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"navi_back_white"]];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"navi_back_white"]];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(self.viewControllers.count > 0){
        UIButton *backBtn = [UIButton new];
        [backBtn setImage:[UIImage imageNamed:@"navi_back_white"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        [backBtn sizeToFit];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:backBtn];;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{

    return [super popViewControllerAnimated:animated];
}


- (void)back{
    if ([self.topViewController conformsToProtocol:@protocol(JFNavigationControllerManagerProtocol)]) {
        UIViewController *topVc = self.topViewController;
        BOOL b = [(id<JFNavigationControllerManagerProtocol>)topVc bb_ShouldBack];
        if (b) {
            [self popViewControllerAnimated:YES];
        }
    }else{
        [self popViewControllerAnimated:YES];
    }
}


/**
 * 初始化子控制器
 */
+ (JFNavigationController *)setupChildVc:(UIViewController *)curreVC title:(NSString *)title
{
    UIViewController *vc = (UIViewController *)curreVC;
    // 设置文字和图片
    vc.title = title;
     // 包装一个导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    JFNavigationController * nav =  [[JFNavigationController alloc] initWithRootViewController:vc];
    return nav ;
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.topViewController.preferredStatusBarStyle;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count <= 1) {
            return NO;
        }
        if ([self.topViewController conformsToProtocol:@protocol(JFNavigationControllerManagerProtocol)]) {
            UIViewController *topVc = self.topViewController;
            BOOL b = [(id<JFNavigationControllerManagerProtocol>)topVc bb_ShouldBack];
            return b;
        }
    }
    return YES;
}
// 允许同时响应多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:
(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer: (UIGestureRecognizer *) otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass: UIScreenEdgePanGestureRecognizer.class];
}


- (UIButton *)backBtn {
    if (!_backBtn) {
         _backBtn = [[UIButton alloc] init];
         [_backBtn setImage:[UIImage imageNamed:@"S-rightArrow"] forState:UIControlStateNormal];
        [_backBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -16, 0, 0)];
        [_backBtn sizeToFit];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        self.interactivePopGestureRecognizer.enabled = NO;
    }return _backBtn ;
}

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

@end
