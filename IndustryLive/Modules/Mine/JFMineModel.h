//
//  JFMineModel.h
//  IndustryLive
//
//  Created by ikrulala on 2018/1/24.
//  Copyright © 2018年 lgh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFMineModel : NSObject
/** 头像（大图）*/
@property (nonatomic,copy)NSString *o_img_head_photo;
/** 头像（小图）*/
@property (nonatomic,copy)NSString *s_img_head_photo;
/** 姓名 */
@property (nonatomic,copy)NSString *real_name;
/** 是否全经联会员，0：否，1：是 */
@property (nonatomic,copy)NSString *is_qjl_member;
/** 企业类型名称 */
@property (nonatomic,copy)NSString *company_type_name;
/** 会员身份 */
@property (nonatomic,strong)NSArray *user_role_list;
@end
