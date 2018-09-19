//
//  HNTabBarController.m
//  HuaiNan
//
//  Created by Lol on 2018/1/12.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import "JFTabBarController.h"
#import "JFNavigationController.h"



#import "MHMacros.h"
@interface JFTabBarController ()
@property (nonatomic, strong) NSMutableArray  *mutabControllers;
@end

@implementation JFTabBarController

- (instancetype)init{
    if (self = [super init]) {
        
        [self setViewControllers:self.mutabControllers animated:NO];
        
        //setup delegate
        self.delegate = self;
        
        //setup config
        [self setupConfig];
    }
    return self;
}

/**
 配置
 */
- (void)setupConfig {
    //设置未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MColorTitle, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    //设置选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MColorRed, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Life Cycle

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


#pragma mark - Getter
- (NSMutableArray *)mutabControllers {
    if (!_mutabControllers) {
         _mutabControllers = [NSMutableArray array];
    }
    return _mutabControllers ;
}
@end
