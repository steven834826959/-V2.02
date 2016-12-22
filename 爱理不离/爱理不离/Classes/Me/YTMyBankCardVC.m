//
//  YTMyBankCardVC.m
//  爱理不离
//
//  Created by ios on 16/12/7.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTMyBankCardVC.h"
#import "UIBarButtonItem+MJ.h"
#import "YTAddBankCardVC.h"
#import "YTBankCell.h"
#import "YTIdentificationVC.h"
#import "YTUserModel.h"
#import "MJExtension.h"

@interface YTMyBankCardVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *cards;

@property(nonatomic,assign)int isCertification;

@end

@implementation YTMyBankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.title = @"我的银行卡";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"银行卡1" highIcon:@"银行卡1" target:self action:@selector(rightButtonTapped)];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
    
    [self getMyBankCardInfo];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)
                      ];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //去除tableView的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];


}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //获取个人信息
    [YTHttpTool get:[kDominURL URLStringWithStr:@"/user/user_info.get"] parameters:nil withCallBack:^(id obj) {
        if ([[obj objectForKey:@"code"] intValue] == 0) {
            //获取信息成功
            NSString *jsonStr = obj[@"data"];
            NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            //字典转模型
            YTUserModel *userInfo = [YTUserModel mj_objectWithKeyValues:dicData];
            self.isCertification = userInfo.isCertification;
            
            //将文件写入内存
            NSString *file = [NSTemporaryDirectory() stringByAppendingPathComponent:@"userInfo.plist"];
            // 归档
            [NSKeyedArchiver archiveRootObject: userInfo toFile:file];
        }
    }];

    //刷新tableView
    
    [self.tableView reloadData];
}

#pragma mark - custom
- (void)rightButtonTapped{
    //判断是否认证账户
    if (self.isCertification) {
        //再判断银行卡个数
        if (self.cards.count == 1) {
            [self presentViewController:[AlertTool alertWithTitle:@"提示" Message:@"只能绑定一张银行卡" actionTitle:@"好" andStyle:0] animated:YES completion:nil];
        }else{
            YTAddBankCardVC *add = [[YTAddBankCardVC alloc]init];
            [self.navigationController pushViewController:add animated:YES];
        }

    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"账户还没有实名认证！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            YTIdentificationVC *renzhen = [[YTIdentificationVC alloc]init];
            
            [self.navigationController pushViewController:renzhen animated:YES];
            
        }];
    
        [alert addAction:action1];
        [alert addAction:action2];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }

}

- (void)leftButtonTapped{
    
    if (self.navigationController.viewControllers.count == 2) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //去掉透明后导航栏下边的黑边
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)getMyBankCardInfo{
    //发送网络请求获取银行卡信息
    
    
    

}


#pragma mark - tabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)   section{
    return  1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YTBankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bankCell"];
    if (cell == nil) {
        cell = [[YTBankCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bankCell"];
    }
    cell.bankNameLabel.text = @"中国银行";
    cell.bankNumLabel.text = @"******2780";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 170;
}
#pragma mark  - lazy
- (NSMutableArray *)cards{
    if (_cards == nil) {
        _cards = [NSMutableArray array];
    }
    return _cards;
}

@end
