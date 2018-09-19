//
//  JFAlertView.h
//  IndustryLive
//
//  Created by ikrulala on 2018/1/24.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFAlertView : UIView
@property (nonatomic,   copy) void(^confirmHandle)(void);
@end
