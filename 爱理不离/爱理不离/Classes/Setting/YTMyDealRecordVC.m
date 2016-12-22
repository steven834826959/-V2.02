//
//  YTMyDealRecordVC.m
//  爱理不离
//
//  Created by ios on 16/12/12.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTMyDealRecordVC.h"
#import "UIBarButtonItem+MJ.h"
#import "YTRecodModel.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "YTRecodModel.h"
#import "YTRecordCell.h"


typedef enum {
    RefreshTypeDown,
    RefreshTypeUp
}RefreshType;//枚举名称
static const CGFloat MJDuration = 1.0;
@interface YTMyDealRecordVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *records;
@property(nonatomic,strong)NSArray *headTitles;
@property(nonatomic,assign)int index;


@end

@implementation YTMyDealRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易记录";
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
    //初始化tabelView;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        //去除tableView的分割线
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView];
        
        [self creatHeaderView];
    
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
    self.index = 1;
    // 1.下拉刷新数据
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
    
    [YTHttpTool post:[kDominURL URLStringWithStr:@"/user/my_recharge_record_list.get"] parameters:@{@"pageNum":@(index),@"size":@(20)} withCallBack:^(id obj) {
        
        NSString *dataStr = obj[@"data"];
        NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        NSLog(@"------获取服务%@",dataArr);
        
        
        switch (type) {
            case RefreshTypeDown:
                self.records = [YTRecodModel mj_objectArrayWithKeyValuesArray:dataArr];
                break;
            case RefreshTypeUp:
            {
                NSMutableArray *NewSevices = [YTRecodModel mj_objectArrayWithKeyValuesArray:dataArr];
                
                [self.records addObjectsFromArray:NewSevices];
                
            }
                
                break;
                
                
            default:
                break;
        }
    }];
}

#pragma mark - custom
- (void)initNoRecordView{
    UILabel *remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 50)];
    remarkLabel.textAlignment = NSTextAlignmentCenter;
    remarkLabel.textColor = [UIColor whiteColor];
    remarkLabel.text = @"您还没有交易记录";
    remarkLabel.font = [UIFont systemFontOfSize:25];

    [self.view addSubview:remarkLabel];

}

- (void)leftButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i * SCREEN_WIDTH / 3.0f, 0, SCREEN_WIDTH / 3.0f, 40)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = self.headTitles[i];
        [headerView addSubview:label];
        label.backgroundColor = [UIColor yellowColor];
    }
    self.tableView.tableHeaderView = headerView;
}



#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.records.count;
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    YTRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recordCell"];
//    if (cell == nil) {
//        cell = [[YTRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recordCell"];
//        
//        cell.record = self.records[indexPath.row];
//    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"111111111111";
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark -lazy
- (NSMutableArray *)records{
    if (_records == nil) {
        _records = [NSMutableArray array];
    }
    return _records;
}

- (NSArray *)headTitles{
    if (_headTitles == nil) {
        _headTitles = @[@"交易类型",@"金额",@"日期"];
    }
    return _headTitles;
}
@end
