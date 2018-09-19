//
//  LivePStreamTopView.h
//  IndustryLive
//
//  Created by lgh on 2018/1/18.
//  Copyright © 2018年 IndustryLive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AlivcLivePusher/AlivcLivePusher.h>

#import "LiveSlider.h"

typedef NS_ENUM(NSInteger, LiveConfitType){
    LiveConfitTypeBeauty = 1,           //美颜
    LiveConfitTypeMic,                  //麦克风
    LiveConfitTypeFlash,                //闪光灯
    LiveConfitTypeCamera,               //摄像头切换
};

@interface LivePStreamTopView : UIView
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *beautyBtn;
@property (weak, nonatomic) IBOutlet UIButton *micBtn;
@property (weak, nonatomic) IBOutlet UIButton *flashBtn;
@property (weak, nonatomic) IBOutlet UIButton *camerBtn;
@property (weak, nonatomic) IBOutlet LiveSlider *rateSliler;
@property (weak, nonatomic) IBOutlet UILabel *rateInforLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *liveBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gap5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topGap;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomGap;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderWidth;

@property (nonatomic,copy)void (^backBlock)(void);
@property (nonatomic,copy)void (^configBlock)(LiveConfitType type);
@property (nonatomic,copy)void (^liveBlock)(BOOL isStart);
@property (nonatomic,copy)void (^rateBlock)(int rate);

+ (LivePStreamTopView *)loadFromXib;

- (void)updateDefaultValueWithConfig:(AlivcLivePushConfig *)pushConfig;


- (void)updateUIHidden:(BOOL)isHidden;

@end
