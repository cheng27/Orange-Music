//
//  Demo.m
//  01-音乐播放器
//
//  Created by qingyun on 16/1/6.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "HandPickPlay.h"
#import "Header.h"





@interface HandPickPlay ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *playView;
@property (nonatomic,strong) NSMutableArray *cellDataArr;
@property (nonatomic,strong) NSDictionary *ScrollDict;


@end

@implementation HandPickPlay

#pragma mark - 懒加载

- (NSMutableArray *)cellDataArr
{
    if (_cellDataArr == nil) {
        _cellDataArr = [NSMutableArray array];
    }
    return _cellDataArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"-----------%@",_ScrollDict);
    
    //添加播放界面
    [self addPlayView];
    //在播放界面上添加子视图
    [self addSubViews];
    //给每个控件添加约束
    [self updateViewConstraints];
    self.volumeSlide.value = 0.3;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didMusicFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)addPlayView
{
    self.playView = [[UIView alloc]initWithFrame:self.view.frame];
    self.playView.backgroundColor = [UIColor colorWithRed:214/255.0 green:254/255.0 blue:255/255.0 alpha:1];
    
    [self.view addSubview:self.playView];
}

//在播放界面上边添加子视图
- (void)addSubViews
{
    //返回按钮
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(kSpace *2, kSpace*5, kSpace*3, kSpace * 3);
    [self.backBtn setImage:[UIImage imageNamed:@"quit"] forState:UIControlStateNormal];
    [self.playView addSubview:self.backBtn];
    [self.backBtn addTarget:self action:@selector(quitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //中间的图片
    self.middleImage = [[UIImageView alloc] init];
    [self.middleImage sd_setImageWithURL:[NSURL URLWithString:_ScrollDict[@"pic"]]];
    [self.playView addSubview:self.middleImage];
    [self.playView sendSubviewToBack:self.middleImage];
    
    //歌曲的进度
    self.songSlide = [[UISlider alloc] init];
    [self.songSlide setThumbImage:[UIImage imageNamed:@"dian"] forState:UIControlStateNormal];
    [self.songSlide addTarget:self action:@selector(changeValues:) forControlEvents:UIControlEventValueChanged];
    [self.playView addSubview:self.songSlide];
    
    //当前时间
    self.currentTime = [[UILabel alloc] init];
    self.currentTime.text = @"00:00";
    [self.playView addSubview:self.currentTime];
    //歌曲的总时长
    self.durationTime = [[UILabel alloc] init];
    self.durationTime.text = @"00:00";
    [self.playView addSubview:self.durationTime];
    
    //音乐名字
    self.musicName = [[UILabel alloc] init];
    self.musicName.frame = CGRectMake(kSpace*8, self.middleImage.frame.size.height + 50, kSpace * 19, kSpace * 3);
    self.musicName.text = _ScrollDict[@"rname"];
    self.musicName.textAlignment = NSTextAlignmentCenter;
    self.musicName.font = [UIFont fontWithName:@"迷你简魏碑" size:15];
    [self.playView addSubview:self.musicName];
    //专辑名字
    self.special = [[UILabel alloc] init];
    self.special.text = _ScrollDict[@"des"];
    self.special.textAlignment = NSTextAlignmentCenter;
    self.special.font = [UIFont fontWithName:@"迷你简魏碑" size:14];
    [self.playView addSubview:self.special];
    
    //音量按钮
    self.volume = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.volume setImage:[UIImage imageNamed:@"音量"] forState:UIControlStateNormal];
    [self.volume addTarget:self action:@selector(collectMusic:) forControlEvents:UIControlEventTouchUpInside];
    [self.playView addSubview:self.volume];
    //音量滑块
    _volumeSlide = [[UISlider alloc] init];
    [_volumeSlide addTarget:self action:@selector(changeVolume:) forControlEvents:UIControlEventTouchDragInside];
    [self.playView addSubview:_volumeSlide];
    
    //歌单按钮
    self.musicList = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.musicList setImage:[UIImage imageNamed:@"歌单"] forState:UIControlStateNormal];
    [self.musicList addTarget:self action:@selector(musicListAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playView addSubview:self.musicList];
    
    //上一首
    self.previous = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.previous setImage:[UIImage imageNamed:@"上一首"] forState:UIControlStateNormal];
    [self.previous addTarget:self action:@selector(previousAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playView addSubview:self.previous];
    //下一首
    self.next = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.next setImage:[UIImage imageNamed:@"下一首"] forState:UIControlStateNormal];
    [self.next addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playView addSubview:self.next];
    //播放或暂停
    self.playOrPause = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playOrPause setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    [self.playOrPause addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [self.playView addSubview:self.playOrPause];
    
}
//给每个控件添加约束
- (void)updateViewConstraints
{
    [_playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    [_middleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-self.view.frame.size.height/2+30);
    }];
    [_songSlide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(_middleImage.mas_bottom);
    }];
    [_currentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(_durationTime.mas_right).with.offset(-200);
        make.top.equalTo(_songSlide.mas_bottom).with.offset(1);
    }];
    [_durationTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-10);
        make.centerY.equalTo(_currentTime);
        make.bottom.equalTo(_musicName.mas_top).with.offset(-10);
    }];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.top.equalTo(self.view).with.offset(50);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [_musicName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(80);
        make.top.equalTo(_currentTime.mas_bottom).with.offset(8);
        make.bottom.equalTo(_special.mas_top).with.offset(-10);
        make.centerX.equalTo(self.view);
    }];
    [_special mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(120);
        make.centerX.equalTo(_musicName);
    }];
    [_previous mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(25);
        make.top.equalTo(_special.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(-40);
        make.right.equalTo(_playOrPause.mas_left).with.offset(-35);
    }];
    [_playOrPause mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_previous.mas_right).with.offset(25);
        make.right.equalTo(_next.mas_left).with.offset(-25);
        make.centerY.equalTo(_previous);
        make.centerX.equalTo(self.view);
    }];
    [_next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_previous);
        make.right.equalTo(self.view).with.offset(-25);
    }];
    [_volume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(10);
        make.top.equalTo(_previous.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(-15);
    }];
    [_volumeSlide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_volume.mas_right).with.offset(5);
        make.centerY.equalTo(_volume);
        make.right.equalTo(_musicList.mas_left).with.offset(-5);
    }];
    [_musicList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_volume);
        make.right.equalTo(self.view).with.offset(-10);
    }];
    [super updateViewConstraints];
    
}


