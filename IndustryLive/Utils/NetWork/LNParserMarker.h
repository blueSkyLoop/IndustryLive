//
//  LNParserMarker.h
//  LaiKeBaoNew
//
//  Created by lgh on 2017/12/14.
//  Copyright © 2017年 lgh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LNParserMarker;

typedef LNParserMarker *(^ParserKeyBlock)(NSString *);

//解析器
@interface LNParserMarker : NSObject

- (id)initWithData:(id)data;


//解析的key
- (ParserKeyBlock)parserKey;
//把这个key解析出来的字段转换成模型 keyClassName 模型类名  所以要先写parserKey再传类名 例如： marker.parserKey(@"operatorInfo").keyClassName(@"LKUserInfoModel");
- (ParserKeyBlock)keyClassName;

//如果直接把data转换成模型，则使用className
- (ParserKeyBlock)className;

//这个是已经使用 - (id)initWithData:(id)data;传进了data的情况下解析，一般不明显使用，供NSObject+parser.h中使用
- (id)parserData;

//解析data数据
- (id)parserWithData:(id)data;

@end
