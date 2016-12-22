//
//  YTShopDetailVC.m
//  爱理不离
//
//  Created by ios on 16/12/16.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTShopDetailVC.h"
#import "UIBarButtonItem+MJ.h"
#import "YTServiceTableViewCell.h"
#import "MJRefresh.h"
#import "YTServiceDetailVC.h"
#import "YTServiceModel.h"
typedef enum {
    RefreshTypeDown,
    RefreshTypeUp
}RefreshType;//枚举名称

static const CGFloat MJDuration = 1.0;

@interface YTShopDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *sevices;

@property(nonatomic,assign)int index;
@property(nonatomic,strong)UIWebView *decView;
@end

@implementation YTShopDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商户详情";
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
    
    //富文本商家介绍
    self.decView = [[UIWebView alloc]init];
    self.decView.delegate = self;
    [self.decView loadHTMLString:self.shopModel.introduction baseURL:nil];
    [self.decView setBackgroundColor:[UIColor clearColor]];
    [self.decView setOpaque:NO];

    //初始化tableView
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)
                      ];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //去除tableView的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    [self creatHeaderView];
    
    //下拉刷新
    [self downRefresh];
    
    //上拉加载
    [self pullRefresh];
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.toolbar.hidden = YES;
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

    [YTHttpTool get:[kDominURL URLStringWithStr:@"/service/list.get"] parameters:@{@"merchantId":@(self.shopModel.merchantCategoryId),@"pageNum":@(index),@"size":@(5)} withCallBack:^(id obj) {
        
        NSString *dataStr = obj[@"data"];
        NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        NSLog(@"------获取服务%@",dataArr);
        
        
        switch (type) {
            case RefreshTypeDown:
                self.sevices = [YTServiceModel mj_objectArrayWithKeyValuesArray:dataArr];
                break;
            case RefreshTypeUp:
            {
                NSMutableArray *NewSevices = [YTServiceModel mj_objectArrayWithKeyValuesArray:dataArr];
                
                [self.sevices addObjectsFromArray:NewSevices];
            
            }
                
                break;
                
                
            default:
                break;
        }
    }];
}

#pragma mark  - custom
- (void)leftButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)creatHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 235)];
    //标题Lable
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor lightGrayColor];
    titleLabel.text = self.shopModel.name;
    
    [headerView addSubview:titleLabel];
    
    UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), SCREEN_WIDTH, 200)];
    NSArray *urlArr = [self.shopModel.image componentsSeparatedByString:@","];
    headImg.userInteractionEnabled = YES;
    [headImg sd_setImageWithURL:[NSURL URLWithString:[kDominURL URLStringWithStr:urlArr.lastObject]]];
    [headerView addSubview:headImg];
//    [headerView addSubview:self.decView];
    self.tableView.tableHeaderView = headerView;
}


#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sevices.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    
    YTServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[YTServiceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        cell = [[NSBundle mainBundle]loadNibNamed:@"YTServiceTableViewCell" owner:self options:nil].lastObject;
        cell.seviceModel = self.sevices[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YTServiceDetailVC *sevicrDetail = [[YTServiceDetailVC alloc]init];

    sevicrDetail.seviceModel = self.sevices[indexPath.row];
    
    [self.navigationController pushViewController:sevicrDetail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

#pragma mark - webViewdelagate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取到webview的高度
    CGFloat height = [[self.decView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    self.decView.frame = CGRectMake(0,235, SCREEN_WIDTH,100);
    [self.tableView reloadData];
}




#pragma mark - lazy
- (NSMutableArray *)sevices{
    if (_sevices == nil) {
        _sevices = [NSMutableArray array];
    }
    return _sevices;
}

@end
