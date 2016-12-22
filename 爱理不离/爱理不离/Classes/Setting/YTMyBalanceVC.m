//
//  YTMyBalanceVC.m
//  爱理不离
//
//  Created by Steven on 2016/12/7.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTMyBalanceVC.h"
#import "UIBarButtonItem+MJ.h"
#import "YTMyDealRecordVC.h"
#import "YTRechargeVC.h"
#import "YTDrawVC.h"
@interface YTMyBalanceVC ()
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIImageView *baseView;

@property(nonatomic,assign)float myBalance;

@end

@implementation YTMyBalanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户余额";
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    
    
    
    //获取账户余额信息
    [self getMyBalance];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
    
    //右上角交易记录
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"交易记录" style:UIBarButtonItemStylePlain target:self action:@selector(buyRecord)];
    //创建余额视图
    [self initTitleView];
    //创建充值提现按钮
    [self creatBtns];
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

- (void)buyRecord{
    YTMyDealRecordVC *record = [[YTMyDealRecordVC alloc]init];
    [self.navigationController pushViewController:record animated:YES];
}

- (void)initTitleView{
    self.baseView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH - 20, 120)];
    UIImage *baseImg = [UIImage imageNamed:@"确认密码"];
    self.baseView.userInteractionEnabled = YES;
    self.baseView.image = [baseImg resizableImageWithCapInsets:UIEdgeInsetsMake(60, 60, 60, 60) resizingMode:UIImageResizingModeStretch];
    [self.view addSubview:self.baseView];
    
   //我的余额文字
    UILabel *myBalance = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.baseView.frame.size.width, 30)];
    myBalance.textAlignment = NSTextAlignmentCenter;
    myBalance.font = [UIFont systemFontOfSize:14];
    myBalance.text = @"我的余额";
    myBalance.textColor = [UIColor lightGrayColor];
    [self.baseView addSubview:myBalance];
    
    //创建余额显示
    UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(myBalance.frame), self.baseView.frame.size.width, self.baseView.frame.size.height - myBalance.frame.size.height - 30)];
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    balanceLabel.font = [UIFont systemFontOfSize:30];
    balanceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.myBalance];
    balanceLabel.textColor = [UIColor lightGrayColor];
    [self.baseView addSubview:balanceLabel];
    

}
- (void)creatBtns{
    UIButton *rechargeBtn = [[UIButton alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(self.baseView.frame) + 30, SCREEN_WIDTH - 160, 45)];
    UIButton *withDrawBtn = [[UIButton alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(rechargeBtn.frame) + 15 , SCREEN_WIDTH - 160, 45)];
    
    [rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    [withDrawBtn setTitle:@"提现" forState:UIControlStateNormal];
    
    [rechargeBtn setBackgroundImage:[UIImage imageNamed:@"服务兑换"] forState:UIControlStateNormal];
    [withDrawBtn setBackgroundImage:[UIImage imageNamed:@"anniu2"] forState:UIControlStateNormal];


    [rechargeBtn addTarget:self action:@selector(recharge) forControlEvents:UIControlEventTouchUpInside];
    [withDrawBtn addTarget:self action:@selector(withDraw) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:rechargeBtn];
    [self.view addSubview:withDrawBtn];
}
//充值
- (void)recharge{
    
    YTRechargeVC *recharge = [[YTRechargeVC alloc]init];
    recharge.myBalnce = self.myBalance;
    [self.navigationController pushViewController:recharge animated:YES];

}
- (void)withDraw{
    YTDrawVC *draw = [[YTDrawVC alloc]init];
    draw.myBalnce = self.myBalance;
    [self.navigationController pushViewController:draw animated:YES];
}

- (void)getMyBalance{
    self.myBalance = 8888;
}

@end
