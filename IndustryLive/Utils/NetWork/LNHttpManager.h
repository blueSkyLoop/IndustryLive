//
//  LNHttpManager.h
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/10.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef NS_OPTIONS(NSInteger,HUDTYPE){
    HUD_notShow                             = 0,            //不显示网络加载转圈
    HUD_showAndCompleHidden                 = 1 << 0,       //加载时显示，加载完成了自动消失
    HUD_showAndCompleShowSuccessMessage     = 1 << 1,       //加载时显示转圈，完成了之后显示一条信息
    HUD_showAndCompleShowFailureMessage     = 1 << 2        //加载时显示转圈，完成了之后显示一条信息
};

typedef void(^netSuccessBlock)(NSInteger code ,id response ,NSString *message);

typedef void(^netFailureBlock)(NSInteger code ,id response ,NSString *message);

typedef void(^netProgressBlock)(NSProgress *uploadProgress);

@interface LNHttpManager : AFHTTPSessionManager

+ (LNHttpManager *)shareManager;

//销毁单例
+ (void)destorylSintance;

- (NSURLSessionTask *)post:(NSString *)interfacstring parameter:(NSDictionary *)parameter progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure;

- (NSURLSessionTask *)get:(NSString *)interfacstring parameter:(NSDictionary *)parameter  progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure;

- (NSURLSessionTask *)postWithHud:(NSString *)interfacstring parameter:(NSDictionary *)parameter progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure;

- (NSURLSessionTask *)getWithHud:(NSString *)interfacstring parameter:(NSDictionary *)parameter  progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure;

- (NSURLSessionTask *)post:(NSString *)interfacstring parameter:(NSDictionary *)parameter hudType:(HUDTYPE)ahudType progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure;

- (NSURLSessionTask *)get:(NSString *)interfacstring parameter:(NSDictionary *)parameter hudType:(HUDTYPE)ahudType progress:(netProgressBlock)progress success:(netSuccessBlock)success failure:(netFailureBlock)failure;

- (void)cancelAllTask;

@end
