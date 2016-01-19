//
//  HandPickViewController.m
//  01-音乐播放器
//
//  Created by qingyun on 16/1/4.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "HandPickViewController.h"
#import "Header.h"



@interface HandPickViewController ()<SDCycleScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIRefreshControl *refresh;
}
@property (nonatomic,strong) NSMutableArray *totalArr;
@property (nonatomic,strong) NSMutableArray *scrollImageArr;
@property (nonatomic,strong) NSMutableArray *scrollViewArr;
@property (nonatomic,strong) NSMutableArray *tableArr;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) HandPickModel *model;
@property (nonatomic,assign) NSInteger index;



@end

@implementation HandPickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    //加载ScrollView
    [self requestScrollViewFormNet];
    [self addRefreshControl];
    
}

#pragma mark - 懒加载
//总数据数组
- (NSMutableArray *)totalArr
{
    if (_totalArr == nil) {
        _totalArr = [NSMutableArray array];
    }
    return _totalArr;
}
//滚动的图片的数组
- (NSMutableArray *)scrollImageArr
{
    if (_scrollImageArr == nil) {
        _scrollImageArr = [NSMutableArray array];
    }
    return _scrollImageArr;
}
//滚动的数据的数组
- (NSMutableArray *)scrollViewArr
{
    if (_scrollViewArr == nil) {
        _scrollViewArr = [NSMutableArray array];
    }
    return _scrollViewArr;
}
//tableViewCell的数组
- (NSMutableArray *)tableArr
{
    if (_tableArr == nil) {
        _tableArr = [NSMutableArray array];
    }
    return _tableArr;
}
//tableView
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}
//网络会话管理器
- (AFHTTPSessionManager *)manager
{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
//添加滚动视图
- (void)addScrollView
{
    SDCycleScrollView *ScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 60, self.view.frame.size.width, kSpace * 18) imagesGroup:nil];
    ScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    ScrollView.dotColor = [UIColor whiteColor];
    ScrollView.imageURLStringsGroup = self.scrollImageArr;
    ScrollView.delegate = self;
    self.tableView.tableHeaderView = ScrollView;

}

- (void)addRefreshControl
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.totalArr removeAllObjects];
        [self requestScrollViewFormNet];
    }];
}

#pragma mark - 网络请求
- (void)requestScrollViewFormNet
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    hud.tag = 200;
    hud.labelText = @"正在加载...";
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    [self.manager GET:HandPickURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.tableArr removeAllObjects];
        [self.scrollImageArr removeAllObjects];
        NSDictionary *Dict = responseObject;
        NSArray *array = Dict[@"result"][@"dataList"];
        NSMutableArray *arr1 = [NSMutableArray array];
        for (int i = 0; i < 6; i++) {
            for (NSDictionary *dict in array) {
                _model = [HandPickModel modelWithDict:dict];
                [arr1 addObject:dict[@"dataList"]];
            }
            //[self.totalArr addObjectsFromArray:arr1];
        }
        for (NSDictionary *dic in arr1[0]) {
            [self.scrollImageArr addObject:dic[@"pic"]];
            [self.scrollViewArr addObject:dic];
        }
        [self addScrollView];
        
        for (NSDictionary *dic in arr1[5]) {
        
            [self.tableArr addObject:dic];
        }
        [self.totalArr addObjectsFromArray:self.scrollViewArr];
        [self.totalArr addObjectsFromArray:self.tableArr];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"加载失败!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];

    }];
    
    if (refresh.isRefreshing) {
        [refresh endRefreshing];
    }
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    
}


#pragma mark - ScrollViewDelegate
//ScrollView的点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    HandPickPlay *play = [[HandPickPlay alloc] init];
    [play setValue:self.scrollViewArr[index] forKey:@"ScrollDict"];
    [play HandPickListPlay];
    
    [self presentViewController:play animated:YES completion:nil];
}

#pragma mark - TableViewDataSource delegate
//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArr.count;
}
//设置行内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    HandPickCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"HandPickCell" owner:self options:nil][0];
    }
    NSDictionary *dict = self.tableArr[indexPath.row];
    cell.des.text = dict[@"des"];
    cell.rname.text = dict[@"rname"];
    [cell.pic sd_setImageWithURL:[NSURL URLWithString:dict[@"pic"]]];
    return cell;
}

//tableViewCell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HandPickPlay *play = [[HandPickPlay alloc] init];
    [play setValue:self.tableArr[indexPath.row] forKey:@"ScrollDict"];
   
    [play HandPickListPlay];
    [self presentViewController:play animated:YES completion:nil];
    
}



@end
