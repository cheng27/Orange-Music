//
//  HandPickModel.h
//  01-音乐播放器
//
//  Created by qingyun on 16/1/4.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandPickModel : NSObject
@property (nonatomic,strong) NSString *mp3PlayUrl;
@property (nonatomic,strong) NSString *des;
@property (nonatomic,strong) NSString *albumName;
@property (nonatomic,strong) NSString *pic;
@property (nonatomic,strong) NSString *rname;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
