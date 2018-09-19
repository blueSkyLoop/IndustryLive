//
//  ViewController.m
//  IndustryLive
//
//  Created by Lol on 2018/1/16.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import "JFMainController.h"
#import "LivePushStreamViewController.h"
#import "JFMineController.h"

#import "JFAlivcParamTableViewCell.h"
#import "JFAliveSegmentedController.h"
#import "JFSheetKIt.h"
#import "JFPickerView.h"

#import "JFAlivcParamModel.h"
#import "JFAlivcViewModel.h"
#import "JFAlivcModel.h"

#import <Masonry.h>
#import "MHMacros.h"
#import <AlivcLivePusher/AlivcLivePusher.h>

#define kRedColor [UIColor colorWithRed:237.f/255.f green:55.f/255.f blue:61.f/255.f alpha:1]

@interface JFMainController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) AlivcLivePushConfig *pushConfig;
@property (nonatomic,copy) NSString *publisherURL; //频道推送地址
@property (nonatomic,copy) NSString *writeURL;     //手写推送地址
@property (nonatomic,copy) NSString *channelTitle;
@property (nonatomic,strong) JFAlivcViewModel *viewModel;
@property (nonatomic,strong) NSArray<JFAlivcModel*> *channelList; //频道列表
@property (nonatomic,assign) BOOL isCellUpdate; //添加bool值，判断是否是点击频道刷新的数据。
@end

@implementation JFMainController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (BOOL)shouldAutorotate {
    return NO;
}
//屏幕旋转
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;
    
    [self setupParamData];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self addHeaderFooterView];
}


- (void)userInfoController {
    JFMineController *controller = [[JFMineController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addHeaderFooterView {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 128)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *publisherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    publisherButton.backgroundColor = kRedColor;
    publisherButton.layer.cornerRadius = 5;
    publisherButton.layer.masksToBounds = YES;
    publisherButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [publisherButton setTitle:@"确 定" forState:UIControlStateNormal];
    [publisherButton addTarget:self action:@selector(publisherButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:publisherButton];
    [publisherButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24).priorityLow();
        make.height.mas_equalTo(56);
    }];
    self.tableView.tableFooterView = footerView;
    
    if (_visitorLogin) {//游客登录，不需要直播模式、用户信息
        self.title = @"推流直播";
        [self.dataArray removeObjectAtIndex:0];
        [self.dataArray replaceObjectAtIndex:0 withObject:[self writeAddressModel]];
        [self.tableView reloadData];
        return;
    }
    
    self.title = @"直播模式";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_user_info"] style:UIBarButtonItemStylePlain target:self action:@selector(userInfoController)];
    
    JFAliveSegmentedController *header = [[JFAliveSegmentedController alloc]initWithFrame:CGRectMake(0, 0, 0, 80)];
    header.switchBlock = ^(NSString *value) {
        self.title = value;
        if ([value isEqualToString:@"频道直播"]) {
            self.title = @"直播模式";
            [self.dataArray insertObject:[self channelModel] atIndex:0];
            [self.dataArray replaceObjectAtIndex:1 withObject:[self addressModel]];
        }else {
            [self.dataArray removeObjectAtIndex:0];
            [self.dataArray replaceObjectAtIndex:0 withObject:[self writeAddressModel]];
        }
        [self.tableView reloadData];
    };
    self.tableView.tableHeaderView = header;
    
    @weakify(self);
    [self.viewModel.requestSuccessSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.channelList = x;
        if(!self.isCellUpdate) {
            JFAlivcParamTableViewCell *channel_cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            self.channelTitle = self.channelList[0].live_title;
            self.publisherURL = self.channelList[0].url_push;
            [channel_cell updateDefaultValue:self.channelTitle];
            JFAlivcParamTableViewCell *url_cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [url_cell updateDefaultValue:self.channelList[0].url_push];
        }else {//判断是否是点击频道刷新的数据。弹出频道列表
            [self updateChannelInfoCell];
        }
    }];
    [self.viewModel channelListRequest];
}

