//
//  MHMacros.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/4.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#ifndef MHMacros_h
#define MHMacros_h
#import "LCommonModel.h"

#define WINDOW [UIApplication sharedApplication].keyWindow


#define isIPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//是否为iPhone6、7、8
#define isIPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//是否为iPhone6、7、8 Plus
#define isIPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIPhone5() ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isIPhone4() ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
// double

#pragma mark - 屏幕宽高
#define MScreenW [UIScreen mainScreen].bounds.size.width
#define MScreenH [UIScreen mainScreen].bounds.size.height
#define MScale MIN(MScreenW, MScreenH)/375
#define iOS8 [[UIDevice currentDevice] systemVersion].floatValue >= 8.0 && [[UIDevice currentDevice] systemVersion].floatValue <= 9.0
#define iOS8_2_OR_LATER [[UIDevice currentDevice] systemVersion].floatValue >= 8.3
#define iOS9 [[UIDevice currentDevice] systemVersion].floatValue >= 9.0 && [[UIDevice currentDevice] systemVersion].floatValue <= 10.0
#define iOS11 [[UIDevice currentDevice] systemVersion].floatValue >= 11.0 && [[UIDevice currentDevice] systemVersion].floatValue <= 12.0
#define iOS9_1_OR_LATER [[UIDevice currentDevice] systemVersion].floatValue >= 9.1
#define iOS10 [[UIDevice currentDevice] systemVersion].floatValue >= 10.0 && [[UIDevice currentDevice] systemVersion].floatValue <= 11.0
#define iOS11_Or_Later [[UIDevice currentDevice] systemVersion].floatValue >= 11.0
#define MToolBarHeight (MScreenH == 812.0 ? 83 : 49)          //Tabar高度
#define MTopHight (MScreenH == 812.0 ? 88 : 64)               //导航样高度 +  状态栏 高度
#define MTopStatus_Height (MScreenH == 812.0 ? 44 : 20)         // 状态栏 高度
#define MLineH 0.7                 //线条高度或宽度
#define MConstCellHeight 50          // 常用TableViewCell高度
//#define MDefaultMargin 24            // 常用控件与界面边缘的距离

//#define MSafeAreaTopHeight (MScreenH == 812.0 ? 88 : 64)
//#define MSafeAreaBottomHeight (MScreenH == 812.0 ? 34 : 0)


#pragma mark - Color
#define MColorMainGradientStart MColorToRGB(0XFF586E)            //主调渐变开始色
#define MColorMainGradientEnd MColorToRGB(0XFF7E60)              //主调渐变结束色
#define MColorMainGradientHighlightStart MColorToRGB(0XFF6785)            //主调渐变高亮开始色
#define MColorMainGradientHighlightEnd MColorToRGB(0XFF9C6F)              //主调渐变高亮结束色

#define MColorRed MColorToRGB(0XFF4949)                  //红
#define MColorBlue MColorToRGB(0X20A0FF)                 //蓝
#define MColorGreen MColorToRGB(0X13CE66)                //绿
#define MColorYellow MColorToRGB(0XF7BA2A)               //黄
#define MColorTheme  MColorToRGB(0XED373D)               //主题颜色

#define MColorGeneralLeader MColorToRGB(0XFFA848)               //总队长

#define MColorBackgroud MRGBColor(249,250, 252)          //背景色
#define MColorSeparator MColorToRGB(0XD3DCE6)            //分割线色
#define MColorShadow MColorToRGB(0XEFF2F7)                //阴影颜色

#define MColorTitle MColorToRGB(0X324057)                  //文章标题文本色
#define MColorContent MColorToRGB(0XC0CCDA)               //文章正文文本色
#define MColorFootnote MColorToRGB(0X8492A6)             // 脚注；补充说明
#define MColorFootnote2 MColorToRGB(0X99A9BF)             // 脚注；补充说明

#define MColorDidSelectCell MColorToRGB(0XF9FAFC)               // TableViewCell 点击颜色
#define MColorDisableBtn    MColorToRGB(0XE5E9F2)               // Btn禁用颜色
#define MColorConfirmBtn MColorToRGB(0X20A0FF)                 // Btn确定颜色

#define MRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]// RGB色
#define MRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]// RGB色
#define MRandomColor MRGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))// 随机色
#define MColorToRGB(value) MColorToRGBWithAlpha(value, 1.0f)
#define MColorToRGBWithAlpha(value, alpha1) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:alpha1]//十六进制转RGB色


#pragma mark - Font
#define MFontTitle [UIFont systemFontOfSize:17]            //文章标题、输入文字
#define MFontContent [UIFont systemFontOfSize:14]         //一般字号，文章正文
#define MFontFootnote [UIFont systemFontOfSize:12]        //脚注；补充说明
#define MFont(a) [UIFont systemFontOfSize:(a)]

/*****************add by Lance **********************/
//普通的字体
#define MHFont(fontSize) [LCommonModel mh_fontWithSize:fontSize]
//
#define MHWFont(fontSize) [LCommonModel mh_weightMediumFontWithSize:fontSize]
//粗体
#define MHSFont(fontSize) [LCommonModel mh_semiboldFontWithSize:fontSize]

#pragma mark - Other
/** 默认头像*/
#define MAvatar     [UIImage imageNamed:@"com_defaultAvartar"]
#define MCornerRadius 6  //圆角

#define MGetMaxY(control) CGRectGetMaxY(control.frame)
#define MGetMaxYAddValue(control, value) CGRectGetMaxY(control.frame) + value
#define MGetMinY(control) CGRectGetMinY(control.frame)
#define MGetMinYAddValue(control, value) CGRectGetMinY(control.frame) + value

#define MGetMaxX(control) CGRectGetMaxX(control.frame)
#define MGetMaxXAddValue(control, value) CGRectGetMaxX(control.frame) + value
#define MGetMinX(control) CGRectGetMinX(control.frame)
#define MGetMinXAddValue(control, value) CGRectGetMinX(control.frame) + value
#endif /* MHMacros_h */
