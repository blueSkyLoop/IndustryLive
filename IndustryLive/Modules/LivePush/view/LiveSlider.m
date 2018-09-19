//
//  LiveSlider.m
//  IndustryLive
//
//  Created by lgh on 2018/1/18.
//  Copyright © 2018年 IndustryLive. All rights reserved.
//

#import "LiveSlider.h"

@implementation LiveSlider


- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value

{
    //返回滑块大小
    
    rect.origin.x = rect.origin.x - 10 ;
    
    rect.size.width = rect.size.width +10;
    
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 10 , 10);
    
}


@end
