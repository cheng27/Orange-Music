//
//  AllMusicModel.m
//  01-音乐播放器
//
//  Created by qingyun on 16/1/5.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "AllMusicModel.h"

@implementation AllMusicModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqual:@"id"]) {
        [self setValue:value forKey:@"Id"];
    }
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
