//
//  JFLoginController.m
//  IndustryLive
//
//  Created by Lol on 2018/1/16.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import "JFLoginController.h"
#import "JFIntroduceLiveController.h"
#import "JFNavigationController.h"
#import "LivePushStreamViewController.h"

#import "UIView+Radius.h"
#import "NSString+ValidatePhoneNumber.h"
#import "NSObject+isNull.h"
#import "AppDelegate+EnterUI.h"
#import "UIViewController+Launch.h"

#import "MHMacros.h"
#import "MHWeakStrongDefine.h"
#import <ReactiveObjC.h>

#import "LKAuthorizationModel.h"
#import "LiveLoginViewModel.h"
#import "LiveUserInforModel.h"
#import "JFMainController.h"
#import "MHChooseUrlController.h"
@interface JFLoginController ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *acTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UILabel *errrorLB;
@property (weak, nonatomic) IBOutlet UIButton *pushLiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *howBtn;

@property (nonatomic,strong)LiveLoginViewModel *viewModel;


@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@end

@implementation JFLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  setConfig];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self jf_Lauch];
}

- (void)setConfig {
    [self.loginBtn jf_viewRadius:0.02];
    [self.loginBtn setBackgroundColor:MColorTheme];
    
    NSInteger phone_length = 11;
    NSInteger psw_lengthMax = 16 ;
    NSInteger psw_lengthMin = 4 ;
    @weakify(self);
    // 登录按钮 颜色控制
    NSArray *sigals = @[[self.acTF rac_textSignal],[self.pswTF rac_textSignal]];
    RAC(self.loginBtn , alpha) = [RACSignal combineLatest:sigals reduce:^id(NSString *acText ,NSString *pswText) {
        if (acText.length >= phone_length && (self.pswTF.text.length > psw_lengthMin && self.pswTF.text.length <= psw_lengthMax)) {
            return @1.0;
        }else {
            return @0.4;
        }
    }];
    
    [[self.acTF rac_signalForControlEvents:UIControlEventEditingChanged | UIControlEventEditingDidBegin] subscribeNext:^(__kindof UITextField * _Nullable x) {
        @strongify(self);
        if (x.text.length > phone_length) {  // 最大长度为 11
           x.text = [x.text substringWithRange:NSMakeRange(0, phone_length)];
        }
        [self changeStatusWithTextField:x isShowErrorView:NO showText:@""];
    }];
    
    [[self.pswTF rac_signalForControlEvents:UIControlEventEditingChanged | UIControlEventEditingDidBegin] subscribeNext:^(__kindof UITextField * _Nullable x) {
        @strongify(self);
        if (x.text.length > psw_lengthMax) {
            x.text = [x.text substringWithRange:NSMakeRange(0, psw_lengthMax)];
        }
        [self changeStatusWithTextField:x isShowErrorView:NO showText:@""];
    }];
    
    RAC(self.viewModel,username) = self.acTF.rac_textSignal;
    RAC(self.viewModel,password) = self.pswTF.rac_textSignal;
    
    [self.viewModel.requestSuccessSubject subscribeNext:^(id  _Nullable x) {
        [[AppDelegate sharedAppDelegate] enterMain];
    }];
    [self.viewModel.requestFailureSubject subscribeNext:^(id x) {
        @strongify(self);
        RACTupleUnpack(NSNumber *code,NSString *message) = x;
        NSInteger codeNum = code.integerValue;
        if(codeNum == 2002){//密码错误
            [self changeStatusWithTextField:self.pswTF isShowErrorView:YES showText:@"密码错误"];
        }else if(codeNum == 2003){//账号被禁用
            [self changeStatusWithTextField:self.acTF isShowErrorView:YES showText:@"该账号已被禁用"];
        }else if(codeNum == 2004){//未开通
            [self changeStatusWithTextField:self.acTF isShowErrorView:YES showText:@"该账号未开通直播"];
        }else{
            [MBManager showMessage:message bottomOffset:80];
        }
    }];
#if JF_Dev
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] init];
    [[tap.rac_gestureSignal throttle:.2] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [self presentViewController:[MHChooseUrlController new] animated:YES completion:nil];
    }];
    [self.logoImage addGestureRecognizer:tap];
#endif
    //请求权限
    [LKAuthorizationModel cameraAuthorizationShowUnabelMessage:NO comple:nil];
    [LKAuthorizationModel audiAuthorizationShowUnabelMessage:NO comple:nil];
}

// 改变textField 字体颜色、tip 文本状态
- (void)changeStatusWithTextField:(UITextField *)tf isShowErrorView:(BOOL)isShow showText:(NSString *)showText{
    isShow ?  [tf setTextColor:MColorTheme] : [tf setTextColor:[UIColor blackColor]] ;
    self.errrorLB.text = showText ;
    self.errorView.hidden = !isShow ;
}


- (IBAction)loginAction:(UIButton *)sender {
   
    [self textResignFirstResponder];
    
    if ([self.acTF.text isNull] && [self.pswTF.text isNull]){
        [self changeStatusWithTextField:self.acTF isShowErrorView:YES showText:@"请填写账号密码"];
    }else if ([self.acTF.text isNull]){
        [self changeStatusWithTextField:self.acTF isShowErrorView:YES showText:@"请填写会员账号"];
    }else if (![NSString mh_isMobileNumber:self.acTF.text]) {
        [self changeStatusWithTextField:self.acTF isShowErrorView:YES showText:@"请填写正确的账号"];
    }else if ([self.pswTF.text isNull]){
        [self changeStatusWithTextField:self.pswTF isShowErrorView:YES showText:@"密码不能为空"];
    }else if (self.pswTF.text.length < 4 || self.pswTF.text.length >16) {
        [self changeStatusWithTextField:self.pswTF isShowErrorView:YES showText:@"密码格式有误"];
    }else {// 请求数据
        [self.viewModel loginRequest];
    }

}

// 推流直播
- (IBAction)pushAction:(id)sender {
    [self textResignFirstResponder];
    
    JFMainController *controller = [[JFMainController alloc]init];
    controller.visitorLogin = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

// 如何开始直播
- (IBAction)howPushLiveAciton:(id)sender {
    [self textResignFirstResponder];
    JFIntroduceLiveController *introduceVC = [JFIntroduceLiveController new];
    [self.navigationController pushViewController:introduceVC animated:YES];
    
}

#pragma mark - Private
- (void)textResignFirstResponder {
    [self.acTF resignFirstResponder];
    [self.pswTF resignFirstResponder];
}

#pragma mark - lazyload
-  (LiveLoginViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [LiveLoginViewModel new];
    }
    return _viewModel;
}

@end
