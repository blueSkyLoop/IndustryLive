//
//  JFAlertView.m
//  IndustryLive
//
//  Created by ikrulala on 2018/1/24.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "JFAlertView.h"
#import "JFSheetController.h"
#import <Masonry.h>

@interface JFAlertView()
@property (nonatomic,strong) UIView *alertView;
@property (nonatomic,weak) UIButton *leftButton;
@property (nonatomic,weak) UIButton *rightButton;
@property (nonatomic,weak) UILabel *titleLabel;
@end

@implementation JFAlertView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self addContentViews];
    }
    return self;
}

- (void)addContentViews {
    UIView *alertView = [[UIView alloc] init];
    alertView.layer.cornerRadius = 8;
    alertView.clipsToBounds = YES;
    alertView.userInteractionEnabled = YES;
    alertView.backgroundColor = [UIColor colorWithRed:211/255.0 green:220/255.0 blue:230/255.0 alpha:1.0];
    [self addSubview:alertView];
    _alertView = alertView;
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"确定退出登录？";
    title.font = [UIFont systemFontOfSize:18];
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor whiteColor];
    title.textColor = [UIColor colorWithRed:53.f/255.f green:53.f/255.f blue:53.f/255.f alpha:1];
    [alertView addSubview:title];
    _titleLabel = title;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:18];
    leftButton.backgroundColor = [UIColor whiteColor];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(actionCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:leftButton];
    _leftButton = leftButton;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:18];
    rightButton.backgroundColor = [UIColor whiteColor];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithRed:237.f/255.f green:55.f/255.f blue:61.f/255.f alpha:1] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(actionConfirmClicked:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:rightButton];
    _rightButton = rightButton;
}

- (void)didMoveToSuperview{
    if (self.superview) {
        [self layoutContentViews];
    }
}

- (void)layoutContentViews {

    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.superview);
        make.left.mas_equalTo(47);
        make.right.mas_equalTo(-47);
        make.height.mas_equalTo(145.5);
    }];
    
    [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(95);
    }];
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(_leftButton.mas_right).mas_offset(0.5);
        make.width.mas_equalTo(_leftButton);
    }];
}

- (void)actionCancelClicked:(UIButton*)sender {
    [self hideView];
}

- (void)actionConfirmClicked:(UIButton *)sender {
    if (self.confirmHandle) {
        self.confirmHandle();
    }
    [self hideView];
}

@end
