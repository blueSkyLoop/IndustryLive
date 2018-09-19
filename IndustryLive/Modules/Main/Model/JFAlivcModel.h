//
//  JFAlivcModel.h
//  IndustryLive
//
//  Created by ikrulala on 2018/1/23.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFAlivcModel : NSObject
/**频道id*/
@property (nonatomic,copy) NSString *channel_id;
/**频道名称*/
@property (nonatomic,copy) NSString *live_title;
/**推流地址*/
@property (nonatomic,copy) NSString *url_push;
@end
