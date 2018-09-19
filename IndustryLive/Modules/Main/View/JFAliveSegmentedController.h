//
//  JFAliveSegmentedController.h
//  IndustryLive
//
//  Created by ikrulala on 2018/1/22.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFAliveSegmentedController : UIView
@property (nonatomic,copy) void(^switchBlock)(NSString *value);

@end
