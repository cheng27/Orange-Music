//
//  AppDelegate.m
//  01-音乐播放器
//
//  Created by qingyun on 15/12/23.
//  Copyright © 2015年 阿六. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//托管对象
- (NSManagedObjectModel *)manageModel
{
    if (_manageModel == nil) {
        _manageModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return _manageModel;
}
//托管对象上下文
- (NSManagedObjectContext *)manageContext
{
    if (_manageContext != nil) {
        return _manageContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistenCoordinator];
    if (coordinator != nil) {
        _manageContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_manageContext setPersistentStoreCoordinator:coordinator];
    }
    return _manageContext;
}
//持久化存储协调器
- (NSPersistentStoreCoordinator *)persistenCoordinator
{
    if (_persistenCoordinator != nil) {
        return _persistenCoordinator;
    }
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSURL *storeUrl = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"Music.sqlite"]];
    _persistenCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self manageModel]];
    NSError *error;
    if (![_persistenCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error])
    {
        NSLog(@"error >>> %@",error);
    }
    return _persistenCoordinator;
}


@end
