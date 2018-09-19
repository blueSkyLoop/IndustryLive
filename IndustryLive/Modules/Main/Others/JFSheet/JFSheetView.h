//
//  JFSheetView.h
//  IndustryLive
//
//  Created by zz on 2018/1/17.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, JFSheetActionStyle) {
    JFSheetActionStyleDefault,
    JFSheetActionStyleSelected
};
@interface JFSheetAction : NSObject<NSCopying>
+ (instancetype)actionWithTitle:(NSString *)title  style:(JFSheetActionStyle)style;
+ (instancetype)actionWithTitle:(NSString *)title  style:(JFSheetActionStyle)style  handler:(void (^)(NSInteger index))handler;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) JFSheetActionStyle style;
@end

@interface JFSheetView : UIView

@property (nonatomic, assign) CGFloat buttonHeight;
@property (nonatomic, assign) CGFloat buttonSpace;
@property (nonatomic, strong) UIFont  *buttonFont;
@property (nonatomic,   copy) void(^confirmHandle)(NSInteger index);

@property (nonatomic, assign) BOOL clickedAutoHide;
- (void)addAction:(JFSheetAction *)action;
@end
