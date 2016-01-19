//
//  CYJFileHandle.m
//  01-音乐播放器
//
//  Created by qingyun on 16/1/14.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "CYJFileHandle.h"
#import "FMDB.h"
#import "HandPickModel.h"
#define DBName  @"musicCollect.db"

@interface CYJFileHandle()
@property (nonatomic,strong) FMDatabase *db;
@end

@implementation CYJFileHandle
+ (instancetype)shareHandle
{
    static CYJFileHandle *handle;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        handle = [[CYJFileHandle alloc] init];
        [handle createTable];
    });
    return handle;
}
- (NSString *)libraryPath
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    return path;
}
- (FMDatabase *)db
{
    if (_db) {
        return _db;
    }
    //合并文件路径
    NSString *dbPath = [[self libraryPath] stringByAppendingPathComponent:DBName];
    //创建数据库对象
    _db = [FMDatabase databaseWithPath:dbPath];
    return _db;
}
- (BOOL)createTable
{
    //1.打开数据库
    if (![self.db open]) {
        NSLog(@"打开数据库失败 >>>> %@",[self.db lastErrorMessage]);
        return NO;
    }
    //2.执行sql语句
    if (![self.db executeUpdate:@"create table if not exists musics (mp3PlayUrl text,albumName text,pic tect,desc text,rname text)"]) {
        NSLog(@"执行数据库失败>>> %@",[self.db lastErrorMessage]);
        [self.db close];
        return NO;
    }
    //3.关闭数据库
    [self.db close];
    return YES;
}
- (BOOL)insertData2CollectMuisc:(HandPickModel *)model
{
    //1.打开数据库
    [self.db open];
    //2.执行sql语句
    [self.db executeUpdateWithFormat:@"insert into musics values(%@,%@,%@)",model.mp3PlayUrl,model.albumName,model.pic ] ;
    //3.关闭数据库
    [self.db close];
    return YES;
}

- (NSMutableArray *)selectMusicWithName:(NSString *)alnumName
{
    //1.打开数据库
    if (![self.db open]) {
        NSLog(@"打开数据库失败 >>>> %@",[self.db lastErrorMessage]);
        return nil;
    }
    //2.执行sql语句
    FMResultSet *set = [self.db executeQueryWithFormat:@"select * from musics where albumName = %@",alnumName];
    NSMutableArray *arr = [NSMutableArray array];
    while ([set next]) {
        HandPickModel *model = [[HandPickModel alloc]initWithDict:[set resultDictionary]];
        [arr addObject:model];
    }
    //3.关闭数据库
    [self.db close];
    return arr;
}
//- (BOOL)deleteDataFrom

@end


















