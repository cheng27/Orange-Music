//
//  HandPickModel.m
//  01-音乐播放器
//
//  Created by qingyun on 16/1/4.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "HandPickModel.h"

@implementation HandPickModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}



@end
