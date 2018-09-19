//
//  LiveUserInforModel.m
//  IndustryLive
//
//  Created by lgh on 2018/1/23.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "LiveUserInforModel.h"
#import <MJExtension.h>

@implementation LiveUserInforModel

MJCodingImplementation

+ (BOOL)saveUserInfor:(LiveUserInforModel *)model{
    return [self archiveUserInfor:model];
}

+ (void)clearUserInfor{
    [self archiveUserInfor:nil];
}
+ (LiveUserInforModel *)currentUserInfor{
    return [self unArchiveUserInfor];
}

+ (BOOL)archiveUserInfor:(LiveUserInforModel *)model{
    return [NSKeyedArchiver archiveRootObject:model toFile:[self archivePath]];
}

+ (LiveUserInforModel *)unArchiveUserInfor{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePath]];
}

+ (NSString *)archivePath{
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path =[docPath stringByAppendingPathComponent:@"liveUserInfor"];
    return path;
}

@end
