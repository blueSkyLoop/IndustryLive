//
//  LiveLoginViewModel.h
//  IndustryLive
//
//  Created by lgh on 2018/1/22.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "LiveBaseViewModel.h"

@interface LiveLoginViewModel : LiveBaseViewModel

@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *password;

- (void)loginRequest;

@end
