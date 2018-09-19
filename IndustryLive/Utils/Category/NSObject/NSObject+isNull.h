//
//  NSObject+isNull.h
//  WonderfulLife
//
//  Created by Lo on 2017/7/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (isNull)
+(BOOL)isNull:(id)object ;
- (NSMutableDictionary *)createDictionayFromModelProperties;

- (BOOL)isNull ;
@end
