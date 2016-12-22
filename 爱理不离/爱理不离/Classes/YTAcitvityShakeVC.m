//
//  YTAcitvityShakeVC.m
//  爱理不离
//
//  Created by ios on 2016/12/20.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTAcitvityShakeVC.h"
#import "UIBarButtonItem+MJ.h"
#import <AVFoundation/AVFoundation.h>
#import "LZAudioTool.h"
#import "UIImage+GIF.h"
#import "SUTableView.h"


@interface YTAcitvityShakeVC ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerTransitioningDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *infoArr;
@property(nonatomic,strong)NSTimer *timer;


@property(nonatomic,strong)UIImageView *gifView;

@property(nonatomic,strong)UIImageView *redEnvelope;
@property(nonatomic,strong)UIView *popView;

@property(nonatomic,assign)NSInteger currentLine;

@end

@implementation YTAcitvityShakeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"摇钱树";
    self.currentLine = 0;
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
    
    
    self.tableView = [[SUTableView alloc]initWithFrame:CGRectMake(0,100, self.view.frame.size.width, 200)
                      ];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //去除tableView的分割线
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    
    self.gifView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 320, SCREEN_WIDTH, 200)];
    
    [self.view addSubview:self.gifView];
    
    
    NSTimer *rollTimer = [NSTimer scheduledTimerWithTimeInterval:.5f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        
    [rollTimer fire];

    
}

#pragma mark  - custom
- (void)leftButtonTapped{
    if (self.navigationController.viewControllers.count == 2) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //去掉透明后导航栏下边的黑边
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        
        
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateTime{
  
    
    
    self.currentLine = self.currentLine + 1;
    
//    if (self.currentLine > self.infoArr.count) {
//        self.currentLine = 0;
//    }

    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentLine inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"ActivityCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
   
    cell.textLabel.text = [self.infoArr[indexPath.row] objectForKey:@"num"];
    cell.detailTextLabel.text = [self.infoArr[indexPath.row] objectForKey:@"moeny"];
    return cell;

}
#pragma mark - 开始摇晃就会调用
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    //播放摇晃声音
    [LZAudioTool playMusic:@"1.mp3"];
    //开始摇晃 设置动画
    NSLog(@"----------开始播放动画");
    NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"46477587_4.gif" ofType:nil];
    
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    
    
    //第一种方法使用imageData加载
    self.gifView.image = [UIImage sd_animatedGIFWithData:imageData];
    //设置定时器
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(backgroundThreadFire) userInfo:nil repeats:NO];
        
        [self.timer fire];
        
    });
    
}

- (void)backgroundThreadFire{
    //定时器结束,弹出红包菜单
    self.popView = [[UIView alloc]initWithFrame:self.view.frame];
    
    self.popView.backgroundColor = [UIColor colorWithWhite:.3 alpha:.6];
    self.popView.alpha = 0;
    [self.view addSubview:self.popView];
    //红包View
    self.redEnvelope = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 350)];
    self.redEnvelope.center = self.view.center;
    
    //中奖Label
    
    
    
    
    
    //领取按钮
    UIButton *getBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, self.redEnvelope.frame.size.height - 50, self.redEnvelope.frame.size.width - 20, 40)];
    
    [getBtn setTitle:@"立即领取" forState:UIControlStateNormal];
    [self.redEnvelope addSubview:getBtn];
    
    [_popView addSubview:self.redEnvelope];
    
    
    [UIView animateWithDuration:.5 animations:^{
        _popView.alpha = 1.0f;
    }];
    
 
   
}


#pragma mark - 摇晃结束就会调用
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //摇晃结束
    //结束动画，弹出红包
    NSLog(@"--------结束动画");
    
    
    
    
  
}

#pragma mark - 摇晃被打断就会调用
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //摇晃被打断
}


#pragma mark - lzay
- (NSMutableArray *)infoArr{

    if (_infoArr == nil) {
        _infoArr = [@[@{@"num":@"110",@"moeny":@"2"},@{@"num":@"111",@"moeny":@"2"},@{@"num":@"112",@"moeny":@"2"},@{@"num":@"113",@"moeny":@"2"},@{@"num":@"114",@"moeny":@"2"},@{@"num":@"115",@"moeny":@"2"},@{@"num":@"116",@"moeny":@"2"},@{@"num":@"117",@"moeny":@"2"},@{@"num":@"118",@"moeny":@"2"},@{@"num":@"119",@"moeny":@"2"},@{@"num":@"120",@"moeny":@"2"},@{@"num":@"121",@"moeny":@"2"},@{@"num":@"122",@"moeny":@"2"},@{@"num":@"123",@"moeny":@"2"},@{@"num":@"124",@"moeny":@"2"},@{@"num":@"125",@"moeny":@"2"},@{@"num":@"126",@"moeny":@"2"},@{@"num":@"127",@"moeny":@"2"},@{@"num":@"128",@"moeny":@"2"},@{@"num":@"129",@"moeny":@"2"}] mutableCopy];
    }
    return _infoArr;
}

@end
