//
//  UIView+Radius.m
//  IndustryLive
//
//  Created by Lol on 2018/1/18.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import "UIView+Radius.h"

@implementation UIView (Radius)

- (void)jf_viewRadius:(CGFloat)value {
    CGRect  imageFrame = self.frame ;
    self.layer.cornerRadius = imageFrame.size.width * value  ;
    self.layer.masksToBounds = YES ;
    
    
}

@end
