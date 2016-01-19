//
//  AppDelegate.h
//  01-音乐播放器
//
//  Created by qingyun on 15/12/23.
//  Copyright © 2015年 阿六. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSManagedObjectContext *manageContext;
@property (nonatomic,strong) NSManagedObjectModel *manageModel;
@property (nonatomic,strong) NSPersistentStoreCoordinator *persistenCoordinator;

@end

