//
//  MHVoInviteJoinDetailScrollView.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/11.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "JFIntroduceScrollView.h"

#import "MHMacros.h"
#import <Masonry.h>

@interface JFIntroduceScrollView ()
@property (nonatomic, strong) UIImageView *bgimv;

@end


@implementation JFIntroduceScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = NO;
//        [self setContentSize:CGSizeMake(MScreenW, self.bgimv.frame.size.height)];
        [self addSubview:self.bgimv];
        [_bgimv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - Getter
- (UIImageView *)bgimv {
    if (!_bgimv) {
        _bgimv = [[UIImageView alloc] init];
        _bgimv.image = [UIImage imageNamed:@"HowPushLive_scrollImage"];
        _bgimv.frame = CGRectMake(0, 0, MScreenW, _bgimv.image.size.height);
        _bgimv.userInteractionEnabled = YES;
    }
    return _bgimv;
}


@end
