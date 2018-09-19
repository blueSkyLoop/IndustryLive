//
//  LCommonModel.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LCommonModel : NSObject
#pragma mark - MD5加密
+ (NSString*)md532BitLowerKey:(NSString *)akey;

+ (NSString*)md532BitUpperKey:(NSString *)akey;

#pragma mark - 重置文字大小
+ (void)resetFontSizeWithView:(UIView *)aview;

#pragma mark 字体适配
+ (UIFont *)mh_fontWithSize:(CGFloat)fontSize;
+ (UIFont *)mh_weightMediumFontWithSize:(CGFloat)fontSize;
+ (UIFont *)mh_semiboldFontWithSize:(CGFloat)fontSize;


#pragma mark - 快速创建控件
+ (UILabel *)quickCreateLabelWithFont:(UIFont *)afont textColor:(UIColor *)textColor;
+ (UIButton *)quickCreateButtonWithFont:(UIFont *)afont normalTextColor:(UIColor *)normalColor selectTextColor:(UIColor *)selectTextColor;
+ (UIButton *)quickCreateButtonWithFont:(UIFont *)afont normalImage:(UIImage *)normalImage selectImage:(UIImage *)selectImage;

#pragma mark - 空状态视图
/*titleStr 显示的标题  topSpace 距离顶部的距离，如果要居中，传 NSNotFound*/
+ (UIView *)emptyViewWithTitleStr:(NSString *)titleStr topSpace:(CGFloat)topSpace;

@end
