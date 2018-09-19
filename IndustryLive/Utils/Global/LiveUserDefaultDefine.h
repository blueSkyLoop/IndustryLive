//
//  LiveUserDefaultDefine.h
//  IndustryLive
//
//  Created by Lol on 2018/2/6.
//  Copyright © 2018年 lgh. All rights reserved.
//

#ifndef LiveUserDefaultDefine_h
#define LiveUserDefaultDefine_h

#define LiveUserDefault_LaunchUrlKey @"LiveUserDefault_LaunchUrlKey"

#define MNSUserDefaultsSet(Value,Key) [[NSUserDefaults standardUserDefaults] setValue:Value forKey:Key]
#define MNSUserDefaultsGet_String(Key)   [[NSUserDefaults standardUserDefaults] objectForKey:Key]
#endif /* LiveUserDefaultDefine_h */
