//
//  JFAlivcParamTableViewCell.m
//  IndustryLive
//
//  Created by ikrulala on 2018/1/18.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import "JFAlivcParamTableViewCell.h"
#import "JFAlivcParamModel.h"
#import <Masonry.h>
#import "JFAliveLabel.h"

#define kTitleColor [UIColor colorWithRed:53.f/255.f green:53.f/255.f blue:53.f/255.f alpha:1]
#define kSegmentColor [UIColor colorWithRed:245.f/255.f green:245.f/255.f blue:245.f/255.f alpha:1]
#define kButtonDefaultColor [UIColor colorWithRed:204.f/255.f green:204.f/255.f blue:204.f/255.f alpha:1]
#define kRedColor [UIColor colorWithRed:255.f/255.f green:73.f/255.f blue:73.f/255.f alpha:1]

#define kDefaultTag 1902

@interface JFAlivcParamTableViewCell ()<UITextViewDelegate>
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) JFAliveLabel *urlLabel;
@property (nonatomic,strong) UITextView *inputView;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) UILabel *infoLabel;
@property (nonatomic,strong) UIButton *switchButton;
@property (nonatomic,strong) UIButton *clearButton; //textView 的清除按钮
@property (nonatomic,strong) UITextField *inputTextField;
@property (nonatomic,strong) UIView *baseView;

@property (nonatomic,strong) JFAlivcParamModel *cellModel;
@property (nonatomic,  copy) NSString *cacheString;
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,weak) UIActivityIndicatorView *loadingView;
@end

@implementation JFAlivcParamTableViewCell

- (void)setupSubViews {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel.text = self.cellModel.title;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(16);
        make.height.mas_equalTo(20);
    }];
    
    if ([self.cellModel.reuseId isEqualToString:JFAlivcParamModelReuseCellSheet]) {
        [self setupSheetView];
    }else if ([self.cellModel.reuseId isEqualToString:JFAlivcParamModelReuseCellInput]) {
        [self setupInputView];
    }else if ([self.cellModel.reuseId isEqualToString:JFAlivcParamModelReuseCellSlider]) {
        [self setupSliderView];
    }else if ([self.cellModel.reuseId isEqualToString:JFAlivcParamModelReuseCellSegment]) {
        [self setupSegmentView];
    }else if ([self.cellModel.reuseId isEqualToString:JFAlivcParamModelReuseCellLabel]) {
        [self setupLabelView];
    }
    
}

- (void)setupSheetView {
    UIButton *baseView = [UIButton buttonWithType:UIButtonTypeCustom];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:baseView];
    
    baseView.tag = self.cellModel.buttonTag;
    [baseView addTarget:self action:@selector(sheetAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.infoLabel.text = self.cellModel.infoText;
    self.infoLabel.textColor = kTitleColor;
    [baseView addSubview:self.infoLabel];
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.image = [UIImage imageNamed:@"main_arrow"];
    [baseView addSubview:imgView];
    
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(8);
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(baseView);
        make.right.mas_equalTo(-26);
    }];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(baseView);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(16);
    }];
}

- (void)setupLabelView {
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.urlLabel];
    self.urlLabel.text = self.cellModel.infoText;
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(8);
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(88);
    }];
    [self.urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setupInputView {
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.inputView];
    self.inputView.attributedText = [self lineBreakAtrributedString];
    
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.clearButton.hidden = YES;
    [self.clearButton setImage:[UIImage imageNamed:@"main_cancel"] forState:UIControlStateNormal];
    [self.clearButton addTarget:self action:@selector(clearInputText) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:self.clearButton];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(8);
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(88);
    }];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-24);
        make.bottom.mas_equalTo(-16);
    }];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(15);
        make.bottom.mas_equalTo(-12);
    }];
}

- (void)clearInputText {
    self.inputView.text = @"";
    self.clearButton.hidden = YES;
}

