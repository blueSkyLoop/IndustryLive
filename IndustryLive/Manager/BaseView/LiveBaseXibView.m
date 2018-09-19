//
//  LiveBaseXibView.m
//  IndustryLive
//
//  Created by lgh on 2018/1/19.
//  Copyright © 2018年 IndustryLive. All rights reserved.
//

#import "LiveBaseXibView.h"

@implementation LiveBaseXibView

+ (id)loadViewFromXib{
    UIView *aview = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    return aview;
}

@end
