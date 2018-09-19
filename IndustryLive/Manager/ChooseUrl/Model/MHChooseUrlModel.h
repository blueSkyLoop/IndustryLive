//
//  JFRequestModel.h
//  JFCommunityCenter
//
//  Created by hanl on 2016/12/6.
//  Copyright © 2016年 com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHChooseUrlModel : NSObject
/** 获取base IP */
+ (NSString *)getBaseHttpIP;

/** 设置base IP*/
+ (void)setBaseHttpIP:(NSString *)ipStr;

+ (NSArray *)requestArray;

@end
