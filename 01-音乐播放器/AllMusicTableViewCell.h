//
//  AllMusicTableViewCell.h
//  01-音乐播放器
//
//  Created by qingyun on 16/1/5.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AllMusicModel;

@interface AllMusicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *desc;

@property (nonatomic,strong) AllMusicModel *model;
@property (nonatomic,strong) NSNumber *albumId;
@end
