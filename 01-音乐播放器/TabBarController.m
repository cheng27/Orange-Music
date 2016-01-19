//
//  TabBarController.m
//  02-音乐播放器
//
//  Created by qingyun on 15/12/29.
//  Copyright © 2015年 阿六. All rights reserved.
//

#import "TabBarController.h"
#import "Header.h"
#import "MyPlayer.h"
#import <UIImageView+WebCache.h>
#import "UIView+FrameExtension.h"
#import <AFHTTPSessionManager.h>
#import "HandPickPlay.h"

@interface TabBarController ()
@property (nonatomic,strong) UIButton *selectedBtn;
@property (nonatomic,assign) BOOL isCollect;
@property (nonatomic,strong) NSMutableArray *cellDataArr;

@end

@implementation TabBarController

+ (TabBarController *)shareMyTabBar
{
    static TabBarController *myTabBar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myTabBar = [[self alloc] init];
    });
    return myTabBar;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //删除原有的tabBar
    CGRect TabFrame = self.tabBar.frame;
    [self.tabBar removeFromSuperview];
    
    //添加自己创建的tabBar
    self.bottomView = [[UIView alloc] init];
    _bottomView.frame = TabFrame;
    _bottomView.backgroundColor = [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1];
    [self.view addSubview:_bottomView];
    //添加自定义的tabBar
    [self addBtnAndLabel];
    
    
}

#pragma mark - 添加子视图
//添加自定义的tabBar的图片和名字
- (void)addBtnAndLabel
{
    for (int i = 0; i < 4; i ++) {
        CGFloat x = i * _bottomView.frame.size.width / 4;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, kBtnFrame, _bottomView.frame.size.height)];
        NSString *imageName = [NSString stringWithFormat:@"TabBar%d",i+1];
        NSString *selImage = [NSString stringWithFormat:@"TabBarSel%d",i+1];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selImage] forState:UIControlStateSelected];
        btn.imageEdgeInsets = UIEdgeInsetsMake(-9, 0, 0, 0);
        [_bottomView addSubview:btn];
        //设置按钮的标记, 方便来索引当前的按钮,并跳转到相应的视图
        btn.tag = i + 100;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        //设置刚进入时，第一个按钮为选中状态
        if (i == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
            self.selectedBtn.backgroundColor = [UIColor lightGrayColor];
        }
    }
    
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, _bottomView.frame.size.height - 15, kBtnFrame, 15)];
        NSArray *array = @[@"精选",@"全部",@"歌单",@"我的"];
        label.text = array[i];
        label.font = [UIFont fontWithName:@"迷你简魏碑" size:14];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [[self.bottomView viewWithTag:i + 100]addSubview:label];
    }
}


#pragma mark -Btn点击事件
//tabBar上边的btn的点击事件
- (void)clickBtn:(UIButton *)btn
{
    //1.先将之前选中的按钮设置为未选中
    self.selectedBtn.selected = NO;
    //2.再将当前按钮设置为选中
    btn.selected = YES;
    //3.最后把当前按钮赋值给之前选中的按钮
    self.selectedBtn = btn;
    //4.跳转到相应的视图控制器 (通过selectIndex参数来设置选中了那个控制器)
    self.selectedIndex = btn.tag - 100;
    
    if (self.selectedIndex == 0) {
        [self.bottomView viewWithTag:100].backgroundColor = [UIColor lightGrayColor];
        [self.bottomView viewWithTag:101].backgroundColor = [UIColor clearColor];
        [self.bottomView viewWithTag:102].backgroundColor = [UIColor clearColor];
        [self.bottomView viewWithTag:103].backgroundColor = [UIColor clearColor];
    }else if (self.selectedIndex == 1)
    {
        [self.bottomView viewWithTag:101].backgroundColor = [UIColor lightGrayColor];
        [self.bottomView viewWithTag:100].backgroundColor = [UIColor clearColor];
        [self.bottomView viewWithTag:102].backgroundColor = [UIColor clearColor];
        [self.bottomView viewWithTag:103].backgroundColor = [UIColor clearColor];
    }else if (self.selectedIndex == 2)
    {
        [self.bottomView viewWithTag:102].backgroundColor = [UIColor lightGrayColor];
        [self.bottomView viewWithTag:100].backgroundColor = [UIColor clearColor];
        [self.bottomView viewWithTag:101].backgroundColor = [UIColor clearColor];
        [self.bottomView viewWithTag:103].backgroundColor = [UIColor clearColor];
    }else if (self.selectedIndex == 3)
    {
        [self.bottomView viewWithTag:103].backgroundColor = [UIColor lightGrayColor];
        [self.bottomView viewWithTag:100].backgroundColor = [UIColor clearColor];
        [self.bottomView viewWithTag:101].backgroundColor = [UIColor clearColor];
        [self.bottomView viewWithTag:102].backgroundColor = [UIColor clearColor];
    }
    
}

@end
