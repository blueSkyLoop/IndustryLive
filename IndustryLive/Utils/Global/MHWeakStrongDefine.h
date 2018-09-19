//
//  MHWeakStrongDefine.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/10.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#ifndef MHWeakStrongDefine_h
#define MHWeakStrongDefine_h

#ifndef MHWeakify
    #if __has_feature(objc_arc)
    #define MHWeakify(object)  __weak __typeof__(object) weak##_##object = object;
    #else
    #define MHWeakify(object)  __block __typeof__(object) block##_##object = object;
    #endif
#endif

#ifndef MHStrongify
    #if __has_feature(objc_arc)
    #define MHStrongify(object)  __typeof__(object) object = weak##_##object;
    #else
    #define MHStrongify(object)  __typeof__(object) object = block##_##object;
    #endif
#endif


#endif /* MHWeakStrongDefine_h */
