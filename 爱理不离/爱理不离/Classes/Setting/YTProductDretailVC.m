//
//  YTProductDretailVC.m
//  爱理不离
//
//  Created by ios on 2016/12/20.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTProductDretailVC.h"
#import "UIBarButtonItem+MJ.h"

@interface YTProductDretailVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *textLabelArr;
@property(nonatomic,strong)NSMutableArray *detailelabelArr;
@end

@implementation YTProductDretailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品详情";
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(back)];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alwaysBounceVertical = NO;
    //去除tableView的分割线
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    [self creatFooterView];
    
    
}
#pragma mark - custom
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatFooterView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    
    UIButton *redemptionBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 40, SCREEN_WIDTH - 100, 40)];
    [redemptionBtn setTitle:@"赎回" forState:UIControlStateNormal];
    [redemptionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [redemptionBtn setBackgroundImage:[UIImage resizedImage:@"anniu2"] forState:UIControlStateNormal];
    [redemptionBtn addTarget:self action:@selector(redemptionAction) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:redemptionBtn];
    self.tableView.tableFooterView = footerView;

}

//赎回操作
- (void)redemptionAction{
    
    
    

    NSLog(@"-------赎回操作");

    
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellId"];
    }
    cell.textLabel.textColor = [UIColor lightGrayColor];
    if (indexPath.row == 0) {
        UIImageView *bgView = [[UIImageView alloc]initWithFrame:cell.frame];
        cell.backgroundView = bgView;
        cell.textLabel.text = self.textLabelArr[indexPath.row];
        cell.detailTextLabel.text = self.detailelabelArr[indexPath.row];
    }else{
        
        cell.textLabel.text = self.textLabelArr[indexPath.row];
        cell.detailTextLabel.text = self.detailelabelArr[indexPath.row];
        cell.backgroundColor = YTColor(244, 244, 244);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//设置分割线长度
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

#pragma mark - lazy
- (NSMutableArray *)textLabelArr{
    if (_textLabelArr == nil) {
        _textLabelArr = [@[@"产品名称",@"数量",@"购买时间",@"产品期限",@"已计息天数",@"期限剩余天数",@"购买金额",@"拥有状态"] mutableCopy];
    }
    return _textLabelArr;
}

- (NSMutableArray *)detailelabelArr{
    if (_detailelabelArr == nil) {
        _detailelabelArr = [@[@"name",@"354",@"购买时间",@"产品期限",@"已计息天数",@"期限剩余天数",@"购买金额",@"拥有状态"] mutableCopy];
    }
    return _detailelabelArr;
}
@end
