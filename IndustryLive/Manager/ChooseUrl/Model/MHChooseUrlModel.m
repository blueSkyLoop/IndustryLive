//
//  JFRequestModel.m
//  JFCommunityCenter
//
//  Created by hanl on 2016/12/6.
//  Copyright © 2016年 com.cn. All rights reserved.
//

#import "MHChooseUrlModel.h"
#import "LNHttpManager.h"
#import <AFHTTPSessionManager.h>


@interface MHChooseUrlModel ()
@property (nonatomic,copy) NSString * initialHttpIP;
@end



@implementation MHChooseUrlModel

static NSString *cacheHttpIPStr;

static NSString *devUrl = @"http://172.16.3.189:8000/" ;
static NSString *testUrl = @"http://172.16.3.189:8010/" ;


- (NSString *)initialHttpIP{
#if JF_Dev
    return   testUrl;
#elif JF_AppStore
    return  @"http://172.16.3.189:8010/";
#endif
}

+(MHChooseUrlModel *)shareInstance {
    static MHChooseUrlModel *request = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[MHChooseUrlModel alloc] init];
    });
    return request;
}

+ (NSString *)getBaseHttpIP {
    return [[self shareInstance] getBaseHttpIP];
}

+ (void)setBaseHttpIP:(NSString *)ipStr {
    [[self shareInstance] setBaseHttpIP:ipStr];
}


+ (NSArray *)requestArray {
    return @[
             @{@"name":@"开发环境",   @"ip":devUrl},
             
             @{@"name":@"测试环境",   @"ip":testUrl}
             ];
}

#define cacheUrl_Key @"BaseHttpIP"
- (NSString *)getBaseHttpIP {
    if (cacheHttpIPStr == nil) {
#if JF_Dev
        cacheHttpIPStr = self.initialHttpIP;
#elif   JF_AppStore
        NSString *ipStr = [[NSUserDefaults standardUserDefaults] objectForKey:cacheUrl_Key];
        if (ipStr == nil) {
            cacheHttpIPStr = self.initialHttpIP;
            [[NSUserDefaults standardUserDefaults] setObject:self.initialHttpIP forKey:cacheUrl_Key];
        } else {
            cacheHttpIPStr = ipStr;
        }
#endif

        
    }
    return cacheHttpIPStr;
}

- (void)setBaseHttpIP:(NSString *)ipStr {
    cacheHttpIPStr = ipStr;
    [[NSUserDefaults standardUserDefaults] setObject:ipStr forKey:cacheUrl_Key];
    [LNHttpManager destorylSintance];
}

@end
