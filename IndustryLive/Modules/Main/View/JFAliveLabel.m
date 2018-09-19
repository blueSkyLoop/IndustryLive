//
//  JFAliveLabel.m
//  IndustryLive
//
//  Created by ikrulala on 2018/1/24.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import "JFAliveLabel.h"

@implementation JFAliveLabel

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(pasteEvent)) {
        return YES;
    }
    return NO;
}

-(void)copy:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}

-(void)attachTapHandler {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:touch];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self attachTapHandler];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIMenuControllerWillHideMenuNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            self.backgroundColor = [UIColor whiteColor];
        }];
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self attachTapHandler];
}

-(void)handleTap:(UIGestureRecognizer*) recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        return;
    }else if (recognizer.state == UIGestureRecognizerStateBegan){
        [self becomeFirstResponder];
        self.backgroundColor = [UIColor colorWithRed:236.f/255.f green:236.f/255.f blue:236.f/255.f alpha:1];
        UIMenuItem * item = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(pasteEvent)];
        [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
        [UIMenuController sharedMenuController].menuItems = @[item];
        [UIMenuController sharedMenuController].menuVisible = YES;
    }
}

-(void)pasteEvent{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.text;
}

@end
