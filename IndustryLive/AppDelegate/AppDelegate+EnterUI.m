//
//  AppDelegate+EnterUI.m
//  IndustryLive
//
//  Created by Lol on 2018/1/16.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import "AppDelegate+EnterUI.h"
#import "JFLoginController.h"
#import "JFNavigationController.h"
#import "JFMainController.h"
@implementation AppDelegate (EnterUI)

- (void)jf_enterLogin {
    JFLoginController *vc = [[JFLoginController alloc] init];
    JFNavigationController *nav = [JFNavigationController setupChildVc:vc title:@""];
    self.window.rootViewController = nav;
}

- (void)jf_enterMain {
    UIViewController *controller = self.window.rootViewController;
    JFMainController *vc = [[JFMainController alloc] init];
    JFNavigationController *nav = [JFNavigationController setupChildVc:vc title:@"推流直播"];
    self.window.rootViewController = nav ;
    if(controller){
        [controller.view removeFromSuperview];
        controller = nil;
    }
}

@end