- (void)setupSliderView {
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.slider];
    [self.baseView addSubview:self.infoLabel];
    
    self.slider.value = self.cellModel.defaultValue.floatValue;
    self.infoLabel.text = self.cellModel.infoText;
    self.infoLabel.textAlignment = NSTextAlignmentCenter;

    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.text = @"500";
    leftLabel.textColor = kTitleColor;
    leftLabel.font = [UIFont systemFontOfSize:18];
    [self.baseView addSubview:leftLabel];
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.text = @"2500";
    rightLabel.textColor = kTitleColor;
    rightLabel.font = [UIFont systemFontOfSize:18];
    [self.baseView addSubview:rightLabel];
    UIView *segmentView = [UIView new];
    segmentView.backgroundColor = kSegmentColor;
    [self.baseView addSubview:segmentView];

    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(8);
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.baseView);
        make.width.mas_equalTo(45);
    }];
    [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.baseView);
        make.right.mas_equalTo(self.infoLabel.mas_left).mas_offset(-8);
        make.width.mas_equalTo(1);
        make.top.mas_equalTo(6);
        make.bottom.mas_equalTo(-6);
    }];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(segmentView.mas_left).mas_offset(-16);
        make.centerY.mas_equalTo(self.baseView);
        make.width.mas_equalTo(44);
    }];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(self.baseView);
        make.width.mas_equalTo(33);
    }];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftLabel.mas_right).mas_offset(12);
        make.right.mas_equalTo(rightLabel.mas_left).mas_offset(-12);
        make.centerY.mas_equalTo(self.baseView);
    }];

}

- (void)setupSegmentView {
    self.buttons = [NSMutableArray array];
    [self.contentView addSubview:self.baseView];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(8);
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(71);
    }];
    
    NSArray *buttonTitles = @[@"480p",@"540p",@"720p"];
    for (int i = 0; i < buttonTitles.count; i++) {
        UIButton *button = [self setupSegmentButtons:buttonTitles[i]];
        [self.baseView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16 + 94*i);
            make.width.mas_equalTo(74);
            make.height.mas_equalTo(41);
            make.centerY.mas_equalTo(self.baseView);
        }];
    }
    int index = 0;
    if ([self.cellModel.infoText isEqualToString:@"480p"]) {
        index = 0;
    }else if ([self.cellModel.infoText isEqualToString:@"540p"]) {
        index = 1;
    }else {
        index = 2;
    };
    [self segmentButtonsEvents:self.buttons[index]];
}

- (UIButton*)setupSegmentButtons:(NSString*)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:kButtonDefaultColor forState:UIControlStateNormal];
    [button setTitleColor:kRedColor forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:18.f];
    button.layer.borderWidth = 1.6;
    button.layer.borderColor = kButtonDefaultColor.CGColor;
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    button.tag = kDefaultTag + self.buttons.count;
    [button addTarget:self action:@selector(segmentButtonsEvents:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttons addObject:button];
    return button;
}

- (void)configureCellModel:(JFAlivcParamModel*)cellModel {
    self.cellModel = cellModel;
    [self setupSubViews];
}

