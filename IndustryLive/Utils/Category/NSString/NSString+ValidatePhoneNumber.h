//
//  NSString+ValidatePhoneNumber.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ValidatePhoneNumber)
+ (BOOL)mh_validatePhoneNumber:(NSString *)number;

+ (BOOL)mh_isMobileNumber:(NSString *)mobileNum ;
@end
