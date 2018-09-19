//
//  JFPickerView.m
//  IndustryLive
//
//  Created by ikrulala on 2018/1/23.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import "JFPickerView.h"
#import <Masonry.h>
#import "MHMacros.h"
#import "JFSheetController.h"

@interface JFPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,weak) UIView *titleContentView;
@property (nonatomic,weak) UIView *sheetBaseContentView;
@property (nonatomic,weak) UIPickerView *pickerView;
@property (nonatomic,weak) UIButton *cancelButton;
@property (nonatomic,weak) UIButton *confirmButton;
@property (nonatomic,weak) UIView *tipsView;
@property (nonatomic,strong) NSArray *rowArray;
@property (nonatomic,assign) NSInteger selectRow;
@end

@implementation JFPickerView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.rowArray = @[@"8",@"10",@"12",@"15",@"20",@"25",@"30"];
        [self addContentViews];
    }
    return self;
}

- (void)addContentViews {
    UIView *sheetBaseContentView = [[UIView alloc]init];
    sheetBaseContentView.layer.cornerRadius = 8;
    sheetBaseContentView.clipsToBounds = YES;
    sheetBaseContentView.userInteractionEnabled = YES;
    sheetBaseContentView.backgroundColor = [UIColor colorWithRed:211/255.0 green:220/255.0 blue:230/255.0 alpha:1.0];
    [self addSubview:sheetBaseContentView];
    _sheetBaseContentView = sheetBaseContentView;

    UIView *titleContentView = [[UIView alloc]init];
    titleContentView.backgroundColor = [UIColor whiteColor];
    [sheetBaseContentView addSubview:titleContentView];
    _titleContentView = titleContentView;
    
    UIPickerView *pickerView = [[UIPickerView alloc]init];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [sheetBaseContentView addSubview:pickerView];
    _pickerView = pickerView;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:50/255.0 green:64/255.0 blue:87/255.0 alpha:1.0] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelButton addTarget:self action:@selector(actionCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_titleContentView addSubview:cancelButton];
    _cancelButton = cancelButton;
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor colorWithRed:237/255.0 green:55/255.0 blue:61/255.0 alpha:1.0] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [confirmButton addTarget:self action:@selector(actionConfirmClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_titleContentView addSubview:confirmButton];
    _confirmButton = confirmButton;
    
    UIView *tipsView = [[UIView alloc] init];
    tipsView.backgroundColor = MColorToRGB(0XFF4949);
    [_pickerView addSubview:tipsView];
    _tipsView = tipsView;
}


- (void)didMoveToSuperview{
    if (self.superview) {
        [self layoutContentViews];
        _selectRow = [_rowArray indexOfObject:_defaultValue];
        [self.pickerView selectRow:_selectRow inComponent:0 animated:NO];
    }
}

- (void)layoutContentViews {
    self.frame = CGRectMake(0,MScreenH - 328, MScreenW, 296);
    [_sheetBaseContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(296);
    }];
    [_pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(58);
        make.left.right.bottom.mas_equalTo(0);
    }];
    [_tipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(60);
        make.centerY.mas_equalTo(_pickerView);
    }];
    [_titleContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(57.5);
    }];
    [_cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.centerY.mas_equalTo(_titleContentView);
    }];
    [_confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-24);
        make.centerY.mas_equalTo(_titleContentView);
    }];
}

- (void)actionCancelClicked:(UIButton *)sender {
    [self hideView];
}

- (void)actionConfirmClicked:(UIButton *)sender {
    if (self.confirmHandle) {
        self.confirmHandle(_rowArray[_selectRow]);
    }
    [self hideView];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 7;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *reasonLabel = [UILabel new];
    reasonLabel.textAlignment = NSTextAlignmentCenter;
    reasonLabel.text = _rowArray[row];
    reasonLabel.font = [UIFont boldSystemFontOfSize:18];
    reasonLabel.textColor = MColorToRGB(0X999999);
    if (row == _selectRow) {
        reasonLabel.textColor = MColorToRGB(0XFF4949);
    }
    return reasonLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _selectRow = row;
    [pickerView reloadComponent:component];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 58.5f;
}


@end
