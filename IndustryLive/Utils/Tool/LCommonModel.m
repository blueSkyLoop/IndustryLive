//
//  LCommonModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "LCommonModel.h"
#import <CommonCrypto/CommonDigest.h>
#import "MHMacros.h"
#import "Masonry.h"

@implementation LCommonModel

#pragma mark - MD5加密
+ (NSString*)md532BitLowerKey:(NSString *)akey
{
    const char *cStr = [akey UTF8String];
    unsigned char result[16];
    
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
+ (NSString*)md532BitUpperKey:(NSString *)akey
{
    const char *cStr = [akey UTF8String];
    unsigned char result[16];
    
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5( cStr,[num intValue], result );
    
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}

#pragma mark - 重置文字大小
+ (void)resetFontSizeWithView:(UIView *)aview{
    NSAssert(aview && [aview isKindOfClass:[UIView class]], @"aview can not be nil and is must kind of 'UIView' class");
    if(aview.subviews.count == 0)  return;
    for(UIView *subV in aview.subviews){
        if([subV isKindOfClass:[UILabel class]]){
            UILabel *albel = (UILabel *)subV;
            CGFloat fontSize = MScale * [self fontSize:albel.font];
            albel.font = [UIFont systemFontOfSize:fontSize];
        }else if([subV isKindOfClass:[UIButton class]]){
            UIButton *abtn = (UIButton *)subV;
            CGFloat fontSize = MScale * [self fontSize:abtn.titleLabel.font];
            abtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        }else{
            [self resetFontSizeWithView:subV];
        }
    }
}
+ (CGFloat)fontSize:(UIFont *)afont{
    UIFontDescriptor *ctfFont = afont.fontDescriptor;
    NSNumber *fontString = [ctfFont objectForKey:@"NSFontSizeAttribute"];
    return fontString.floatValue;
}

#pragma mark 字体适配
+ (UIFont *)mh_fontWithSize:(CGFloat)fontSize{
    return [UIFont systemFontOfSize:MScale * fontSize];
}
+ (UIFont *)mh_weightMediumFontWithSize:(CGFloat)fontSize{
    UIFont *afont ;
    if([UIDevice  currentDevice].systemVersion.floatValue >= 8.2){
        afont = [UIFont systemFontOfSize:MScale * fontSize weight:UIFontWeightMedium];
    }else{
        afont = [UIFont systemFontOfSize:MScale * fontSize];
    }
    return afont;
}
+ (UIFont *)mh_semiboldFontWithSize:(CGFloat)fontSize{
    UIFont *afont ;
    if([UIDevice  currentDevice].systemVersion.floatValue >= 8.2){
        afont = [UIFont systemFontOfSize:MScale * fontSize weight:UIFontWeightSemibold];
    }else{
        afont = [UIFont systemFontOfSize:MScale * fontSize];
    }
    return afont;
}

#pragma mark - 快速创建控件
+ (UILabel *)quickCreateLabelWithFont:(UIFont *)afont textColor:(UIColor *)textColor{
    UILabel *alabel = [UILabel new];
    if(afont) alabel.font = afont;
    if(textColor) alabel.textColor = textColor;
    return alabel;
}
+ (UIButton *)quickCreateButtonWithFont:(UIFont *)afont normalTextColor:(UIColor *)normalColor selectTextColor:(UIColor *)selectTextColor{
    UIButton *button = [UIButton new];
    if(afont)  button.titleLabel.font = afont;
    if(normalColor) [button setTitleColor:normalColor forState:UIControlStateNormal];
    if(selectTextColor) [button setTitleColor:selectTextColor forState:UIControlStateSelected];
    return button;
}
+ (UIButton *)quickCreateButtonWithFont:(UIFont *)afont normalImage:(UIImage *)normalImage selectImage:(UIImage *)selectImage{
    UIButton *button = [UIButton new];
    if(afont)  button.titleLabel.font = afont;
    if(normalImage) [button setImage:normalImage forState:UIControlStateNormal];
    if(selectImage) [button setImage:selectImage forState:UIControlStateSelected];
    return button;
}

#pragma mark - 空状态视图
+ (UIView *)emptyViewWithTitleStr:(NSString *)titleStr topSpace:(CGFloat)topSpace{
    UIView *emptyView = [UIView new];
    emptyView.backgroundColor = MColorToRGB(0XF9FAFC);
    UIView *bgView = [UIView new];
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"announcement_notice_empty"];
    UILabel *label = [LCommonModel quickCreateLabelWithFont:[UIFont systemFontOfSize:MScale * 17] textColor:MColorToRGB(0X99A9BF)];
    label.numberOfLines = 0;
    label.text = titleStr?:@"暂无内容";
    [bgView addSubview:imageView];
    [bgView addSubview:label];
    [emptyView addSubview:bgView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.greaterThanOrEqualTo(bgView.mas_left);
        make.right.lessThanOrEqualTo(bgView.mas_right);
        make.centerX.equalTo(bgView.mas_centerX).priorityHigh();
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(8);
        make.left.greaterThanOrEqualTo(bgView.mas_left);
        make.right.lessThanOrEqualTo(bgView.mas_right);
        make.centerX.equalTo(bgView.mas_centerX).priorityHigh();
        make.bottom.equalTo(bgView.mas_bottom);
    }];
    if(topSpace != NSNotFound){
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(emptyView.mas_centerX);
            make.top.equalTo(emptyView.mas_top).offset(topSpace);
            make.bottom.lessThanOrEqualTo(emptyView.mas_bottom);
        }];
    }else{
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(emptyView);
        }];
    }
    return emptyView;
}
@end
