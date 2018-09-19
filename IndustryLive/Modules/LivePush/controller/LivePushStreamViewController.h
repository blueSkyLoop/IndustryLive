//
//  LivePushStreamViewController.h
//  IndustryLive
//
//  Created by lgh on 2018/1/18.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import "LiveBaseViewController.h"
@class AlivcLivePushConfig;

@interface LivePushStreamViewController : LiveBaseViewController

- (id)initWithPushConfig:(AlivcLivePushConfig *)config pushUrl:(NSString *)pushUrl;

@end
