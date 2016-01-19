//
//  AllMusicViewController.h
//  01-音乐播放器
//
//  Created by qingyun on 16/1/5.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AllMusicViewController;

@protocol  AllMusicViewControllerDelegate <NSObject>

@end

@interface AllMusicViewController : UIViewController

@property (nonatomic,strong) id<AllMusicViewControllerDelegate> delegate;

@end
