//
//  LivePushViewModel.h
//  IndustryLive
//
//  Created by lgh on 2018/1/18.
//  Copyright © 2018年 IndustryLive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlivcLivePusher/AlivcLivePusher.h>
#import "LiveBaseViewModel.h"

@interface LivePushViewModel : LiveBaseViewModel

//是否预览
@property (nonatomic,assign)BOOL isPrever;

//推流是否链接成功
@property (nonatomic,assign)BOOL isConectPush;

//是否正在推流，用于记录退到后台的时候的状态
@property (nonatomic,assign)BOOL pushingFlag;

@property (nonatomic,copy)NSString *currentTimeText;

@property (nonatomic,assign)AlivcLivePushCameraType cameraType;


//开始计时
- (void)startTime;
- (void)destroyTime;

- (void)checkPushUrlWithUrlString:(NSString *)pushUrl;


@end
