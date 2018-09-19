//
//  LiveLoginParameter.m
//  IndustryLive
//
//  Created by lgh on 2018/1/22.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "LiveLoginParameter.h"
#import "LCommonModel.h"

@implementation LiveLoginParameter

+ (NSDictionary *)loginWithUsername:(NSString *)username password:(NSString *)password{
    return @{
             @"username":username?:@"",
             @"password":[LCommonModel md532BitLowerKey:password]?:@""
             };
}

@end
