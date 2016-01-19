//
//  MusicCellPlay.h
//  01-音乐播放器
//
//  Created by qingyun on 16/1/8.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MusicCellPlay : UIViewController
- (void)HandPickListPlay;
- (void)requestMp3:(NSNumber *)albumId;

@property (nonatomic,strong)UIButton *backMusicButton;
@property (nonatomic,strong) NSNumber *ID;

/*
 *  playView的控件
 */
//歌曲列表的tableView
@property (nonatomic,strong) UITableView *musicListTable;
//返回
@property (nonatomic,strong) UIButton *backBtn;
//中间的图片
@property (nonatomic,strong) UIImageView *middleImage;
//音乐名字
@property (nonatomic,strong) UILabel *musicName;
//专辑名字
@property (nonatomic,strong) UILabel *special;
//音量
@property (nonatomic,strong) UIButton *volume;
//歌曲列表
@property (nonatomic,strong) UIButton *musicList;
//当前时间
@property (nonatomic,strong) UILabel *currentTime;
//歌曲总时长
@property (nonatomic,strong) UILabel *durationTime;
//歌曲进度
@property (nonatomic,strong) UISlider *songSlide;
//音量大小
@property (nonatomic,strong) UISlider *volumeSlide;
//上一首
@property (nonatomic,strong) UIButton *previous;
//播放或者暂停
@property (nonatomic,strong) UIButton *playOrPause;
//下一首
@property (nonatomic,strong) UIButton *next;

@property (nonatomic,strong)AVPlayerItem *playerItem;

@end
