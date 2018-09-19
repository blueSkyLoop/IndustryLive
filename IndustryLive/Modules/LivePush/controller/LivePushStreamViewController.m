//
//  LivePushStreamViewController.m
//  IndustryLive
//
//  Created by lgh on 2018/1/18.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import "LivePushStreamViewController.h"
#import <AlivcLivePusher/AlivcLivePusher.h>

#import "LKAuthorizationModel.h"

#import "LivePStreamTopView.h"

#import "LivePushViewModel.h"

//#define IPHONEX (MScreenW == 375.f && MScreenH == 812.f)

@interface LivePushStreamViewController ()<AlivcLivePusherErrorDelegate,AlivcLivePusherInfoDelegate,AlivcLivePusherNetworkDelegate>

// 推流地址
@property (nonatomic, strong) NSString *pushURL;
// 推流配置
@property (nonatomic, strong) AlivcLivePushConfig *pushConfig;

// 推流器
@property (nonatomic, strong) AlivcLivePusher *livePusher;
@property (nonatomic,strong)LivePStreamTopView *settingView;
@property (nonatomic,strong)UIView *previewView;
@property (nonatomic,strong)LivePushViewModel *viewModel;

@end

@implementation LivePushStreamViewController

- (id)initWithPushConfig:(AlivcLivePushConfig *)config pushUrl:(NSString *)pushUrl{
    self = [super init];
    if(self){
        self.pushURL = pushUrl;
        self.pushConfig = config;
    }
    return self;
}

