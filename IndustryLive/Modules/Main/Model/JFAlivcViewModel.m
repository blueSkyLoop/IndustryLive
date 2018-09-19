//
//  JFAlivcViewModel.m
//  IndustryLive
//
//  Created by ikrulala on 2018/1/23.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "JFAlivcViewModel.h"
#import "LiveUserInforModel.h"

@implementation JFAlivcViewModel

- (void)live_initialize{
    @weakify(self);
    self.resultBlock = ^(BOOL success, NSInteger apiFlag, NSInteger code, id data, id orginData, NSString *message) {
        @strongify(self);
        if(success){
            if(data){
                NSArray *array = (NSArray *)data;
                [self.requestSuccessSubject sendNext:array];
            }
        }
    };
}


- (void)channelListRequest{
    LNHttpConfig *config = [self live_defaultHttpConfigWithApi:@"live-app/user/channel/list"];
    config.parameter = @{@"token":[LiveUserInforModel currentUserInfor].token};
    config.parserBlock = ^(LNParserMarker *marker) {
        marker.parserKey(@"channel_list").keyClassName(@"JFAlivcModel");
    };
    [self startHttpWithRequestConfig:config];
}

@end
