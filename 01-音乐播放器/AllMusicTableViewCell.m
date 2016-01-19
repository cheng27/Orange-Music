//
//  AllMusicTableViewCell.m
//  01-音乐播放器
//
//  Created by qingyun on 16/1/5.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "AllMusicTableViewCell.h"
#import "AllMusicModel.h"

@implementation AllMusicTableViewCell

- (void)setModel:(AllMusicModel *)model
{
    _model = model;
    _image.image = [UIImage imageNamed:model.pic];
    _name.text = model.name;
    _desc.text = model.desc;
    _albumId = model.Id;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
