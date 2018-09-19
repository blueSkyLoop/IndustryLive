//
//  LivePushCheckModel.h
//  IndustryLive
//
//  Created by lgh on 2018/1/23.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LivePushCheckModel : NSObject
//频道id
@property (nonatomic,copy)NSString *channel_id;
//频道直播状态，0停播中，1直播中
@property (nonatomic,copy)NSString *live_status;
//频道存在与否，0不存在，1存在
@property (nonatomic,copy)NSString *is_exists;


@end
