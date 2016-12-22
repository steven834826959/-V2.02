//
//  YTMyProductVC.m
//  爱理不离
//
//  Created by ypp on 16/12/8.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTMyProductVC.h"
#import "UIBarButtonItem+MJ.h"
#import "YTMyProductModel.h"
#import "YTMyProductCell.h"
#import "YTHeaderView.h"
#import "YTProductDretailVC.h"
#import "YTMoreMyProductVC.h"
#import "MJExtension.h"

@interface YTMyProductVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *myProArr;


@end

@implementation YTMyProductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的产品";
    //获取购买产品列表
//    [self getMyProduct];
    
    
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(back)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStyleDone target:self action:@selector(moreAvtion)];
    
    
    YTHeaderView *header = [[YTHeaderView alloc]initWithMyScore:100 procutCountArr:@[@1,@1,@1]];
    
    [self.view addSubview:header];
    //初始化tableView
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 260, self.view.frame.size.width, self.view.frame.size.height)
                      ];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [_tableView  setSeparatorColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.tableView];
}

- (void)back{
    if (self.navigationController.viewControllers.count == 2) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //去掉透明后导航栏下边的黑边
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreAvtion{
    YTMoreMyProductVC *more = [[YTMoreMyProductVC alloc]init];
    [self.navigationController pushViewController:more animated:YES];
}


- (void)getMyProduct{
    [YTHttpTool get:[kDominURL URLStringWithStr:@"/user/order/order_list.get"] parameters:@{@"pageNum":@(1),@"size":@(5)} withCallBack:^(id obj) {
        
        NSString *dataStr = obj[@"data"];
        NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        NSLog(@"------获取服务%@",dataArr);
 
            self.myProArr = [YTMyProductModel mj_objectArrayWithKeyValuesArray:dataArr];
        }];
}



#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.myProArr.count;
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    YTMyProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myPro"];
//    
//    if (cell == nil) {
//        cell = [[YTMyProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myPro"];
//    
//
//        cell.productModel = self.myProArr[indexPath.row];
//    
//   
//    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"1";
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YTProductDretailVC *detail = [[YTProductDretailVC alloc]init];
    
    [self.navigationController pushViewController:detail animated:YES];
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
- (NSMutableArray *)myProArr{
    if (_myProArr == nil) {
        _myProArr = [NSMutableArray array];
    }
    return _myProArr;
}







@end
