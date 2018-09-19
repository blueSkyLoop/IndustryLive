//
//  NSObject+parser.m
//  LaiKeBaoNew
//
//  Created by lgh on 2017/12/14.
//  Copyright © 2017年 lgh. All rights reserved.
//

#import "NSObject+parser.h"

@implementation NSObject (parser)

- (id)ln_parseMake:(void(^)(LNParserMarker *make))block{
    LNParserMarker *amaker = [[LNParserMarker alloc] initWithData:self];
    block(amaker);
    return [amaker parserData];
}

@end
