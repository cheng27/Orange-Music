//
//  AllMusicModel.h
//  01-音乐播放器
//
//  Created by qingyun on 16/1/5.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllMusicModel : NSObject
@property (nonatomic,strong) NSString *albumName;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSNumber *Id;
@property (nonatomic,strong) NSString *pic;
@property (nonatomic,strong) NSString *name;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)modelWithDict:(NSDictionary *)dict;


@end
