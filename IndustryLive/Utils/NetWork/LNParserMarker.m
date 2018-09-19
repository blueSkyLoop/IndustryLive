//
//  LNParserMarker.m
//  LaiKeBaoNew
//
//  Created by lgh on 2017/12/14.
//  Copyright © 2017年 lgh. All rights reserved.
//

#import "LNParserMarker.h"
#import "YYModel.h"

@interface LNParserMarker()
@property (nonatomic,strong)NSMutableArray *keys;
@property (nonatomic,strong)NSMutableDictionary *classNameDic;
@property (nonatomic,weak,readwrite)id ln_data;
@property (nonatomic,copy,readwrite)NSString *ln_className;
@end

@implementation LNParserMarker

//- (void)dealloc{
//    NSLog(@"%s",__func__);
//}

- (id)initWithData:(id)data{
    self = [super init];
    if(self){
        self.ln_data = data;
    }
    return self;
}

- (ParserKeyBlock)parserKey{
    return ^LNParserMarker *(NSString *aparserKey) {
        if(aparserKey){
            [self.keys addObject:aparserKey];
        }
        return self;
    };
}

- (ParserKeyBlock)keyClassName{
    return ^LNParserMarker *(NSString *akeyClassName) {
        if(akeyClassName && [self lastParserKey]){
            [self.classNameDic setValue:akeyClassName forKey:[self lastParserKey]];
        }
        return self;
    };
}

- (ParserKeyBlock)className{
    return ^LNParserMarker *(NSString *aclassName) {
        self.ln_className = aclassName;
        return self;
    };
}

- (NSString *)lastParserKey{
    if(self.keys.count){
        NSString *akey = [self.keys lastObject];
        return akey;
    }
    return nil;
}

- (NSString *)currentParserKey{
    if(self.keys.count){
        NSString *akey = [self.keys firstObject];
        [self.keys removeObjectAtIndex:0];
        return akey;
    }
    return nil;
}

- (id)parserData{
    if([self.ln_data isKindOfClass:[NSArray class]]){
        if(self.ln_className){
            id adata = [NSArray yy_modelArrayWithClass:NSClassFromString(self.ln_className) json:self.ln_data];
//            id adata = [NSClassFromString(self.ln_className) mj_objectArrayWithKeyValuesArray:self.ln_data];
            self.ln_className = nil;
            return adata;
        }else{
            return self.ln_data;
        }
    }else if([self.ln_data isKindOfClass:[NSDictionary class]]){
        if(self.ln_className){
            id adata = [NSClassFromString(self.ln_className) yy_modelWithJSON:self.ln_data];
//            id adata = [NSClassFromString(self.ln_className) mj_objectWithKeyValues:self.ln_data];
            self.ln_className = nil;
            return adata;
        }else{
            return [self parserDataAsKey];
        }
    }
    return self.ln_data;
}
- (id)parserWithData:(id)data{
    self.ln_data = data;
    return [self parserData];
}
- (id)parserDataAsKey{
    NSString *akey = [self currentParserKey];
    if(akey){
        self.ln_className = [self getClassNameWithKey:akey];
        self.ln_data = [self.ln_data valueForKey:akey];
        return [self parserData];
    }else{
        return self.ln_data;
    }
    return nil;
}

- (NSString *)getClassNameWithKey:(NSString *)akey{
    NSString *claassName = [self.classNameDic valueForKey:akey];
    if(claassName){
        [self.classNameDic removeObjectForKey:akey];
    }
    return claassName;
}

- (NSMutableArray *)keys{
    if(!_keys){
        _keys = [NSMutableArray array];
    }
    return _keys;
}

- (NSMutableDictionary *)classNameDic{
    if(!_classNameDic){
        _classNameDic = [NSMutableDictionary dictionary];
    }
    return _classNameDic;
}

@end
