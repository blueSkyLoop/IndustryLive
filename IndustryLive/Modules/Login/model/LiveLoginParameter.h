//
//  LiveLoginParameter.h
//  IndustryLive
//
//  Created by lgh on 2018/1/22.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import <Foundation/Foundation.h>

//登录
static NSString *const API_login = @"live-app/login";

@interface LiveLoginParameter : NSObject

//登录
+ (NSDictionary *)loginWithUsername:(NSString *)username password:(NSString *)password;

@end