- (void)setupParamData {
    self.channelTitle = @"";
    self.publisherURL = @"";
    self.channelList  = @[];
    
    self.pushConfig = [[AlivcLivePushConfig alloc]init];
     self.pushConfig.qualityMode = AlivcLivePushQualityModeCustom;
    self.pushConfig.beautyOn = NO; //需求默认美颜关
    self.pushConfig.cameraType = AlivcLivePushCameraTypeBack;//需求默认后置摄像头
    self.pushConfig.orientation = AlivcLivePushOrientationLandscapeRight;
    self.pushConfig.fps = AlivcLivePushFPS25;
    self.pushConfig.resolution = AlivcLivePushResolution480P;
    self.pushConfig.targetVideoBitrate = 800;
    
    JFAlivcParamModel *channelModel = [self channelModel];
    JFAlivcParamModel *addressModel = [self addressModel];
    
    JFAlivcParamModel *bitRatemodel = [[JFAlivcParamModel alloc]init];
    bitRatemodel.title = @"码率(kbps)";
    bitRatemodel.infoText = @"800";
    bitRatemodel.defaultValue = @"800";
    bitRatemodel.reuseId = JFAlivcParamModelReuseCellSlider;
    bitRatemodel.sliderBlock = ^(id value) {
        self.pushConfig.targetVideoBitrate = [value intValue];
    };
    
    JFAlivcParamModel *resolutionModel = [[JFAlivcParamModel alloc]init];
    resolutionModel.title = @"分辨率";
    resolutionModel.infoText = @"480p";
    resolutionModel.reuseId = JFAlivcParamModelReuseCellSegment;
    resolutionModel.switchButtonBlock = ^(int value) {
        self.pushConfig.resolution = value;
    };
    
    JFAlivcParamModel *frameModel = [[JFAlivcParamModel alloc]init];
    frameModel.title = @"帧率(fps)";
    frameModel.infoText = @"25";
    frameModel.buttonTag = 3019;
    frameModel.reuseId = JFAlivcParamModelReuseCellSheet;
    frameModel.fpsBlock = ^(id value) {
        [self updateFpsCell:value];
        self.pushConfig.fps = [value integerValue];
    };
    
    self.dataArray = [NSMutableArray arrayWithObjects:channelModel,addressModel,bitRatemodel,resolutionModel,frameModel, nil];
}

// 确定按钮 事件
- (void)publisherButtonAction:(UIButton *)sender {
    
    NSString *url = self.publisherURL;
    if ([self.title isEqualToString:@"推流直播"]) {
        url = self.writeURL;
    }
    
    if (!url) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入推流地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![url hasPrefix:@"rtmp:"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确格式的推流地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    LivePushStreamViewController *controller = [[LivePushStreamViewController alloc]initWithPushConfig:self.pushConfig pushUrl:url];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - Update Cell
- (void)updateChannelInfoCell {
    self.isCellUpdate = NO;
    if (self.channelList.count == 0) return;
    
    JFSheetView *sheetView = [[JFSheetView alloc]init];
    for (JFAlivcModel *model in self.channelList) {
        JFSheetActionStyle style = JFSheetActionStyleDefault;
        if ([self.channelTitle isEqualToString:model.live_title]) {
            style = JFSheetActionStyleSelected;
        }
        [sheetView addAction:[JFSheetAction actionWithTitle:model.live_title style:style]];
    }
    sheetView.confirmHandle = ^(NSInteger index) {
        JFAlivcParamTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.channelTitle = self.channelList[index].live_title;
        [cell updateDefaultValue:self.channelTitle];
    };
    
    JFSheetController *sheetController = [JFSheetController alertControllerWithSheetView:sheetView];
    [self presentViewController:sheetController animated:YES completion:nil];
}

- (void)updateFpsCell:(NSString*)value {
    JFPickerView *pickerView = [[JFPickerView alloc]init];
    pickerView.defaultValue = value;
    pickerView.confirmHandle = ^(id selectedValue) {
        JFAlivcParamTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0]];
        [cell updateDefaultValue:selectedValue];
    };
    JFSheetController *sheetController = [JFSheetController alertControllerWithSheetView:pickerView];
    [self presentViewController:sheetController animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JFAlivcParamModel *model = self.dataArray[indexPath.row];
    if (model) {
        NSString *cellIdentifier = [NSString stringWithFormat:@"JFAlivcParamTableViewCellIndentifier%@",model.title];
        JFAlivcParamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[JFAlivcParamTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell configureCellModel:model];
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = [UIColor colorWithRed:245.f/255.f green:245.f/255.f blue:245.f/255.f alpha:1];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-  (JFAlivcViewModel *)viewModel{
    if(!_viewModel){
        _viewModel = [JFAlivcViewModel new];
    }
    return _viewModel;
}


- (JFAlivcParamModel*)channelModel {
    JFAlivcParamModel *channelModel = [[JFAlivcParamModel alloc]init];
    channelModel.title = @"选择频道";
    channelModel.infoText = @"";
    channelModel.buttonTag = 3018;
    channelModel.reuseId = JFAlivcParamModelReuseCellSheet;
    channelModel.channelBlock = ^{
        self.isCellUpdate = YES;
        [self.viewModel channelListRequest];
    };
    return channelModel;
}

- (JFAlivcParamModel*)writeAddressModel {
    JFAlivcParamModel *addressModel = [[JFAlivcParamModel alloc]init];
    addressModel.title = @"输入推流地址";
    addressModel.infoText = self.writeURL;
    addressModel.reuseId = JFAlivcParamModelReuseCellInput;
    addressModel.valueBlock = ^(id value) {
        self.writeURL = value;
    };
    return addressModel;
}

- (JFAlivcParamModel*)addressModel {
    JFAlivcParamModel *addressModel = [[JFAlivcParamModel alloc]init];
    addressModel.title = @"该视频推流地址";
    addressModel.infoText = self.publisherURL;
    addressModel.reuseId = JFAlivcParamModelReuseCellLabel;
    addressModel.valueBlock = ^(id value) {
        self.publisherURL = value;
    };
    return addressModel;
}



@end

