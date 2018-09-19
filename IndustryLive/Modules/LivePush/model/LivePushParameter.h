//
//  LivePushParameter.h
//  IndustryLive
//
//  Created by lgh on 2018/1/22.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const API_live_channel = @"live-app/url-push/query";

@interface LivePushParameter : NSObject

+ (NSDictionary *)channelCheckWithUrl:(NSString *)url_push;

@end
