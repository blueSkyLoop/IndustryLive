//
//  JFMineViewModel.m
//  IndustryLive
//
//  Created by ikrulala on 2018/1/24.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "JFMineViewModel.h"
#import "LiveUserInforModel.h"

@implementation JFMineViewModel

- (void)live_initialize{
    @weakify(self);
    self.resultBlock = ^(BOOL success, NSInteger apiFlag, NSInteger code, id data, id orginData, NSString *message) {
        @strongify(self);
        if(success){
            if(data){
                if (apiFlag == 122) {
                    [self.requestSuccessSubject sendNext:data];
                }else {
                    [self.signOutSubject sendNext:nil];
                }
            }
        }
    };
}

- (void)signOutRequest {
    LNHttpConfig *config = [self live_defaultHttpConfigWithApi:@"live-app/logout"];
    config.parameter = @{@"token":[LiveUserInforModel currentUserInfor].token};
    config.apiFlag = 123;
    [self startHttpWithRequestConfig:config];
}

- (void)userInfoRequest {
    LNHttpConfig *config = [self live_defaultHttpConfigWithApi:@"live-app/user/main"];
    config.parameter = @{@"token":[LiveUserInforModel currentUserInfor].token};
    config.apiFlag = 122;
    config.parserBlock = ^(LNParserMarker *marker) {
        marker.className(@"JFMineModel");
    };
    [self startHttpWithRequestConfig:config];
}

- (RACSubject *)signOutSubject{
    if(!_signOutSubject){
        _signOutSubject = [RACSubject subject];
    }
    return _signOutSubject;
}


@end
