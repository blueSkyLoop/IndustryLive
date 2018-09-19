//
//  LivePStreamTopView.m
//  IndustryLive
//
//  Created by lgh on 2018/1/18.
//  Copyright © 2018年 IndustryLive. All rights reserved.
//

#import "LivePStreamTopView.h"
#import <ReactiveObjC.h>
#import "MHMacros.h"
#import "LCommonModel.h"

@interface LivePStreamTopView()<UIGestureRecognizerDelegate>

@property (nonatomic,assign)int currentRate;


@end

@implementation LivePStreamTopView

+ (LivePStreamTopView *)loadFromXib{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
}


- (void)awakeFromNib{
    [super awakeFromNib];
    
    [LCommonModel resetFontSizeWithView:self.topView];
    self.rateLabel.font = MHSFont(14);
    self.liveBtn.titleLabel.font = MHSFont(16);
    
    self.liveBtn.layer.cornerRadius = 4;
    self.liveBtn.layer.masksToBounds = YES;
    
    self.rateSliler.thumbTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"live_slider"]];
    
    
    self.gap1.constant = 20 * MScale;
    self.gap2.constant = 20 * MScale;
    self.gap3.constant = 20 * MScale;
    self.gap4.constant = 37 * MScale;
    self.gap5.constant = 25 * MScale;
    self.sliderWidth.constant = (isIPhoneX?250:100) * MScale;
    
    [self live_bind];
    [self addGes];
    
}
- (IBAction)backAction:(UIButton *)sender {
    if(self.backBlock){
        self.backBlock();
    }
}
- (IBAction)liveConfigAction:(UIButton *)sender {
    if(self.configBlock){
        self.configBlock(sender.tag);
    }
    
}
- (IBAction)rateChangeAction:(UISlider *)sender {
    self.currentRate = (int)sender.value;
    self.rateInforLabel.text = [NSString stringWithFormat:@"%d%@",self.currentRate,@"kbps"];
}
- (IBAction)liveAction:(UIButton *)sender {
    if(self.liveBlock){
        self.liveBlock(!sender.isSelected);
    }
}

- (void)live_bind{
    @weakify(self);
    [[[self.rateSliler rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:.3] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if(self.rateBlock){
            self.rateBlock(self.currentRate);
        }
    }];
    [[[self.rateSliler rac_signalForControlEvents:UIControlEventTouchUpOutside] throttle:.3] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if(self.rateBlock){
            self.rateBlock(self.currentRate);
        }
    }];
}

- (void)addGes{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.delegate = self;
    @weakify(self);
    [[tap.rac_gestureSignal throttle:.2] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        [self updateUIHidden:self.bottomGap.constant > 0];
    }];
    [self addGestureRecognizer:tap];
}

- (void)updateDefaultValueWithConfig:(AlivcLivePushConfig *)pushConfig{
    self.currentRate = pushConfig.targetVideoBitrate;
    self.rateSliler.value = (CGFloat)self.currentRate;
    self.rateInforLabel.text = [NSString stringWithFormat:@"%d%@",self.currentRate,@"kbps"];
    self.beautyBtn.selected = pushConfig.beautyOn;
    self.flashBtn.selected = pushConfig.flash;
    self.micBtn.selected = YES;
}

- (void)updateUIHidden:(BOOL)isHidden{
    
    self.topGap.constant = isHidden?-45:0;
    self.bottomGap.constant = isHidden?-45:46;
    [UIView animateWithDuration:.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - GES
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self) {
        return YES;
    }
    return  NO;
}


@end