//添加歌曲列表的tableView
- (void)addMusicListTable
{
    self.musicListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.playView.height + 40, self.playView.width, self.playView.height/3*2-40) style:UITableViewStylePlain];
    self.musicListTable.alpha = 0.7;
    self.musicListTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.playView addSubview:self.musicListTable];
    self.musicListTable.hidden = YES;
    self.musicListTable.delegate = self;
    self.musicListTable.dataSource = self;
    
    self.backMusicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backMusicButton.frame = CGRectMake(self.playView.width/6*5, self.playView.height, self.playView.width/6, 40);
    [self.backMusicButton setImage:[UIImage imageNamed:@"MusicTabBack"] forState:UIControlStateNormal];
    self.backMusicButton.backgroundColor = [UIColor whiteColor];
    self.backMusicButton.alpha = 0.8;
    [self.backMusicButton addTarget:self action:@selector(BackMusicList:) forControlEvents:UIControlEventTouchUpInside];
    self.backMusicButton.hidden = YES;
    [self.playView addSubview:self.backMusicButton];
    
}


//退出播放界面
- (void)quitAction:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//歌曲进度的更改
- (void)changeValues:(UISlider *)slide
{
    if (self.playOrPause.tag == 1) {
        CGFloat t = slide.value * CMTimeGetSeconds(self.playerItem.duration);
        [[MyPlayer sharePlayer].player seekToTime:CMTimeMake(t, 1) completionHandler:^(BOOL finished) {
            [[MyPlayer sharePlayer].player pause];
        }];
    }else
    {
        CGFloat t = slide.value *CMTimeGetSeconds(self.playerItem.duration);
        [[MyPlayer sharePlayer].player seekToTime:CMTimeMake(t, 1) completionHandler:^(BOOL finished) {
            [[MyPlayer sharePlayer].player play];
        }];
    }
}
//声音大小的调整
- (void)changeVolume:(UISlider *)slide
{
    [self musicVolume:slide.value];
}
- (void)musicVolume:(float)value
{
    [MyPlayer sharePlayer].player.volume = value;
}
//歌单列表
- (void)musicListAction:(UIButton *)btn
{
    NSLog(@"歌单列表!");
    if (self.cellDataArr.count == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"该专辑只有当前这一首歌!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else
    {
        [self addMusicListTable];
        [self appearTheTable];
        
    }
}
- (void)BackMusicList:(UIButton *)btn
{
    [self dismissTheTable];
}
//上一首
- (void)previousAction:(UIButton *)btn
{
    NSLog(@"上一首");
    if (self.cellDataArr.count == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"当前已经是第一首!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
//下一首
- (void)nextAction:(UIButton *)btn
{
    NSLog(@"下一首");
    if (self.cellDataArr.count == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"当前已经是最后一首!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
//播放或者暂停
- (void)playOrPause:(UIButton *)btn
{
    NSLog(@"播放");
    if (btn.tag) {
        btn.tag = 0;
        [btn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        [[MyPlayer sharePlayer].player play];
    }else
    {
        btn.tag = 1;
        [btn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
        [[MyPlayer sharePlayer].player pause];
    }
}

//当前歌曲播放完成，自动播放下一首歌
- (void)didMusicFinished
{
    if (self.cellDataArr == 0) {
        self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.cellDataArr[0][@"mp3PlayUrl"]]];
        [[MyPlayer sharePlayer].player replaceCurrentItemWithPlayerItem:self.playerItem];
        self.musicName.text = self.cellDataArr[0][@"audioName"];
        self.special.text = self.cellDataArr[0][@"albumName"];
        [self HandPickListPlay];
    }else{
        [self nextAction:nil];
    }
}


#pragma mark - 播放界面
    
- (void)appearThePlayer
{
    //1.禁用整个app的点击事件
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    window.userInteractionEnabled = NO;
    self.playView.hidden = NO;
    //2.动画显示
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.playView.frame;
        frame.origin.y = 0;
        self.playView.frame = frame;
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
    }];
}

- (void)dismissThePlayer
{
    //1.禁用整个app的点击事件
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    window.userInteractionEnabled = NO;
    //2.动画显示
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.playView.frame;
        frame.origin.y = self.view.frame.size.height;
        self.playView.frame = frame;
    } completion:^(BOOL finished) {
        self.playView.hidden = YES;
        window.userInteractionEnabled = YES;
    }];
}

- (void)appearTheTable
{
    //1.禁用整个app的点击事件
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    window.userInteractionEnabled = NO;
    self.backMusicButton.hidden = NO;
    self.musicListTable.hidden = NO;
    
    //2.动画显示
    [UIView animateWithDuration:0.5 animations:^{
        self.backMusicButton.y = self.playView.height / 3;
        self.musicListTable.y = self.playView.height/3+40;
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
    }];
}

- (void)dismissTheTable
{
    //1.禁用整个app的点击事件
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    window.userInteractionEnabled = NO;
    
    //2.动画显示
    [UIView animateWithDuration:0.5 animations:^{
        self.backMusicButton.y = self.playView.height;
        self.musicListTable.y = self.playView.height + 40;
    } completion:^(BOOL finished) {
        self.backMusicButton.hidden = YES;
        self.musicListTable.hidden = YES;
        window.userInteractionEnabled = YES;
    }];
}


//进入播放界面
- (void)HandPickListPlay
{
    
    
    self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:_ScrollDict[@"mp3PlayUrl"]]];
    [[MyPlayer sharePlayer].player replaceCurrentItemWithPlayerItem:self.playerItem];
    
    self.songSlide.value = 0;
    self.playOrPause.tag = 0;
    [self.playOrPause setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    [[MyPlayer sharePlayer].player play];
    
    [[MyPlayer sharePlayer].player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:(dispatch_get_main_queue()) usingBlock:^(CMTime time) {
        CGFloat currentTime = CMTimeGetSeconds(time);
        CGFloat totalTime = CMTimeGetSeconds(self.playerItem.duration);
        self.currentTime.text = [NSString stringWithFormat:@"%02d:%02d",(int)currentTime/60,(int)currentTime%60];
        self.durationTime.text = [NSString stringWithFormat:@"%02d:%02d",(int)totalTime/60,(int)totalTime%60];
        self.songSlide.value = currentTime/totalTime;
    }];

}

#pragma mark - musicListTable delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellDataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}








@end
