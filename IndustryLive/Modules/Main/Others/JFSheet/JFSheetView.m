//
//  JFSheetView.m
//  IndustryLive
//
//  Created by zz on 2018/1/17.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import "JFSheetView.h"
#import <Masonry/Masonry.h>
#import "JFSheetController.h"

#define kButtonTagOffset 1000
#define kButtonSpace     0.5
#define kButtonHeight    58
@interface JFSheetAction ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) JFSheetActionStyle style;
@property (nonatomic, copy) void (^handler)(NSInteger index);
@end

@implementation JFSheetAction

+ (instancetype)actionWithTitle:(NSString *)title style:(JFSheetActionStyle)style handler:(void (^)(NSInteger index))handler{
    return [[self alloc]initWithTitle:title style:style handler:handler];
}

+ (instancetype)actionWithTitle:(NSString *)title  style:(JFSheetActionStyle)style {
    return [[self alloc]initWithTitle:title style:style handler:nil];
}

- (instancetype)initWithTitle:(NSString *)title style:(JFSheetActionStyle)style handler:(void (^)(NSInteger index))handler{
    if (self = [super init]) {
        _title = title;
        _style = style;
        _handler = handler;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    JFSheetAction *action = [[self class]allocWithZone:zone];
    action.title = self.title;
    action.style = self.style;
    return action;
}
@end

@interface JFSheetView()
@property (nonatomic, weak) UIView *titleContentView;
@property (nonatomic, weak) UILabel *messageLabel;
@property (nonatomic, weak) UIScrollView *buttonContentView;
@property (nonatomic, weak) UIView *sheetBaseContentView;
@property (nonatomic, weak) UIButton *cancelButton;
@property (nonatomic, weak) UIButton *confirmButton;
@property (nonatomic, weak) UIButton *selectedButton;
@property (nonatomic, strong) MASConstraint *lastButtonBottomContstraint;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *actions;
@end

@implementation JFSheetView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self configureProperty];
        [self addContentViews];
    }
    return self;
}

- (void)configureProperty{
    _clickedAutoHide = YES;
    self.backgroundColor = [UIColor clearColor];
    
    _buttonHeight = kButtonHeight;
    _buttonSpace = kButtonSpace;
    _buttonFont = [UIFont systemFontOfSize:18];
    
    _buttons = [NSMutableArray array];
    _actions = [NSMutableArray array];
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
    
    UIScrollView *buttonContentView = [[UIScrollView alloc]init];
    buttonContentView.bounces = NO;
    buttonContentView.backgroundColor = [UIColor clearColor];
    buttonContentView.userInteractionEnabled = YES;
    [sheetBaseContentView addSubview:buttonContentView];
    _buttonContentView = buttonContentView;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:50/255.0 green:64/255.0 blue:87/255.0 alpha:1.0] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = _buttonFont;
    [cancelButton addTarget:self action:@selector(actionCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_titleContentView addSubview:cancelButton];
    _cancelButton = cancelButton;
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor colorWithRed:237/255.0 green:55/255.0 blue:61/255.0 alpha:1.0] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = _buttonFont;
    [confirmButton addTarget:self action:@selector(actionConfirmClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_titleContentView addSubview:confirmButton];
    _confirmButton = confirmButton;
}

- (void)didMoveToSuperview{
    if (self.superview) {
        [self layoutContentViews];
    }
}

- (void)layoutContentViews{
    CGFloat limit_count = MIN(_buttons.count, 4.5);
    CGFloat fatherViewHeight = limit_count * _buttonHeight + (limit_count - 1) * _buttonSpace + 58;
    self.frame = CGRectMake(0, kScreenH - fatherViewHeight - 32, kScreenW, fatherViewHeight);
    
    [_sheetBaseContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(fatherViewHeight);
    }];
    
    [_buttonContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(58);
        make.left.right.bottom.mas_equalTo(0);
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

- (void)addAction:(JFSheetAction *)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:action.title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"sheet.bundle/sheet_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"sheet.bundle/sheet_selected"] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"sheet.bundle/sheet_selected"] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor colorWithRed:50/255.0 green:64/255.0 blue:87/255.0 alpha:1.0] forState:UIControlStateNormal];
    button.titleLabel.font = _buttonFont;
    button.backgroundColor = [UIColor whiteColor];
    button.tag = kButtonTagOffset + _buttons.count;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 70);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 48, 0, 16);
  
    [button addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (action.style == JFSheetActionStyleSelected) {
        button.selected = YES;
        _selectedButton = button;
    }
    
    [_buttonContentView addSubview:button];
    [_buttons addObject:button];
    [_actions addObject:action];
    
    if (_buttons.count == 1) {
        [self layoutContentViews];
    }
    
    [self layoutButtons];
}

- (void)layoutButtons {
    UIButton *button = _buttons.lastObject;
    if (_buttons.count == 1) {
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            _lastButtonBottomContstraint= make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(_buttonContentView);
            make.height.mas_equalTo(_buttonHeight);
        }];
    }else{
        UIButton *lastSecondBtn = _buttons[_buttons.count - 2];
        [_lastButtonBottomContstraint uninstall];
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lastSecondBtn.mas_bottom).mas_offset(_buttonSpace);
            make.left.right.mas_equalTo(0);
            _lastButtonBottomContstraint= make.bottom.mas_equalTo(0);
            make.size.mas_equalTo(lastSecondBtn);
        }];
    }
}

- (void)actionButtonClicked:(UIButton *)button{
    _selectedButton.selected = NO;
    button.selected = YES;
    _selectedButton = button;
    JFSheetAction *action = _actions[button.tag - kButtonTagOffset];
    if (action.handler) {
        action.handler(button.tag - kButtonTagOffset);
    }
}

- (void)actionCancelClicked:(UIButton *)button {
    if (_clickedAutoHide) {
        [self hideView];
    }
}

- (void)actionConfirmClicked:(UIButton *)button {
    if (self.confirmHandle) {
        self.confirmHandle(_selectedButton.tag - kButtonTagOffset);
    }
    
    if (_clickedAutoHide) {
        [self hideView];
    }
}

@end