- (void)dealloc{
    NSLog(@"推流控制器释放");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.navigationController){
        [self.navigationController setNavigationBarHidden:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(self.navigationController){
        [self.navigationController setNavigationBarHidden:NO];
    }
}

- (void)live_setUpUI{
    [self.view addSubview:self.previewView];
    [self.view addSubview:self.settingView];
//    [_previewView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    [_settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
- (void)live_bindViewModel{
    
    //设置屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    
    [self uiEventHandle];
    
    [self.settingView updateDefaultValueWithConfig:self.pushConfig];
    self.viewModel.cameraType = self.pushConfig.cameraType;
    
    [self addBackgroundNotifications];
    @weakify(self);
    //请求权限
    [LKAuthorizationModel cameraAuthorizationShowUnabelMessage:NO comple:^(BOOL isEnable, AVAuthorizationStatus status) {
        if(isEnable){
            @strongify(self);
            [self setupPusher];
            [self startPreview];
        }
    }];
    [LKAuthorizationModel audiAuthorizationShowUnabelMessage:NO comple:nil];
    
    RAC(self.settingView.timeLabel,text) = RACObserve(self.viewModel, currentTimeText);
    
    [self.viewModel.requestSuccessSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if(!self.livePusher){
            [self setupPusher];
            [self startPreview];
        }
        [self startPush];
    }];
    [self.viewModel.requestFailureSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"该频道正在直播，您无法发起直播" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
}
#pragma makr - UI事件处理
- (void)uiEventHandle{
    @weakify(self);
    self.settingView.backBlock = ^{
        @strongify(self);
        [self.viewModel destroyTime];
        [self destoryPusher];
        //设置屏幕常亮恢复
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    //开播或结束
    self.settingView.liveBlock = ^(BOOL isStart) {
        @strongify(self);
        if(isStart && [self isCanStartPush]){
            [self.viewModel checkPushUrlWithUrlString:self.pushURL];
        }else{
            if([self isCanStartPush]){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定结束直播？" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [self stopPush];
                    [self.viewModel destroyTime];
                    self.viewModel.currentTimeText = @"00:00:00";
                }];
                [alert addAction:cancelAction];
                [alert addAction:sureAction];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
        }
    };
    
    //配置修改 美颜  麦克风  闪光灯 摄像头切换
    self.settingView.configBlock = ^(LiveConfitType type) {
        @strongify(self);
        [self configPusherWithType:type];
    };
    
    //码率修改
    self.settingView.rateBlock = ^(int rate) {
        @strongify(self);
        if(![LKAuthorizationModel cameraAuthorizationShowUnabelMessage:NO] || [LKAuthorizationModel audiAuthorizationShowUnabelMessage:NO]){
            return;
        }
        int success = [self.livePusher setTargetVideoBitrate:rate];
        NSLog(@"%@",success == 0?@"设置码率成功":@"设置码率失败");
       
    };
}

- (void)configPusherWithType:(LiveConfitType)type{
    
    if(!self.livePusher) return;
    
    switch (type) {
        case LiveConfitTypeBeauty:
        {
            if(![LKAuthorizationModel cameraAuthorizationShowUnabelMessage:NO]){
                return;
            }
            self.settingView.beautyBtn.selected = !self.settingView.beautyBtn.selected;
            [self.livePusher setBeautyOn:self.settingView.beautyBtn.selected];
        }
            break;
        case LiveConfitTypeMic:
        {
            if(![LKAuthorizationModel audiAuthorizationShowUnabelMessage:NO]){
                return;
            }
            self.settingView.micBtn.selected = !self.settingView.micBtn.selected;
            [self.livePusher setMute:self.settingView.micBtn.selected];
        }
            break;
        case LiveConfitTypeFlash:
        {
            if(![LKAuthorizationModel cameraAuthorizationShowUnabelMessage:NO]){
                return;
            }
            //如果是前置摄像头，不可开闪光灯
            if(self.viewModel.cameraType == AlivcLivePushCameraTypeFront){
                return;
            }
            self.settingView.flashBtn.selected = !self.settingView.flashBtn.selected;
            [self.livePusher setFlash:self.settingView.flashBtn.selected];
        }
            break;
        case LiveConfitTypeCamera:
        {
            if(![LKAuthorizationModel cameraAuthorizationShowUnabelMessage:NO]){
                return;
            }
            if(![self.livePusher switchCamera]){
                
                self.viewModel.cameraType = self.viewModel.cameraType == AlivcLivePushCameraTypeBack?AlivcLivePushCameraTypeFront:AlivcLivePushCameraTypeBack;
            }
            //如果是前置摄像头，不可开闪光灯
            if(self.viewModel.cameraType == AlivcLivePushCameraTypeFront){
                [self.livePusher setFlash:false];
                self.settingView.flashBtn.selected = NO;
            }
        }
            break;
            
        default:
            break;
    }
}
//判断权限
- (BOOL)isCanStartPush{
    if([LKAuthorizationModel cameraAuthorizationShowUnabelMessage:YES] && [LKAuthorizationModel audiAuthorizationShowUnabelMessage:YES]){
        return YES;
    }
    return NO;
}
//判断网络
- (BOOL)netEnable{
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if(status == AFNetworkReachabilityStatusNotReachable){
        return NO;
    }
    return YES;
}

#pragma mark - SDK

/**
 创建推流
 */
- (int)setupPusher {
    
    self.livePusher = [[AlivcLivePusher alloc] initWithConfig:self.pushConfig];
    [self.livePusher setLogLevel:(AlivcLivePushLogLevelFatal)];
    if (!self.livePusher) {
        return -1;
    }
    [self.livePusher setInfoDelegate:self];
    [self.livePusher setErrorDelegate:self];
    [self.livePusher setNetworkDelegate:self];
    return 0;
}


/**
 销毁推流
 */
- (void)destoryPusher {
    
    if (self.livePusher) {
        [self.livePusher destory];
    }
    
    self.livePusher = nil;
    //UI恢复初始状态
    [self.settingView updateDefaultValueWithConfig:self.pushConfig];
    self.settingView.liveBtn.selected = NO;
    self.settingView.liveBtn.enabled = YES;
    self.viewModel.cameraType = self.pushConfig.cameraType;
    [self.viewModel destroyTime];
    self.viewModel.currentTimeText = @"00:00:00";
    
}


/**
 开始预览
 */
- (int)startPreview {
    
    if (!self.livePusher) {
        return -1;
    }
    
    int ret = 0;
    
    // 使用同步接口
    ret = [self.livePusher startPreview:self.previewView];
    
    return ret;
}



/**
 开始推流
 */
- (int)startPush {
    
    if (!self.livePusher) {
        return -1;
    }
    
    int ret = 0;
    
    // 使用同步接口
    ret = [self.livePusher startPushWithURL:self.pushURL];
    self.settingView.liveBtn.enabled = NO;
    
    return ret;
}


/**
 停止推流
 */
- (int)stopPush {
    
    if (!self.livePusher) {
        return -1;
    }
    
    int ret = [self.livePusher stopPush];
    if(ret == 0){
        self.settingView.liveBtn.selected = NO;
        self.settingView.liveBtn.enabled = YES;
    }
    return ret;
}

#pragma mark - AlivcLivePusherErrorDelegate
/**
 系统错误回调
 
 @param pusher 推流AlivcLivePusher
 @param error error
 */
- (void)onSystemError:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error{
    //系统级错误，需要退出直播
    dispatch_async(dispatch_get_main_queue(), ^{
        [self destoryPusher];
    });
    
}

/**
 SDK错误回调
 
 @param pusher 推流AlivcLivePusher
 @param error error
 */
- (void)onSDKError:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error{
    //当出现SDK错误时，有两种处理方式，选择其一即可：1.销毁当前直播，重新创建 2.调用 restartPush/restartPushAsync 重启AlivcLivePusher
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.livePusher restartPushAsync];
    });
}



#pragma mark - AlivcLivePusherNetworkDelegate

/**
 网络差回调
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onNetworkPoor:(AlivcLivePusher *)pusher{
    NSLog(@"网络差");
}


/**
 推流链接失败
 
 @param pusher 推流AlivcLivePusher
 @param error error
 */
- (void)onConnectFail:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error{
    self.viewModel.isConectPush = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self netEnable]){
            [self.livePusher restartPushAsync];
        }
        
    });
}


