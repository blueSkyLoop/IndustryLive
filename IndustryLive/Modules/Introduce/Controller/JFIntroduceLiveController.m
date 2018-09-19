//
//  JFIntroduceLive.m
//  IndustryLive
//
//  Created by Lol on 2018/1/19.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import "JFIntroduceLiveController.h"
#import "JFIntroduceScrollView.h"

#import "MHMacros.h"
#import <Masonry.h>
@interface JFIntroduceLiveController ()
@property (nonatomic, strong)JFIntroduceScrollView * sv ;
@property (nonatomic, strong) UIButton   *backBtn;

@end

@implementation JFIntroduceLiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"如何开通直播";
    [self.view addSubview:self.sv];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];

    [_sv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Event
- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Getter
- (JFIntroduceScrollView *)sv {
    if (!_sv) {
        _sv = [[JFIntroduceScrollView alloc] initWithFrame:CGRectMake(0, 0, MScreenW, MScreenH)];
        _sv.bounces = YES;
    }
    return _sv;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"navi_back_white"] forState:UIControlStateNormal];
        [_backBtn setContentEdgeInsets:UIEdgeInsetsMake(0, -16, 0, 0)];
        [_backBtn sizeToFit];
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }return _backBtn;
}
@end