//弹出窗
- (void)sheetAction:(UIButton*)sender{
    if (sender.tag == 3018) {
        self.cellModel.channelBlock();
    }else if (sender.tag == 3019){
        self.cellModel.fpsBlock(self.infoLabel.text);
    }
}
//进度条
- (void)sliderValueDidChanged {
    if (![self.titleLabel.text isEqualToString:@"码率(kbps)"]) {
        return;
    };
    
    NSString *sliderValue = [NSString stringWithFormat:@"%.0f",self.slider.value];
    self.infoLabel.text = sliderValue;
    self.cellModel.sliderBlock(sliderValue);
}
//分辨率
- (void)segmentButtonsEvents:(UIButton *)sender {
    for (UIButton *button in self.buttons) {
        button.layer.borderColor = kButtonDefaultColor.CGColor;
        button.selected = NO;
    }
    sender.selected = YES;
    sender.layer.borderColor = kRedColor.CGColor;
    int index = 3;
    if ([(sender.titleLabel.text) isEqualToString:@"480p"]) {
        index = 3;
    }else if ([sender.titleLabel.text isEqualToString:@"540p"]) {
        index = 4;
    }else {
        index = 5;
    };
    self.cellModel.switchButtonBlock(index);
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {

    if (textView.text.length == 0) {
        self.clearButton.hidden = YES;
    }else {
        self.clearButton.hidden = NO;
    }
    self.cellModel.valueBlock(textView.text);
}

- (NSAttributedString *)lineBreakAtrributedString {
    NSString *infoText = self.cellModel.infoText;
    if (!infoText) infoText = @"";
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *att = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSParagraphStyleAttributeName:style};
    NSMutableAttributedString *infotext = [[NSMutableAttributedString alloc]initWithString:infoText attributes:att];
    return infotext;
}

- (void)updateDefaultValue:(NSString *)value {
    if ([_cellModel.reuseId isEqualToString:JFAlivcParamModelReuseCellSheet]) {
        self.infoLabel.text = value;
    }else if ([_cellModel.reuseId isEqualToString:JFAlivcParamModelReuseCellLabel]) {
        self.urlLabel.text = value;
    }
}

#pragma mark - Property
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
        _titleLabel.textColor = kTitleColor;
    }
    return _titleLabel;
}

- (UITextView *)inputView {
    if (!_inputView) {
        _inputView = [UITextView new];
        _inputView.font = [UIFont systemFontOfSize:18.f];
        _inputView.delegate = self;
        _inputView.textColor = kTitleColor;
        _inputView.showsVerticalScrollIndicator = NO;
        UILabel *placeHolderLabel = [[UILabel alloc]init];
        placeHolderLabel.text = @"请输入推流地址";
        placeHolderLabel.textColor = kButtonDefaultColor;
        [_inputView addSubview:placeHolderLabel];
        placeHolderLabel.font= [UIFont systemFontOfSize:18.f];
        [_inputView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    }
    return _inputView;
}

- (JFAliveLabel *)urlLabel {
    if (!_urlLabel) {
        _urlLabel = [[JFAliveLabel alloc] init];
        _urlLabel.font = [UIFont systemFontOfSize:18.f];
        _urlLabel.textColor = kTitleColor;
        _urlLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _urlLabel.numberOfLines = 3;
    }
    return _urlLabel;
}

- (UISlider*)slider {
    if (!_slider) {
        _slider = [[UISlider alloc]init];
        _slider.minimumValue = 500;
        _slider.maximumValue = 2500;
        [_slider setMaximumTrackImage:[UIImage imageNamed:@"main_Inactive"] forState:UIControlStateNormal];
        [_slider setMinimumTrackImage:[UIImage imageNamed:@"main_active"] forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"main_dot"] forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"main_dot"] forState:UIControlStateHighlighted];
        [_slider addTarget:self action:@selector(sliderValueDidChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (UILabel*)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [UILabel new];
        _infoLabel.font = [UIFont systemFontOfSize:18.f];
        _infoLabel.textColor = kRedColor;
    }
    return _infoLabel;
}

- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [UITextField new];
        _inputTextField.layer.borderWidth = 1.6;
        _inputTextField.layer.cornerRadius = 4;
        _inputTextField.layer.masksToBounds = YES;
        _inputTextField.enabled = NO;
        _inputTextField.textAlignment = NSTextAlignmentCenter;
        _inputTextField.font = [UIFont systemFontOfSize:18.f];
        _inputTextField.textColor = kRedColor;
        _inputTextField.layer.borderColor = kRedColor.CGColor;
    }
    return _inputTextField;
}

- (UIView*)baseView {
    if (!_baseView) {
        _baseView = [UIView new];
        _baseView.backgroundColor = [UIColor whiteColor];
    }
    return _baseView;
}

@end
