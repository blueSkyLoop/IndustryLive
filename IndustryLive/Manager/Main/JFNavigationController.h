//
//  HNNavigationController.h
//  HuaiNan
//
//  Created by Lol on 2018/1/12.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JFNavigationControllerManagerProtocol <NSObject>

@optional
- (BOOL)bb_ShouldBack;
@end

@interface JFNavigationController : UINavigationController

+ (JFNavigationController *)setupChildVc:(UIViewController *)curreVC title:(NSString *)title;


@end
