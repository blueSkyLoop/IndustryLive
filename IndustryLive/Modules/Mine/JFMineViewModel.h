//
//  JFMineViewModel.h
//  IndustryLive
//
//  Created by ikrulala on 2018/1/24.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "LiveBaseViewModel.h"

@interface JFMineViewModel : LiveBaseViewModel
@property (nonatomic,strong)RACSubject *signOutSubject;
- (void)signOutRequest;
- (void)userInfoRequest;
@end
