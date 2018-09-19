//
//  NSObject+isNull.m
//  WonderfulLife
//
//  Created by Lo on 2017/7/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "NSObject+isNull.h"
#import <objc/runtime.h>

@implementation NSObject (isNull)
+(BOOL)isNull:(id)object
{
    if ([object isKindOfClass:[NSString class]]) {
        NSString *temp = object;
        NSString *temp1 = [temp stringByReplacingOccurrencesOfString:@" " withString:@""];
        temp1 = [temp1 stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        if (temp1.length==0) {
            return YES;
        }else {
            return NO;
        }
    }
    // 判断是否为空串
    if ([object isEqual:[NSNull null]]) {
        return YES;
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if ([object isEqual:[NSNumber class]])
    {
        return YES;
    }
    else if (object==nil){
        return YES;
    }
    return NO;
}

- (BOOL)isNull {
    return  [NSObject isNull:self];
}

- (NSMutableDictionary *)createDictionayFromModelProperties
{
    NSMutableDictionary *propsDic = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    // class:获取哪个类的成员属性列表
    // count:成员属性总数
    // 拷贝属性列表
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        // 属性名
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        // 属性值
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        // 设置KeyValues
        if (propertyValue) [propsDic setObject:propertyValue forKey:propertyName];
    }
    // 需手动释放 不受ARC约束
    free(properties);
    return propsDic;
}


@end
