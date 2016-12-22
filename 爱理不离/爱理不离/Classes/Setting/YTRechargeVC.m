//
//  YTRechargeVC.m
//  爱理不离
//
//  Created by ios on 16/12/13.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTRechargeVC.h"
#import "UIBarButtonItem+MJ.h"
#import "AlertTool.h"
#import "YTMyBankCardVC.h"
@interface YTRechargeVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIButton *nextBtn;
@end

@implementation YTRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    
    self.title = @"充值";
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];

    [self initView];

}

#pragma mark - custom
- (void)leftButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.alwaysBounceVertical = NO;
    [self.view addSubview:self.tableView];
}

- (void)tapAction{
  [self.view endEditing:YES];
}

- (void)next{
    
    if (self.balanceTF.text.length == 0) {
        [self presentViewController:[AlertTool alertWithTitle:@"提示" Message:@"请输入金额" actionTitle:@"好" andStyle:1] animated:YES completion:nil];
    }else{
    
    
    }
    
    NSLog(@"提现控制器");


}



#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        
    }

    if (indexPath.section == 0) {
        cell.textLabel.text = @"银行卡";
        [cell.detailTextLabel sizeToFit];
        cell.detailTextLabel.text = @"******1234";
        
    }else if (indexPath.section == 1){
        cell.textLabel.text = @"账户可用余额";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f元",self.myBalnce];
    }else if (indexPath.section == 2){
        UITextField *balanceTF = [cell.contentView viewWithTag:250];
        if (balanceTF == nil) {
            balanceTF = [[UITextField alloc]initWithFrame:cell.frame];
            balanceTF.tag = 250;
            balanceTF.keyboardType = UIKeyboardTypeNumberPad;
            balanceTF.placeholder = @"请输入充值金额";
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, cell.frame.size.height)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"金额";
            balanceTF.leftViewMode = UITextFieldViewModeAlways;
            balanceTF.leftView = label;
            self.balanceTF = balanceTF;
            [cell.contentView addSubview:balanceTF];
            
        }
    }else if(indexPath.section == 3){
        UIButton *next = [cell.contentView viewWithTag:251];
        if (next == nil) {
            next = [[UIButton alloc]initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 100, cell.frame.size.height)];
            next.layer.cornerRadius = 5;
            next.layer.masksToBounds = YES;
            next.backgroundColor = [UIColor redColor];
            next.font = [UIFont systemFontOfSize:20];
            [next setTitle:@"下一步" forState:UIControlStateNormal];
            [next addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
            self.nextBtn = next;
            [cell.contentView addSubview:next];
        }
        cell.backgroundColor = [UIColor clearColor];
        
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        //跳转到选择银行卡页面
        
 
    }
}



@end
