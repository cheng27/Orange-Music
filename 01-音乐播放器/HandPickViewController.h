//
//  HandPickViewController.h
//  01-音乐播放器
//
//  Created by qingyun on 16/1/4.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HandPickViewController;

@protocol HandPickViewControllerDelegate <NSObject>

@end

@interface HandPickViewController : UIViewController

@property (nonatomic,strong) id<HandPickViewControllerDelegate> delegate;

@end
