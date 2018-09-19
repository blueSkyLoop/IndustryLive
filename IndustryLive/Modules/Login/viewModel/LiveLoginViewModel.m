//
//  LiveLoginViewModel.m
//  IndustryLive
//
//  Created by lgh on 2018/1/22.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "LiveLoginViewModel.h"
#import "LiveLoginParameter.h"
#import "LiveUserInforModel.h"

@implementation LiveLoginViewModel

- (void)live_initialize{
    @weakify(self);
    self.resultBlock = ^(BOOL success, NSInteger apiFlag, NSInteger code, id data, id orginData, NSString *message) {
        @strongify(self);
        if(success){
            if(data){
                LiveUserInforModel *userModel = (LiveUserInforModel *)data;
                [LiveUserInforModel saveUserInfor:userModel];
                [self.requestSuccessSubject sendNext:nil];
            }else{
                [self.requestFailureSubject sendNext:RACTuplePack(@(code),message)];
            }
        }else{
            [self.requestFailureSubject sendNext:RACTuplePack(@(code),message)];
        }
    };
}

- (void)loginRequest{
    LNHttpConfig *config = [self live_defaultHttpConfigWithApi:API_login];
    config.parameter = [LiveLoginParameter loginWithUsername:self.username password:self.password];
    config.parserBlock = ^(LNParserMarker *marker) {
        marker.className(@"LiveUserInforModel");
    };
    config.errorShowMessage = NO;
    [self startHttpWithRequestConfig:config];
}

@end
