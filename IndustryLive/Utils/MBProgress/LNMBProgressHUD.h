//
//  LNMBProgressHUD.h
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/10.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import <MBProgressHUD.h>

@interface LNMBProgressHUD : MBProgressHUD

@property (nonatomic, assign, getter=hasFinished) BOOL finished;

@end
