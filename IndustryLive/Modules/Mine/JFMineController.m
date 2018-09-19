//
//  JFMineController.m
//  IndustryLive
//
//  Created by ikrulala on 2018/1/23.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "JFMineController.h"
#import "MHMacros.h"

#import "JFAlertView.h"
#import "JFSheetController.h"
#import "LiveUserInforModel.h"

#import "AppDelegate+EnterUI.h"
#import "JFMineModel.h"
#import "JFMineViewModel.h"

#import <Masonry.h>
#import "UIImageView+WebCache.h"

@interface JFMineController ()
@property (weak, nonatomic) IBOutlet UIView *userBGView;
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIView *userRoleView;
@property (weak, nonatomic) IBOutlet UIScrollView *userJobView;
@property (weak, nonatomic) IBOutlet UIButton *userLoginButton;

@property (nonatomic,strong)NSTimer *timer;

@property (strong,nonatomic) JFMineViewModel *viewModel;
@property (strong,nonatomic) JFMineModel *model;
@property (assign,nonatomic) NSInteger flag;

@end

#define kRedColor [UIColor colorWithRed:237.f/255.f green:55.f/255.f blue:61.f/255.f alpha:1]

@implementation JFMineController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureProperty];
    self.title = @"我的";
    
    @weakify(self);
    [self.viewModel.requestSuccessSubject subscribeNext:^(JFMineModel *model) {
        @strongify(self);
        self.model = model;
        [self.userImgView sd_setImageWithURL:[NSURL URLWithString:model.o_img_head_photo]];
        self.userImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.userNameLabel.text = model.real_name;
        [self layoutUserJobLabel:model.user_role_list];
        [self layoutRolesLabel:model.company_type_name isMember:[model.is_qjl_member boolValue]];
    }];
    [self.viewModel userInfoRequest];
    
    [self.viewModel.signOutSubject subscribeNext:^(id  _Nullable x) {
        [LiveUserInforModel clearUserInfor];
        [[AppDelegate sharedAppDelegate] enterLogin];
    }];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.model && self.model.user_role_list.count >= 2){
        if(self.timer){
            [self.timer invalidate];
            self.timer = nil;
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(shoot) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(self.timer){
        [self.timer invalidate];
    }
}

- (void)configureProperty {
    self.userBGView.backgroundColor = kRedColor;
    self.userImgView.layer.cornerRadius = 40;
    self.userImgView.clipsToBounds = YES;
    
    self.userLoginButton.layer.cornerRadius = 5.f;
    self.userLoginButton.layer.borderColor = MColorToRGB(0XED373D).CGColor;
    self.userLoginButton.layer.borderWidth = 1.f;
    self.userLoginButton.layer.masksToBounds = YES;
}

//职务
- (void)layoutUserJobLabel:(NSArray *)jobs {
    NSMutableArray *mutableJobs = [NSMutableArray arrayWithArray:jobs];
    [mutableJobs addObject:jobs[0]];
    for (int i = 0; i < mutableJobs.count; i ++) {
        UILabel *label = [[UILabel alloc]init];
        label.text = mutableJobs[i];
        label.frame = CGRectMake(0, self.userJobView.frame.size.height*i, MScreenW - 32, self.userJobView.frame.size.height);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        [self.userJobView addSubview:label];
    }
    [self.userJobView setContentSize:CGSizeMake(MScreenW - 32, self.userJobView.frame.size.height * mutableJobs.count)];
    if (jobs.count >= 2) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(shoot) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)shoot {
    self.flag += 1;
    [self.userJobView setContentOffset:CGPointMake(0, self.userJobView.frame.size.height*self.flag) animated:YES];
    if ( self.flag == self.model.user_role_list.count) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.userJobView setContentOffset:CGPointMake(0,0) animated:NO];
            self.flag = 0;
        });
    }
}

//标签
- (void)layoutRolesLabel:(NSString *)role isMember:(BOOL)isMember {
    NSMutableArray *roles = [NSMutableArray array];
    if (role.length > 0 && ![role isEqualToString:@""]) {
        [roles addObject:role];
    }
    UIColor *textColor = [UIColor whiteColor];
    if (isMember) {
        [roles insertObject:@"全经联会员" atIndex:0];
        textColor = MColorToRGB(0XFFBD00);
    }
    UILabel *cacheLabel;
    __block MASConstraint *lastConstraint;
    for (int i = 0; i < roles.count; i ++) {
        NSString *title = roles[i];
        if (i == 0) {
            UILabel *label = [self rolesLabel:title highColor:isMember?MColorToRGB(0XFFBD00):[UIColor whiteColor]];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.mas_equalTo(0);
                make.height.mas_equalTo(21);
                make.width.mas_equalTo(title.length * 14);
                lastConstraint = make.right.mas_equalTo(0);
            }];
            cacheLabel = label;
        }else {
            UILabel *label = [self rolesLabel:title highColor:[UIColor whiteColor]];
            [lastConstraint uninstall];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cacheLabel.mas_right).mas_offset(8);
                make.top.mas_equalTo(0);
                make.height.mas_equalTo(21);
                make.width.mas_equalTo(title.length * 14 + 6);
                lastConstraint = make.right.mas_equalTo(0);
            }];
            cacheLabel = label;
        }
    }
}

- (UILabel*)rolesLabel:(NSString*)text highColor:(UIColor*)color {
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = color;
    label.layer.borderWidth = 1;
    label.layer.borderColor = color.CGColor;
    label.layer.cornerRadius = 2;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [self.userRoleView addSubview:label];
    return label;
}

- (IBAction)backEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)signOutEvent:(id)sender {
    JFAlertView *alertView = [[JFAlertView alloc]init];
    alertView.confirmHandle = ^{ //退出登录
        [self.viewModel signOutRequest];
    };
    JFSheetController *controller = [JFSheetController alertControllerWithSheetView:alertView];
    [self presentViewController:controller animated:YES completion:nil];
}


-  (JFMineViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [JFMineViewModel new];
    }
    return _viewModel;
}


@end