/**
 网络恢复
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onConnectRecovery:(AlivcLivePusher *)pusher{
    
}


/**
 重连开始回调
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onReconnectStart:(AlivcLivePusher *)pusher{
    
}


/**
 重连成功回调
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onReconnectSuccess:(AlivcLivePusher *)pusher{
    self.viewModel.isConectPush = YES;
}


/**
 重连失败回调
 
 @param pusher 推流AlivcLivePusher
 @param error error
 */
- (void)onReconnectError:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self netEnable]){
            [self.livePusher restartPushAsync];
        }
        
    });
}


/**
 发送数据超时
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onSendDataTimeout:(AlivcLivePusher *)pusher{
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self netEnable]){
            [self.livePusher restartPushAsync];
        }
        
    });
}


#pragma mark - AlivcLivePusherInfoDelegate

- (void)onPreviewStarted:(AlivcLivePusher *)pusher{
    
}



/**
 停止预览回调
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onPreviewStoped:(AlivcLivePusher *)pusher{
    
}


/**
 渲染第一帧回调
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onFirstFramePreviewed:(AlivcLivePusher *)pusher{
    self.viewModel.isPrever = YES;
}


/**
 推流开始回调
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onPushStarted:(AlivcLivePusher *)pusher{
    //弹窗显示推流成功
    NSLog(@"推流链接成功");
    self.viewModel.isConectPush = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.settingView.liveBtn.selected = YES;
        self.settingView.liveBtn.enabled = YES;
        [self.viewModel startTime];
        [MBManager showMessage:@"推流链接成功"];
        
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.settingView updateUIHidden:YES];
    });

}


/**
 推流暂停回调
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onPushPauesed:(AlivcLivePusher *)pusher{
    
}


/**
 推流恢复回调
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onPushResumed:(AlivcLivePusher *)pusher{
    
}


/**
 重新推流回调
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onPushRestart:(AlivcLivePusher *)pusher{
    
}


/**
 推流停止回调
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onPushStoped:(AlivcLivePusher *)pusher{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.settingView.liveBtn.selected = NO;
        self.settingView.liveBtn.enabled = YES;
    });
}


#pragma mark - 退后台停止推流的实现方案

- (void)addBackgroundNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
}


- (void)applicationWillResignActive:(NSNotification *)notification {
    
    if (!self.livePusher) {
        return;
    }
    
   
    if ([self.livePusher isPushing]) {
         // 如果退后台不需要继续推流，则停止推流
//        [self.livePusher stopPush];
        //静音
        [self.livePusher setMute:true];
        self.viewModel.pushingFlag = YES;
        self.settingView.micBtn.selected = YES;
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    
    if (!self.livePusher) {
        return;
    }
    //如果之前是已经开播了的情况
    if(self.viewModel.pushingFlag){
        // 当前是推流模式，恢复推流
//        [self.livePusher startPushWithURLAsync:self.pushURL];
        //恢复声音
        [self.livePusher setMute:false];
        self.settingView.micBtn.selected = NO;
    }
    self.viewModel.pushingFlag = NO;
    
}




#pragma mark - lazyload
- (LivePStreamTopView *)settingView{
    if(!_settingView){
        _settingView = [LivePStreamTopView loadFromXib];
        
    }
    return _settingView;
}

- (UIView *)previewView{
    if(!_previewView){
        _previewView = [[UIView alloc] initWithFrame:[self getFullScreenFrame]];
        _previewView.backgroundColor = MRGBColor(53, 53, 53);
    }
    return _previewView;
}

- (LivePushViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [LivePushViewModel new];
    }
    return _viewModel;
}

- (CGRect)getFullScreenFrame {
    
    CGRect frame = self.view.bounds;
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
//    if (IPHONEX) {
//        // iPhone X UI适配
//        frame = CGRectMake(88, 0, MAX(width, height) - 88, MIN(width, height));
//    }
    
    if(self.pushConfig.orientation == AlivcLivePushOrientationPortrait){
        frame.size = CGSizeMake(MIN(width, height) , MAX(width, height));
    }else{
        frame.size = CGSizeMake(MAX(width, height) , MIN(width, height));
    }
    return frame;
}

- (BOOL)shouldAutorotate{
    return NO;
}

//屏幕旋转
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    if(self.pushConfig.orientation == AlivcLivePushOrientationLandscapeRight){
        return UIInterfaceOrientationMaskLandscapeRight;
    }else if(self.pushConfig.orientation == AlivcLivePushOrientationLandscapeLeft){
        return UIInterfaceOrientationMaskLandscapeLeft;
    }else if(self.pushConfig.orientation == AlivcLivePushOrientationPortrait){
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskLandscapeRight;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if(self.pushConfig.orientation == AlivcLivePushOrientationLandscapeRight){
        return UIInterfaceOrientationLandscapeRight;
    }else if(self.pushConfig.orientation == AlivcLivePushOrientationLandscapeLeft){
        return UIInterfaceOrientationLandscapeLeft;
    }else if(self.pushConfig.orientation == AlivcLivePushOrientationPortrait){
        return UIInterfaceOrientationPortrait;
    }
    return UIInterfaceOrientationLandscapeRight;
}

@end
