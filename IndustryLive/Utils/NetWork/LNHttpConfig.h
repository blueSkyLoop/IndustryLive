//
//  LNHttpConfig.h
//  LaiKeBaoNew
//
//  Created by lgh on 2017/12/14.
//  Copyright © 2017年 lgh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNParserMarker.h"
#import "LNHttpManager.h"

typedef NS_ENUM(NSUInteger, LNRequestMethod) {
    LNRequestMethodGet,           //get 请求
    LNRequestMethodPost           //post 请求
};

typedef void(^NetProgressBlock)(NSProgress *uploadProgress);

@interface LNHttpConfig : NSObject
//加载样式 ,如果要加载转圈，则不可在viewDidLoad里加载，要在willappear 或以后，因为这时候才能找到这个顶层控制器，否则手动控制转圈的出现现消失,默认为HUD_showAndCompleHidden
@property (nonatomic,assign)HUDTYPE hudType;
//请求的方式，默认为Post
@property (nonatomic,assign)LNRequestMethod method;
//请求的接口
@property (nonatomic,copy)NSString *apiStr;
//请求的参数
@property (nonatomic,copy)NSDictionary *parameter;
//请求的进度block
@property (nonatomic,copy)NetProgressBlock progressBlock;
//对于请求完成了之后，对返回的结果数据进行类型的验证类型,默认为NSDictionary
@property (nonatomic,copy)NSString *checkClassName;
//请求的标记，标记是哪一个请求，在调起端识别，这里为了把apiStr和调起端隔离开来，所以加了一个apiFlag字段
@property (nonatomic,assign)NSInteger apiFlag;

//数据解析者，配置这个解析者，这样最后处理完的结果就是我们要的结果，例如转换成了我们需要的模型，需要的数据等等
@property (nonatomic,copy)void (^parserBlock)(LNParserMarker *marker);

//如果发生错误，是否显示错误信息，如果为YES，则会显示，否则不显示,调起者自行处理，如果配置了YES,则调起者可以不处理错误情况的提示,默认为YES
@property (nonatomic,assign)BOOL errorShowMessage;
//数据请求的原始数据，请求完成之后，会把原始数据保留在这个字段，以供使用
@property (nonatomic,strong)id orginData;

//返回一个默认配置的请求配置
+ (LNHttpConfig *)defaultHttpConfig;
//返回一个默认配置的请求配置
- (id)initWithDefaultHttpConfig;



@end
