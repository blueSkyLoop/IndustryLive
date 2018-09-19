//
//  JFAlivcParamTableViewCell.h
//  IndustryLive
//
//  Created by ikrulala on 2018/1/18.
//  Copyright © 2018年 Lol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JFAlivcParamModel;
@interface JFAlivcParamTableViewCell : UITableViewCell

- (void)configureCellModel:(JFAlivcParamModel*)cellModel;
- (void)updateDefaultValue:(NSString *)value;
@end
