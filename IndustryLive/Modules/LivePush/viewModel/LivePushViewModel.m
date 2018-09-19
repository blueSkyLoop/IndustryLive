//
//  LivePushViewModel.m
//  IndustryLive
//
//  Created by lgh on 2018/1/18.
//  Copyright © 2018年 IndustryLive. All rights reserved.
//

#import "LivePushViewModel.h"

#import "LivePushParameter.h"
#import "LivePushCheckModel.h"

@interface LivePushViewModel ()

@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)NSInteger totalTime;

@end

@implementation LivePushViewModel

- (void)dealloc{
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)live_initialize{
    self.currentTimeText = @"00:00:00";
    @weakify(self);
    self.resultBlock = ^(BOOL success, NSInteger apiFlag, NSInteger code, id data, id orginData, NSString *message) {
        if(success){
            @strongify(self);
            LivePushCheckModel *checkModel = (LivePushCheckModel *)data;
            if(checkModel.channel_id && checkModel.channel_id.length && checkModel.live_status && checkModel.live_status.length){
                if(checkModel.is_exists.integerValue == 1 && checkModel.live_status.integerValue == 0){
                    [self.requestSuccessSubject sendNext:nil];
                }else if(checkModel.live_status.integerValue == 1){//正在直播
                    [self.requestFailureSubject sendNext:nil];
                }else{
                    [self.requestSuccessSubject sendNext:nil];
                }
                
            }else{
                [self.requestSuccessSubject sendNext:nil];
            }
            
        }else{
            [MBManager showMessage:message];
        }
    };
}

- (void)checkPushUrlWithUrlString:(NSString *)pushUrl{
    LNHttpConfig *config = [self live_defaultHttpConfigWithApi:API_live_channel];
    config.errorShowMessage = NO;
    config.parameter = [LivePushParameter channelCheckWithUrl:pushUrl];
    config.parserBlock = ^(LNParserMarker *marker) {
        marker.className(@"LivePushCheckModel");
    };
    [self startHttpWithRequestConfig:config];
}

//开始计时
- (void)startTime{
    [self destroyTime];
    self.totalTime = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(caluateTime) userInfo:nil repeats:YES];
}

- (void)caluateTime{
    self.totalTime ++;
    self.currentTimeText = [self getMMSSFromSS:self.totalTime];
    
}
- (NSString *)getMMSSFromSS:(NSInteger)seconds{
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}

- (void)destroyTime{
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
}


@end
