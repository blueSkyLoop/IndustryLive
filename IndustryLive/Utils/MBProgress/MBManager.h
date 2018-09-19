//
//  MBManager.h
//  GCDDemo
//
//  Created by Mr.lai on 2017/9/10.
//  Copyright © 2017年 Mr.lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNMBProgressHUD.h"

@interface MBManager : NSObject
//显示转圈，不携带文本信息，需手动消失
+ (void)showHUD;

//显示转圈，并携带文本信息，需手动消失
+ (void)showHUDMessage:(NSString *)message;

//显示文本，并显示3秒，3秒后自动消失
+ (void)showMessage:(NSString *)message;

//显示文本，并显示3秒，3秒后消失并回调
+ (void)showMessage:(NSString *)message comple:(MBProgressHUDCompletionBlock)block;

//显示文本，并显示3秒，3秒后自动消失,离底部偏移量
+ (void)showMessage:(NSString *)message bottomOffset:(CGFloat)offset;

//显示文本，并显示3秒，3秒后自动消失并回调,离底部偏移量
+ (void)showMessage:(NSString *)message bottomOffset:(CGFloat)offset comple:(MBProgressHUDCompletionBlock)block;

//显示信息，纯文本，不会自动消失，需要手动消失
+ (void)showInfor:(NSString *)infor;

//在aview上生成一个LNMBProgressHUD，会先查找有没有，没有再创建一个
+ (LNMBProgressHUD *)showHUDinview:(UIView *)aview  animated:(BOOL)animated comple:(MBProgressHUDCompletionBlock)block;

+ (void)hiddenHUD;
+ (void)hiddenHUDinview:(UIView *)aview;

+ (LNMBProgressHUD *)findLNMBProgressHUDinview:(UIView *)aview;


@end
