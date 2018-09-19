//
//  JFPickerView.h
//  IndustryLive
//
//  Created by ikrulala on 2018/1/23.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFPickerView : UIView
@property (nonatomic, assign) NSString *defaultValue;
@property (nonatomic,   copy) void(^confirmHandle)(id selectedValue);
@end
