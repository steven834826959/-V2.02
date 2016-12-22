//
//  YTMoreMyProductVC.m
//  爱理不离
//
//  Created by ios on 2016/12/20.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTMoreMyProductVC.h"
#import "UIBarButtonItem+MJ.h"
#import "YTMyProductCell.h"
#import "YTProductDretailVC.h"
#import "MJRefresh.h"
#import "YTProuctModel.h"
#import "MJExtension.h"

typedef enum {
    RefreshTypeDown,
    RefreshTypeUp
}RefreshType;//枚举名称
static const CGFloat MJDuration = 1.0;
@interface YTMoreMyProductVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *productArr;
@property(nonatomic,assign)int index;
@end

@implementation YTMoreMyProductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多记录";
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(back)];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self creatHeaderView];
    
    
    
    //网络获取刷新数据
    //下拉刷新
    [self downRefresh];
    
    //上拉加载
    [self pullRefresh];
    
}
#pragma mark UITableView + 下拉刷新 默认
- (void)downRefresh
{
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark 下拉刷新数据
- (void)loadNewData
{
    // 1.下拉刷新数据
    self.index = 1;
    [self requestDataWithPageNum:self.index AndType:RefreshTypeDown];
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    __weak UITableView *tableView = self.tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [tableView.mj_header endRefreshing];
        if (!self.tableView.mj_footer.isRefreshing) {
            
            self.tableView.mj_footer.alpha = 0;
        }else{
            
            self.tableView.mj_footer.alpha = 1.0;
        }
    });
}


#pragma mark UITableView + 上拉刷新 默认
- (void)pullRefresh
{
    __weak __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}




#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    // 1.添加数据
    self.index = self.index + 1;
    
    [self requestDataWithPageNum:self.index AndType:RefreshTypeUp];
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    __weak UITableView *tableView = self.tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tableView reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [tableView.mj_footer endRefreshing];
        if (!self.tableView.mj_footer.isRefreshing) {
            
            self.tableView.mj_footer.alpha = 0;
        }else{
            
            self.tableView.mj_footer.alpha = 1.0;
        }
    });
}


- (void)requestDataWithPageNum:(int)index AndType:(RefreshType)type{
    
    [YTHttpTool get:[kDominURL URLStringWithStr:@"/user/order/order_list.get"] parameters:@{@"pageNum":@(index),@"size":@(5)} withCallBack:^(id obj) {
        
        NSString *dataStr = obj[@"data"];
        NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        NSLog(@"------获取服务%@",dataArr);
        
        
        switch (type) {
            case RefreshTypeDown:
                self.productArr = [YTProuctModel mj_objectArrayWithKeyValuesArray:dataArr];
                break;
            case RefreshTypeUp:
            {
                NSMutableArray *newPro = [YTProuctModel mj_objectArrayWithKeyValuesArray:dataArr];
                
                [self.productArr addObjectsFromArray:newPro];
                
            }
                
                break;
                
                
            default:
                break;
        }
    }];
}

#pragma mark - custom
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatHeaderView{
    //展示View
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    UIView *introductionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    
    for (int i = 0; i < 5; i++) {
        UILabel *indructionLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * SCREEN_WIDTH / 5.0f, 0, SCREEN_WIDTH/ 5.0f, 40)];
        indructionLabel.textAlignment = NSTextAlignmentCenter;
        NSArray *inTextArr = @[@"产品",@"数量",@"时间",@"金额",@"状态"];
        indructionLabel.text = inTextArr[i];
        [introductionView addSubview:indructionLabel];
    }
    [bottomView addSubview:introductionView];
    self.tableView.tableHeaderView = bottomView;
}





#pragma mark - tabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.productArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YTProductDretailVC *detail = [[YTProductDretailVC alloc]init];
    
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    YTMyProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"proCell"];
    if (cell == nil) {
        cell = [[YTMyProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"proCell"];
        

    }
    
    return cell;

}



#pragma mark - lazy
- (NSMutableArray *)productArr{

    if (_productArr == nil) {
        _productArr = [NSMutableArray array];
    }
    return _productArr;
}
@end
