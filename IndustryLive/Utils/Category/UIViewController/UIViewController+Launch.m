//
//  UIViewController+Launch.m
//  IndustryLive
//
//  Created by Lol on 2018/2/1.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "UIViewController+Launch.h"
#import <Masonry.h>
#import <objc/runtime.h>
#import "SDWebImageManager.h"
#import "SDImageCache.h"

#import "LiveUserDefaultDefine.h"
#import "NSObject+isNull.h"
@interface UIViewController ()

@property(nonatomic,strong)UIView *launchView;

@property(nonatomic,strong)UIButton *jump;

@property(nonatomic,strong)NSTimer *timer;
@end

@implementation UIViewController (Launch)





- (void)jf_Lauch {
    NSString* strUrl = MNSUserDefaultsGet_String(LiveUserDefault_LaunchUrlKey);
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:strUrl]];
    SDImageCache* cache = [SDImageCache sharedImageCache];
    UIImage *bg_image = [cache imageFromDiskCacheForKey:key];
    
    //![bg_image isNull] //  此判断无效
    if (![key isNull] && ![NSObject isNull:bg_image]) { // 判断是否已经有 缓存图片 && url 存在，如果有就加载广告页出来
        self.launchView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.launchView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.launchView];

        // 广告图
        UIImageView *bg = [[UIImageView alloc] initWithFrame:self.launchView.frame];
//        [bg setBackgroundColor:[UIColor redColor]];
        bg.contentMode = UIViewContentModeScaleAspectFill ;
        //    [bg setImage:[UIImage imageNamed:@"高达oo.jpg"]];//这边图片可以做网络请求加载图片、视频动画或者其他自定义的引导页
        //此方法会先从memory中取。
        bg.image = bg_image;
        
        [self.launchView addSubview:bg];
        
        self.jump = [UIButton new];
        [self.jump setTitle:@"3\t\t跳过广告" forState:UIControlStateNormal];
        [self.jump setBackgroundColor:[UIColor lightGrayColor]];
        [self.jump setTintColor:[UIColor whiteColor]];
        [self.jump.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [self.jump addTarget:self action:@selector(removeLaunchView) forControlEvents:UIControlEventTouchUpInside];
        [self.launchView addSubview:self.jump];
        
        [self.jump mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(24);
            make.right.mas_equalTo(-12);
            make.height.equalTo(@30);
            make.width.equalTo(@100);
        }];
        [self.jump layoutIfNeeded];
        CGRect  imageFrame = self.jump.frame ;
        self.jump.layer.cornerRadius = imageFrame.size.width*0.15  ;
        self.jump.layer.masksToBounds = YES ;
        [self.jump.titleLabel setAdjustsFontSizeToFitWidth:YES];
        
        self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(textChange) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] addTimer:[NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(removeLaunchView) userInfo:nil repeats:NO] forMode:NSRunLoopCommonModes];
    }
}

- (void)removeLaunchView {
    [UIView animateWithDuration:0.6f delay:0.1f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.launchView.alpha = 0.0f;
        self.launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5f, 1.5f, 1.0f);
    } completion:^(BOOL finished) {
        [self.launchView removeFromSuperview];
        [self removeTimer];
    }];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Private
- (void)textChange {
    int num =  [self.jump.titleLabel.text intValue];
    if (num >= 1){
        num -- ;
        [self.jump setTitle:[NSString stringWithFormat:@"%d\t\t跳过广告",num] forState:UIControlStateNormal];
    }else {
        [self removeTimer];
    }
}

static const char launchViewKey ;
- (void)setLaunchView:(UIView *)launchView {
    objc_setAssociatedObject(self, &launchViewKey, launchView, OBJC_ASSOCIATION_RETAIN);
}

static const char jumpKey ;
- (void)setJump:(UIButton *)jump {
    objc_setAssociatedObject(self, &jumpKey, jump, OBJC_ASSOCIATION_RETAIN);
}

static const char timerKey ;

- (void)setTimer:(NSTimer *)timer {
    objc_setAssociatedObject(self, &timerKey, timer, OBJC_ASSOCIATION_RETAIN);
}


- (UIView *)launchView {
    return objc_getAssociatedObject(self , &launchViewKey);
}

- (UIButton *)jump {
    return objc_getAssociatedObject(self , &jumpKey);
}

- (NSTimer *)timer {
    return objc_getAssociatedObject(self, &timerKey);
}




@end
