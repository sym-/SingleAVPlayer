//
//  YMVideoModel.m
//  SingleAVPlayer
//
//  Created by 宋元明 on 16/5/27.
//  Copyright © 2016年 宋元明. All rights reserved.
//

#import "YMVideoModel.h"
#import <objc/runtime.h>

@implementation YMVideoModel
@synthesize description = _description;
-(void)setDescription:(NSString *)description{
    _description = description;
}

-(NSString *)description{
    return _description;
}

-(void)autoParseDictionary:(NSDictionary *)dict{
    unsigned int count = 0;
    Ivar *vars = class_copyIvarList([YMVideoModel class], &count);
    for (int i = 0; i< count; i++) {
        Ivar var = vars[i];
        const char *varName = ivar_getName(var);
        NSMutableString *key = (NSMutableString *)[NSString stringWithUTF8String:varName];
        key = (NSMutableString *)[key substringFromIndex:1];
        id value = dict[key];
        if ([value isKindOfClass:[NSString class]]) {
            object_setIvar(self, var, value);
        }
        else if ([value isKindOfClass:[NSNumber class]]){
            value = [value stringValue];
            object_setIvar(self, var, value);
        }
        else if ([value isKindOfClass:[NSNull class]]){
            value = @"";
            object_setIvar(self, var, value);
        }
        
        //检验
        id varValue = object_getIvar(self, var);
//        NSLog(@"类名:%@{%s *%@=%@}---字典里值:%@", [self class], varName, key, varValue, value);
        
    }
}

@end



