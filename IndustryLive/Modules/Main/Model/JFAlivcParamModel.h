//
//  JFAlivcParamModel.h
//  IndustryLive
//
//  Created by ikrulala on 2018/1/18.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *JFAlivcParamModelReuseCellSheet = @"JFAlivcParamModelReuseCellSheet";
static NSString *JFAlivcParamModelReuseCellLabel = @"JFAlivcParamModelReuseCellLabel";
static NSString *JFAlivcParamModelReuseCellInput = @"JFAlivcParamModelReuseCellInput";
static NSString *JFAlivcParamModelReuseCellSlider = @"JFAlivcParamModelReuseCellSlider";
static NSString *JFAlivcParamModelReuseCellSegment = @"JFAlivcParamModelReuseCellSegment";

@interface JFAlivcParamModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *placeHolder;
@property (nonatomic,copy) NSString *reuseId;
@property (nonatomic,copy) NSString *infoText;
@property (nonatomic,copy) NSString *segmentTitleArray;
@property (nonatomic,copy) NSString *defaultValue;

@property (nonatomic,assign) NSInteger buttonTag;

@property (nonatomic,copy) void(^channelBlock)(void);
@property (nonatomic,copy) void(^valueBlock)(id value);
@property (nonatomic,copy) void(^fpsBlock)(id value);
@property (nonatomic,copy) void(^sliderBlock)(id value);
@property (nonatomic,copy) void(^switchButtonBlock)(int value);

@end
