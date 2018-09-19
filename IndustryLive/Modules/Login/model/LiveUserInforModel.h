//
//  LiveUserInforModel.h
//  IndustryLive
//
//  Created by lgh on 2018/1/23.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveUserInforModel : NSObject<NSCoding>

@property (nonatomic,copy)NSString *token;
@property (nonatomic,copy)NSString *mobile_phone;
@property (nonatomic,assign)NSTimeInterval expired_timestamp;


+ (BOOL)saveUserInfor:(LiveUserInforModel *)model;

+ (void)clearUserInfor;
+ (LiveUserInforModel *)currentUserInfor;



@end
