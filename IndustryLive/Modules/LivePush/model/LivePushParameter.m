//
//  LivePushParameter.m
//  IndustryLive
//
//  Created by lgh on 2018/1/22.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "LivePushParameter.h"

@implementation LivePushParameter

+ (NSDictionary *)channelCheckWithUrl:(NSString *)url_push{
    return @{@"url_push":url_push?:@""};
}

@end
