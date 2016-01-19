//
//  Header.h
//  01-音乐播放器
//
//  Created by qingyun on 15/12/24.
//  Copyright © 2015年 阿六. All rights reserved.
//

#ifndef Header_h
#define Header_h


#endif /* Header_h */
//宏定义
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define kBtnWidth     [UIScreen mainScreen].bounds.size.width/5
#define kBtnFrame  _bottomView.frame.size.width/5
#define kSpace 10

#define kGetContext ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext

#define HandPickURL   @"http://api.kaolafm.com/api/v4/pagecontent/list?pageid=6&installid=0002Eii6&udid=8dae1e0b42ae0a6888b4e41bc8386d45&sessionid=8dae1e0b42ae0a6888b4e41bc8386d451451887702167&imsi=460023385352061&operator=1&lon=0.0&lat=0.0&network=1&timestamp=1451898566&sign=8f815021406fbe35ab2164aec34bb5d1&resolution=1080*1920&devicetype=0&channel=B-oppo&version=4.4.1&appid=0&"



#import "AllMusicTableViewCell.h"
#import "AllMusicModel.h"
#import "HandPickModel.h"
#import "HandPickCell.h"
#import "HandPickPlay.h"
#import "MusicCellPlay.h"

#import "UIView+FrameExtension.h"
#import <AFHTTPSessionManager.h>
#import "MyPlayer.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import "Masonry.h"
#import <MBProgressHUD.h>
#import <SDCycleScrollView.h>
