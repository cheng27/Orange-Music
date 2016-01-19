//
//  MusicListViewController.h
//  01-音乐播放器
//
//  Created by qingyun on 16/1/5.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicListViewController;

@protocol  MusicListViewControllerDelegate <NSObject>

@end

@interface MusicListViewController : UIViewController
@property (nonatomic,strong) id <MusicListViewControllerDelegate> delegate;

@end
