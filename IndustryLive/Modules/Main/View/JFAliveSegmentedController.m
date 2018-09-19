//
//  JFAliveSegmentedController.m
//  IndustryLive
//
//  Created by ikrulala on 2018/1/22.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import "JFAliveSegmentedController.h"
#import <Masonry.h>

@interface JFAliveSegmentedController()
@property (nonatomic,strong)UIButton *leftButton;
@property (nonatomic,strong)UIButton *rightButton;
@property (nonatomic,copy)UIView *lineView;
@end

@implementation JFAliveSegmentedController

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addContentViews];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addContentViews];
    }
    return self;
}

- (void)addContentViews {
    UIView *baseView = [[UIView alloc]init];
    baseView.layer.cornerRadius = 4.f;
    baseView.layer.masksToBounds = YES;
    baseView.layer.borderColor = [UIColor colorWithRed:221.f/255.f green:221.f/255.f blue:221.f/255.f alpha:1].CGColor;
    baseView.layer.borderWidth = 0.5f;
    [self addSubview:baseView];
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16).priorityHigh();
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(48);
    }];
    
    self.leftButton = [self subButtonsWithTitle:@"频道直播"];
    self.rightButton = [self subButtonsWithTitle:@"推流直播"];
    self.leftButton.selected = YES;
    self.leftButton.enabled = NO;
    [baseView addSubview:self.leftButton];
    [baseView addSubview:self.rightButton];
    [baseView addSubview:self.lineView];
    
    UIView *segmentView = [[UIView alloc]init];
    segmentView.backgroundColor = [UIColor colorWithRed:221.f/255.f green:221.f/255.f blue:221.f/255.f alpha:1];
    [baseView addSubview:segmentView];
    
    [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.bottom.mas_equalTo(-14);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(0.5);
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(segmentView.mas_left).priorityMedium();
        make.left.top.bottom.mas_equalTo(0);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(segmentView.mas_right).priorityMedium();
        make.top.right.bottom.mas_equalTo(0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.leftButton);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(3);
        make.bottom.mas_equalTo(0);
    }];
}


- (void)switchLiveButton:(UIButton*)sender {
    if (self.leftButton == sender) {
        self.leftButton.enabled = NO;
        self.rightButton.enabled = YES;
        self.leftButton.selected = YES;
        self.rightButton.selected = NO;
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.leftButton);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(3);
            make.bottom.mas_equalTo(0);
        }];
    }else {
        self.leftButton.enabled = YES;
        self.rightButton.enabled = NO;
        self.leftButton.selected = NO;
        self.rightButton.selected = YES;
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.rightButton);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(3);
            make.bottom.mas_equalTo(0);
        }];
    }
    self.switchBlock(sender.titleLabel.text);
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}


- (UIButton *)subButtonsWithTitle:(NSString*)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:53.f/255.f green:53.f/255.f blue:53.f/255.f alpha:1] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:237.f/255.f green:55.f/255.f blue:61.f/255.f alpha:1] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(switchLiveButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIView*)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithRed:237.f/255.f green:55.f/255.f blue:61.f/255.f alpha:1];
    }
    return _lineView;
}

@end
