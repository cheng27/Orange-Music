//
//  CYJFileHandle.h
//  01-音乐播放器
//
//  Created by qingyun on 16/1/14.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HandPickModel;

@interface CYJFileHandle : NSObject
//创建单例对象
+ (instancetype)shareHandle;
//获取路径
- (NSString *)libraryPath;
//插入数据
- (BOOL)insertData2CollectMuisc:(HandPickModel *)model;
//查询数据
- (NSMutableArray *)selectMusicWithName:(NSString *)alnumName;
@end
