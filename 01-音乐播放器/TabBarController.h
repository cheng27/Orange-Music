//
//  TabBarController.h
//  02-音乐播放器
//
//  Created by qingyun on 15/12/29.
//  Copyright © 2015年 阿六. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface TabBarController : UITabBarController

+ (TabBarController *)shareMyTabBar;


@property (nonatomic,strong)TabBarController *myTabBar;
@property (nonatomic,strong)UIView *bottomView;




 

@end
