//
//  UIView+FrameExtension.h
//  
//
//  Created by qingyun on 15/12/18.
//  Copyright © 2015年 阿六. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameExtension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@end
