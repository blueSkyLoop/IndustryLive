//
//  MBManager.m
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/10.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import "MBManager.h"
#import "MHMacros.h"

static const NSTimeInterval delayTime = 3.0;

@interface MBManager()

@end

@implementation MBManager

//显示转圈，不携带文本信息，需手动消失
+ (void)showHUD{
    [self showHUDMessage:nil];
}
//显示转圈，并携带文本信息，需手动消失
+ (void)showHUDMessage:(NSString *)message{
    [self mostTopViewWithIsshow:YES comple:^(UIView *aview) {
        LNMBProgressHUD *hud = [self showHUDinview:aview animated:YES comple:nil];
        NSAssert(hud, @"hud can not be nil");
        hud.mode = MBProgressHUDModeIndeterminate;
        if(message){
            hud.label.text = message;
        }
        hud.detailsLabel.text = nil;
        [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    }];
}
//显示文本，并显示3秒，3秒后自动消失
+ (void)showMessage:(NSString *)message{
    [self mostTopViewWithIsshow:NO comple:^(UIView *aview) {
        LNMBProgressHUD *hud = [self showHUDinview:aview animated:YES comple:nil];
        NSAssert(hud, @"hud can not be nil");
        hud.mode = MBProgressHUDModeText;
        hud.label.text = nil;
        hud.detailsLabel.text = message;
        hud.detailsLabel.font = MHFont(14);
        [hud hideAnimated:YES afterDelay:delayTime];
    }];
}

//显示文本，并显示3秒，3秒后消失并回调
+ (void)showMessage:(NSString *)message comple:(MBProgressHUDCompletionBlock)block{
    [self mostTopViewWithIsshow:NO comple:^(UIView *aview) {
        LNMBProgressHUD *hud = [self showHUDinview:aview animated:YES comple:[block copy]];
        NSAssert(hud, @"hud can not be nil");
        hud.mode = MBProgressHUDModeText;
        hud.label.text = nil;
        hud.detailsLabel.text = message;
        hud.detailsLabel.font = MHFont(14);
        [hud hideAnimated:YES afterDelay:delayTime];
    }];
}
//显示文本，并显示3秒，3秒后自动消失,离底部偏移量
+ (void)showMessage:(NSString *)message bottomOffset:(CGFloat)offset{
    [self mostTopViewWithIsshow:NO comple:^(UIView *aview) {
        LNMBProgressHUD *hud = [self showHUDinview:aview animated:YES comple:nil];
        NSAssert(hud, @"hud can not be nil");
        hud.offset = offset?CGPointMake(0, CGRectGetHeight(aview.frame)/2 - offset):CGPointZero;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = nil;
        hud.detailsLabel.text = message;
        hud.detailsLabel.font = MHFont(14);
        [hud hideAnimated:YES afterDelay:delayTime];
    }];
}
//显示文本，并显示3秒，3秒后自动消失并回调,离底部偏移量
+ (void)showMessage:(NSString *)message bottomOffset:(CGFloat)offset comple:(MBProgressHUDCompletionBlock)block{
    [self mostTopViewWithIsshow:NO comple:^(UIView *aview) {
        LNMBProgressHUD *hud = [self showHUDinview:aview animated:YES comple:[block copy]];
        NSAssert(hud, @"hud can not be nil");
        hud.offset = offset?CGPointMake(0, CGRectGetHeight(aview.frame)/2 - offset):CGPointZero;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = nil;
        hud.detailsLabel.text = message;
        hud.detailsLabel.font = MHFont(14);
        [hud hideAnimated:YES afterDelay:delayTime];
    }];
}

//显示信息，纯文本，不会自动消失，需要手动消失
+ (void)showInfor:(NSString *)infor{
    [self mostTopViewWithIsshow:NO comple:^(UIView *aview) {
        LNMBProgressHUD *hud = [self showHUDinview:aview animated:YES comple:nil];
        NSAssert(hud, @"hud can not be nil");
        hud.mode = MBProgressHUDModeText;
        hud.label.text = nil;
        hud.detailsLabel.text = infor;
        hud.detailsLabel.font = MHFont(14);
    }];
}

//在aview上生成一个LNMBProgressHUD，会先查找有没有，没有再创建一个
+ (LNMBProgressHUD *)showHUDinview:(UIView *)aview  animated:(BOOL)animated comple:(MBProgressHUDCompletionBlock)block{
    LNMBProgressHUD *hud = [self findLNMBProgressHUDinview:aview];
    if(![aview isKindOfClass:[UIWindow class]]){
        UIViewController *rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;
        UIViewController *topViewController = [self getCurrentControllerWithController:rootController];
        if(!aview.window && ![aview.nextResponder isKindOfClass:[topViewController class]]){
            return nil;
        }
    }
    if(!hud){
        hud = [LNMBProgressHUD showHUDAddedTo:aview animated:animated];
        hud.square = NO;
    }
    hud.completionBlock = [block copy];
    hud.bezelView.color = [UIColor colorWithRed:53 / 255.0 green:53 / 255.0 blue:53 / 255.0 alpha:1.0];
    //修改样式，否则等待框背景色将为半透明
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.label.textColor = [UIColor whiteColor];
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.contentColor = [UIColor whiteColor];
    hud.offset = CGPointZero;
    
    return hud;
}

+ (void)hiddenHUD{
//    [self mostTopViewWithIsshow:NO comple:^(UIView *aview) {
//        [self hiddenHUDinview:aview];
//    }];
    [self mostTopForHiidenComple:^(UIView *aview) {
        [self hiddenHUDinview:aview];
    }];
    
}
+ (void)hiddenHUDinview:(UIView *)aview{
    LNMBProgressHUD *hud = [self findLNMBProgressHUDinview:aview];
    if(hud){
        [hud hideAnimated:YES];
    }
}

+ (LNMBProgressHUD *)findLNMBProgressHUDinview:(UIView *)aview{
    NSAssert(aview, @"aview can not be nil");
    LNMBProgressHUD *hud = (LNMBProgressHUD *)[LNMBProgressHUD HUDForView:aview];
    if(!hud || hud.hasFinished){
        return nil;
    }
    hud.graceTime = .2;
    hud.minShowTime = .2;
    [aview bringSubviewToFront:hud];
    return hud;
}

+ (void)mostTopViewWithIsshow:(BOOL)isShow comple:( void(^)(UIView *))block{
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSAssert(window, @"window can not be nil");
    if(window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    
    UIViewController *rootController = window.rootViewController;
    if(!rootController){
        if(block){
            block(window);
        }
        
        return;
    }
    UIViewController *topViewController = [self getCurrentControllerWithController:rootController];
    if(block){
        block(topViewController.view);
    }
    /*
    NSTimeInterval adelayTime = .3;
    //延迟，避免在viewDidLoad中加载，这时候控制器还没有present或者push 过来
    NSTimer *atimer = [NSTimer scheduledTimerWithTimeInterval:adelayTime target:self selector:@selector(delayFindController:) userInfo:@{@"acontroller":rootController,@"ablock":[block copy]} repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:atimer forMode:NSRunLoopCommonModes];
     */
    
    
}

+ (void)mostTopForHiidenComple:( void(^)(UIView *))block{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSAssert(window, @"window can not be nil");
    if(window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    
    UIViewController *rootController = window.rootViewController;
    if(!rootController){
        if(block){
            block(window);
        }
        
        return;
    }
    UIViewController *topViewController = [self getCurrentControllerWithController:rootController];
    if(block){
        block(topViewController.view);
    }
    
}


+ (void)delayFindController:(NSTimer *)timer{
    NSDictionary *dict = timer.userInfo;
    UIViewController *topViewController = [self getCurrentControllerWithController:dict[@"acontroller"]];
    void (^ablock)(UIView *) = dict[@"ablock"];
    if(ablock){
        ablock(topViewController.view);
    }
}

+ (UIViewController *)getCurrentControllerWithController:(UIViewController *)vc{
    if([vc isKindOfClass:[UINavigationController class]]){
        
        UINavigationController *nav= (UINavigationController *)vc;
        if(nav.presentedViewController){
            return [self getCurrentControllerWithController:nav.presentedViewController];
        }
        return nav.visibleViewController;
        
    }else if([vc isKindOfClass:[UITabBarController class]]){
        UITabBarController *tab = (UITabBarController *)vc;
        UIViewController *avc = tab.selectedViewController;
        return [self getCurrentControllerWithController:avc];
    }else if(vc.presentedViewController){
        return [self getCurrentControllerWithController:vc.presentedViewController];
    }
    return vc;
}




@end
