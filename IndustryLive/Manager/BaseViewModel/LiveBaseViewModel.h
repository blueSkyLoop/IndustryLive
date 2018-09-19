//
//  LiveBaseViewModel.h
//  IndustryLive
//
//  Created by lgh on 2018/1/19.
//  Copyright © 2018年 IndustryLive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"
#import "MBManager.h"
#import "LNHttpManager.h"
#import "YYModel.h"
#import "LNHttpConfig.h"

//网络请求结果的回调,外部关心这个结果即可，或者子类对这个回调再次封装
typedef void(^RequestResultBlock)(BOOL success,NSInteger apiFlag,NSInteger code ,id data ,id orginData,NSString *message);

@interface LiveBaseViewModel : NSObject

//数据源
@property (nonatomic,strong)NSMutableArray *dataSoure;

//基础请求命令
@property (nonatomic,strong,readonly)RACCommand *baseRequestCommond;

//当前请求的配置
@property (nonatomic,strong,readonly)LNHttpConfig *currentConfig;

//请求回调
@property (nonatomic,copy)RequestResultBlock resultBlock;

@property (nonatomic,strong,readonly)RACSubject *requestSuccessSubject;
@property (nonatomic,strong,readonly)RACSubject *requestFailureSubject;

//初始化
- (void)live_initialize;

//实例化一个基础的请求配置
- (LNHttpConfig *)live_defaultHttpConfigWithApi:(NSString *)apiStr;

//开启一个请求,对于开启一个接口，关注的应该是这个请求的配置，中间请求过程和结果处理无需关心，因为配置已经决定了请求和结果处理
- (void)startHttpWithRequestConfig:(LNHttpConfig *)model;

//重新请求和上一次请求一样的请求
- (void)reStartHttp;

//统一处理错误信息
- (void)handleErrmsg:(NSString *)errmsg errorCodeNum:(NSNumber *)errorCodeNum subscriber:(id<RACSubscriber>)subscriber;

//检测数据的返回类型是否符合，不符合的话内部会作错误处理发送,外部只要关心为YES的情况
- (BOOL)checkDataWithClass:(Class)aclass data:(id)data subscriber:(id<RACSubscriber>)subscriber;

//成功数据的处理
- (void)handleSuccessData:(id)data subscriber:(id<RACSubscriber>)subscriber;

@end
