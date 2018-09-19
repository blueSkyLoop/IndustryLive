//
//  AppDelegate+Helper.m
//  IndustryLive
//
//  Created by Lol on 2018/1/17.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import "AppDelegate+Helper.h"
#import "IQKeyboardManager.h"
#import "LiveNotificationDefine.h"
#import "LiveUserDefaultDefine.h"
#import <ReactiveObjC.h>
#import <Bugly/Bugly.h>
#import <SDWebImageManager.h>


#import "LiveUserInforModel.h"
#import "NSObject+isNull.h"

@implementation AppDelegate (Helper)

- (void)jf_bugly {
    NSString *buglyAppid ;
#if JF_Dev
    buglyAppid = @"adb36366c2";
#elif JF_AppStore
    buglyAppid = @"ae25f618f0";
#endif
    //    NSString *buglyAppkey = @"a0a28b20-fcab-4f27-975d-72de69e6fc52";
    [Bugly startWithAppId:buglyAppid];
}

- (void)jf_helperConfig {
    //keyboard
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)jf_addNotification{
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:KLiveLoginNotification object:nil] takeUntil:self.rac_willDeallocSignal]  subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            //清空用户信息
            [LiveUserInforModel clearUserInfor];
            [self enterLogin];
        });
    }];
}

- (void)jf_downLoadAdvertising {
    // 获取缓存地址
    NSString *cacheUrl = MNSUserDefaultsGet_String(LiveUserDefault_LaunchUrlKey);
//    NSString *url = @"http://172.16.3.188:8090/web/uploadfiles/aritcle/201801020456065485.jpg" ;
    NSString *url = @"http://172.16.3.188:8090/web/uploadfiles/ad/201712130152232519.jpg";
    // 1.请求链接，获取字段是否要更新图片
    if (![url isNull] && ![url isEqualToString:cacheUrl]) {
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:url] options:SDWebImageRefreshCached  progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if(finished){
                MNSUserDefaultsSet([imageURL absoluteString], LiveUserDefault_LaunchUrlKey);
            }
        }];
    }
}
         
         @end
