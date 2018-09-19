//
//  LNHttpConfig.m
//  LaiKeBaoNew
//
//  Created by lgh on 2017/12/14.
//  Copyright © 2017年 lgh. All rights reserved.
//

#import "LNHttpConfig.h"

@implementation LNHttpConfig

+ (LNHttpConfig *)defaultHttpConfig{
    LNHttpConfig *config = [[LNHttpConfig alloc] initWithDefaultHttpConfig];
    return config;
}

//返回一个默认配置的请求配置
- (id)initWithDefaultHttpConfig{
    self = [super init];
    if(self){
        self.method = LNRequestMethodPost;
        self.hudType = HUD_showAndCompleHidden;
        self.checkClassName = NSStringFromClass([NSDictionary class]);
        self.errorShowMessage = YES;
    }
    return self;
}

@end
