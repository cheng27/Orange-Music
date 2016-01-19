//
//  MyPlayer.h
//  02-音乐播放器
//
//  Created by qingyun on 15/12/26.
//  Copyright © 2015年 阿六. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MyPlayer : NSObject

@property (nonatomic,strong) AVPlayer *player;

+ (MyPlayer *)sharePlayer;

@end
