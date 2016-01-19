//
//  MyPlayer.m
//  02-音乐播放器
//
//  Created by qingyun on 15/12/26.
//  Copyright © 2015年 阿六. All rights reserved.
//

#import "MyPlayer.h"

@implementation MyPlayer

+ (MyPlayer *)sharePlayer
{
    static MyPlayer *myPlayer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myPlayer = [[self alloc] init];
    });
    return myPlayer;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.player = [[AVPlayer alloc] init];
    }
    return self;
}

@end
