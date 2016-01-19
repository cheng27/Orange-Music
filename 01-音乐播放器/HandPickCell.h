//
//  HandPickCell.h
//  01-音乐播放器
//
//  Created by qingyun on 16/1/5.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HandPickModel;

@interface HandPickCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *rname;
@property (weak, nonatomic) IBOutlet UILabel *des;
@property (nonatomic,strong) HandPickModel *model;
@end
