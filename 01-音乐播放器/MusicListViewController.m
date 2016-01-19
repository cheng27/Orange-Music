//
//  MusicListViewController.m
//  01-音乐播放器
//
//  Created by qingyun on 16/1/5.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "MusicListViewController.h"
#import "Header.h"


@interface MusicListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIRefreshControl *refresh;
}

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *musicListArr;
@property (nonatomic,assign) NSInteger pageNum;


@end

@implementation MusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.pageNum = 1;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self requestMusicFromNet];
    [self addRefreshControl];
    // Do any additional setup after loading the view.
}

#pragma mark - 懒加载
- (NSMutableArray *)musicListArr
{
    if (_musicListArr == nil) {
        _musicListArr = [NSMutableArray array];
    }
    return _musicListArr;
}


- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (void)addRefreshControl
{
    __weak MusicListViewController *weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"下拉刷新");
        weakSelf.pageNum = 1;
        [weakSelf requestMusicFromNet];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载");
        weakSelf.pageNum ++;
        [weakSelf requestMusicFromNet];
    }];
}

#pragma mark - 网络请求
- (void)requestMusicFromNet
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    hud.tag = 200;
    hud.labelText = @"正在加载...";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    NSString *urlStr = [NSString stringWithFormat:@"http://api.kaolafm.com/api/v4/resource/search?words=&cid=779&sorttype=HOT_RANK_DESC&pagesize=10&pagenum=%ld&rtype=20000&installid=0002Eii6&udid=8dae1e0b42ae0a6888b4e41bc8386d45&sessionid=8dae1e0b42ae0a6888b4e41bc8386d451451537274858&imsi=460023385352061&operator=1&lon=113.564073&lat=34.819398&network=1&timestamp=1451537543&sign=8f815021406fbe35ab2164aec34bb5d1&resolution=1080*1920&devicetype=0&channel=B-oppo&version=4.4.1&appid=0&",(long)self.pageNum];
    NSMutableArray *muarr = [NSMutableArray array];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@">>> %@",responseObject);
        NSDictionary *dict = responseObject;
        NSArray *array = dict[@"result"][@"dataList"];
        for (NSDictionary *dic in array) {
            if (self.pageNum == 1) {
                [muarr addObject:dic];
            }else
            {
                [self.musicListArr addObject:dic];
            }
        }
        if (self.pageNum == 1) {
            self.musicListArr = muarr;
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@" >>> %@",error);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"加载失败!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
    }];
    if (refresh.isRefreshing) {
        [refresh endRefreshing];
    }
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - TableViewDataSource  delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musicListArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    AllMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"AllMusicTableViewCell" owner:self options:nil][0];
    }
    NSDictionary *dict = self.musicListArr[indexPath.row];
    cell.desc.text = dict[@"desc"];
    cell.name.text = dict[@"name"];
    cell.albumId = dict[@"id"];
    
    [cell.image sd_setImageWithURL:[NSURL URLWithString:dict[@"pic"]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MusicCellPlay *play = [[MusicCellPlay alloc] init];
    NSDictionary *dict = self.musicListArr[indexPath.row];
    [play setValue:dict[@"id"] forKey:@"ID"];
    
    [play requestMp3:play.ID];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    hud.tag = 200;
    hud.labelText = @"正在加载...";
    
    [NSThread sleepForTimeInterval:1];
    [self presentViewController:play animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    //        cell.layer.transform = rotation;
    //        cell.layer.anchorPoint = CGPointMake(.1, .5);
    //        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    cell.layer.transform = CATransform3DMakeTranslation(0.1, 0.1, 1);
    cell.layer.transform = CATransform3DInvert(rotation);
    //        cell.layer.transform = CATransform3DConcat(rotation,rotation);
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:1.2];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    
}
@end
