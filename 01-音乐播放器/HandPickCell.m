//
//  HandPickCell.m
//  01-音乐播放器
//
//  Created by qingyun on 16/1/5.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "HandPickCell.h"
#import "HandPickModel.h"

@implementation HandPickCell

- (void)setModel:(HandPickModel *)model
{
    _model = model;
    _pic.image = [UIImage imageNamed:model.pic];
    _rname.text = model.rname;
    _des.text = model.des;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
