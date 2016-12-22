//
//  YTSocreChangeVC.m
//  爱理不离
//
//  Created by ios on 16/12/13.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTSocreChangeVC.h"
#import "UIBarButtonItem+MJ.h"
#import "YTSocreChangeVC.h"
#import "YTScoreChangeCell.h"
#import "MJRefresh.h"

typedef enum {
    RefreshTypeDown,
    RefreshTypeUp
}RefreshType;//枚举名称
static const CGFloat MJDuration = 1.0;

@interface YTSocreChangeVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UISegmentedControl *segment;

@property(nonatomic,strong)NSMutableArray *changedArr;
@property(nonatomic,strong)NSArray *titleStr;
@property(nonatomic,assign)int index;
@end

@implementation YTSocreChangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已兑换";
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
    
    
    //设置分段选择器
    self.segment = [[UISegmentedControl alloc]initWithItems:@[@"未使用",@"已使用"]];
    self.segment.frame = CGRectMake(0, 0, 100, 30);
    
    self.segment.selectedSegmentIndex = 0;
   
    self.segment.tintColor = [UIColor whiteColor];
    
    [self.segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = self.segment;
    
    [self initTableView];

    //加载刷新控件
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
   [self requsstWihtPageNum:self.index andRefreshType:RefreshTypeDown andDealType:self.segment.selectedSegmentIndex];
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
    
    self.index += 1;
    
    [self requsstWihtPageNum:self.index andRefreshType:RefreshTypeUp andDealType:self.segment.selectedSegmentIndex];
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


- (void)requsstWihtPageNum:(int)index andRefreshType:(RefreshType)type andDealType:(NSInteger)isUse{

    [YTHttpTool post:[kDominURL URLStringWithStr:@"/user/my_exchange_list.get"] parameters:@{@"pageNum":@(index),@"size":@(20)} withCallBack:^(id obj) {
        NSString *dataStr = obj[@"data"];
        
        NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *exchanges = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        switch (type) {
            case RefreshTypeDown:
                self.changedArr = [YTScoreChangeModel mj_objectArrayWithKeyValuesArray:exchanges];
                break;
            case RefreshTypeUp:
            {
                NSMutableArray *NewChanges = [YTScoreChangeModel mj_objectArrayWithKeyValuesArray:exchanges];
                
                [self.changedArr addObjectsFromArray:NewChanges];
                
            }
                
                break;
                
                
            default:
                break;
        }

    }];
}






#pragma mark - custom
- (void)leftButtonTapped{
    
    if (self.navigationController.viewControllers.count == 2) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //去掉透明后导航栏下边的黑边
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    //去除tableView的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self initTableHeaderView];
    
}

- (void)change:(UISegmentedControl *)sender{
    [self downRefresh];
}

- (void)initTableHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    headerView.backgroundColor = YTColor(159, 156, 194);
    
    
    for (int i = 0; i < 3; i++) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * SCREEN_WIDTH / 3.0f, 0, SCREEN_WIDTH / 3.0f, 40)];
        titleLabel.text = self.titleStr[i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        [headerView addSubview:titleLabel];
    }
    self.tableView.tableHeaderView = headerView;
}


#pragma mark - tableViewDeldgate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return self.changedArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    YTScoreChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[YTScoreChangeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.changed = self.changedArr[indexPath.row];
    }
    return cell;
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}



#pragma mark - lazy
- (NSMutableArray *)changedArr{
    if (_changedArr == nil) {
        _changedArr = [NSMutableArray array];
    }
    return _changedArr;
}
- (NSArray *)titleStr{
    if (_titleStr == nil) {
        _titleStr = @[@"礼品名称",@"礼品数量",@"是否使用"];
    }
    return _titleStr;
}



@end
