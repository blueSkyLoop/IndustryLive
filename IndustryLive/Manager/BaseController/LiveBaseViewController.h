//
//  LiveBaseViewController.h
//  IndustryLive
//
//  Created by lgh on 2018/1/18.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "ReactiveObjC.h"
#import "MHMacros.h"
#import "MBManager.h"

@interface LiveBaseViewController : UIViewController

- (void)live_setUpUI;

- (void)live_bindViewModel;

@end
