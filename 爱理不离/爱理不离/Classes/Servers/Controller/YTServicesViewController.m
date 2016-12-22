//
//  YTServicesViewController.m
//  爱理不离
//
//  Created by Steven on 2016/10/15.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTServicesViewController.h"
#import "YTCollectionView.h"
#import "UIBarButtonItem+MJ.h"
#import "JSDropDownMenu.h"
#import "MJRefresh.h"
#import "YTServiceTableViewCell.h"
#import "YTShopModel.h"
#import "YTShopDetailVC.h"

typedef enum {
    RefreshTypeDown,
    RefreshTypeUp
}RefreshType;//枚举名称
static const CGFloat MJDuration = 1.0;

@interface YTServicesViewController ()<UITableViewDelegate,UITableViewDataSource,JSDropDownMenuDelegate,JSDropDownMenuDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSArray * imagesArr;
@property(nonatomic,strong)UIImageView *cornerBgImg;

@property(nonatomic,strong)NSMutableArray *shops;
@property(nonatomic,assign)int index;

//下拉选择相关
@property(nonatomic,strong)NSMutableArray *data1;
@property(nonatomic,strong)NSMutableArray *data2;
@property(nonatomic,strong)NSMutableArray *data3;
@property(nonatomic,assign)NSInteger currentData1Index;
@property(nonatomic,assign)NSInteger currentData2Index;
@property(nonatomic,assign)NSInteger currentData3Index;
@end

@implementation YTServicesViewController
#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = 1;
    self.title = @"商户";
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    //初始化表视图
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -1, SCREEN_WIDTH, self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //去除tableView的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    [self createHeaderView];
    
    //网络获取刷新数据
    //下拉刷新
    [self downRefresh];
    
    //上拉加载
    [self pullRefresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [HiddenAndShowTool show];
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
    
    [YTHttpTool get:[kDominURL URLStringWithStr:@"/merchant/list.get"] parameters:nil withCallBack:^(id obj) {
        if ([[obj objectForKey:@"code"] intValue] == 0) {
            //返回成功
            NSString *dataStr = obj[@"data"];
            NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *shops = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            NSLog(@"---------商户返回%@",shops);
            
            switch (type) {
                case RefreshTypeDown:
                    self.shops = [YTShopModel mj_objectArrayWithKeyValuesArray:shops];
                    break;
            case RefreshTypeUp:
                    
                {
                    NSMutableArray *newShops = [YTShopModel mj_objectArrayWithKeyValuesArray:shops];
                    [self.shops addObjectsFromArray:newShops];
                }
                    
                    break;
                default:
                    break;
            }
        }
        
    }];

}




#pragma mark - custom
/**
 表头视图
 */
- (void)createHeaderView{
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 150) andHeight:40];
    menu.indicatorColor = YTColor(224, 192, 215);
    menu.separatorColor = [UIColor clearColor];
    menu.textColor = [UIColor blackColor];
    menu.dataSource = self;
    menu.delegate = self;
    self.tableView.tableHeaderView = menu;
    
}
#pragma mark - 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shops.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cell";
    
    YTServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[YTServiceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        cell = [[NSBundle mainBundle]loadNibNamed:@"YTServiceTableViewCell" owner:self options:nil].lastObject;
        cell.shopModel = self.shops[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 125;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    YTShopDetailVC *shopDetail = [[YTShopDetailVC alloc]init];
    
    shopDetail.shopModel = self.shops[indexPath.row];
    
    [self.navigationController pushViewController:shopDetail animated:YES];

}

#pragma mark  - JSDMenuDelegate
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    return 3;
}
-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    return NO;
}
- (BOOL)haveRightTableViewInColumn:(NSInteger)column{
    return NO;
}
-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
        
        return _currentData1Index;
        
    }
    if (column==1) {
        
        return _currentData2Index;
    }
    
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        return self.data1.count;
    } else if (column == 1){
        return self.data2.count;
    } else if (column == 2){
        
        return self.data3.count;
    }
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0:
            return self.data1[0];
            break;
        case 1:
            return self.data2[0];
            break;
        case 2:
            return self.data3[0];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        
        return self.data1[indexPath.row];
    } else if (indexPath.column==1) {
        return self.data2[indexPath.row];
    } else {
        return self.data3[indexPath.row];
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        self.currentData1Index = indexPath.row;
        //更新信息请求

    } else if(indexPath.column == 1){
        self.currentData2Index = indexPath.row;
         //更新信息请求
        
    } else{
        self.currentData3Index = indexPath.row;
         //更新信息请求
        
    }
}


#pragma mark - lazy
- (NSArray *)imagesArr {
    if (!_imagesArr) {
        NSString * url1 = @"http://pic.newssc.org/upload/news/20161011/1476154849151.jpg";
        NSString * url2 = @"http://img.mp.itc.cn/upload/20160328/f512a3a808c44b1ab9b18a96a04f46cc_th.jpg";
        NSString * url3 = @"http://p1.ifengimg.com/cmpp/2016/10/10/08/f2016fa9-f1ea-4da5-a0f5-ba388de46a96_size80_w550_h354.JPG";
        NSString * url4 = @"http://image.xinmin.cn/2016/10/11/6150190064053734729.jpg";
        NSString * url5 = @"http://imgtu.lishiquwen.com/20160919/63e053727778a18993545741f4028c67.jpg";
        NSString * url6 = @"http://imgtu.lishiquwen.com/20160919/590346287e6e45faf1070a07159314b7.jpg";
        _imagesArr = [NSArray arrayWithObjects: url1, url2, url3, url4, url5, url6, nil];
    }
    return _imagesArr;
}

- (NSMutableArray *)shops{
    if (_shops == nil) {
        _shops = [NSMutableArray  array];
    }
    return _shops;
}

- (NSMutableArray *)data1{
    if (_data1 == nil) {
        _data1 = [NSMutableArray arrayWithObjects:@"商户类型",@"实体店",@"网店", nil];
    }

    return _data1;
}

- (NSMutableArray *)data2{
    if (_data2 == nil) {
        _data2 = [NSMutableArray arrayWithObjects:@"服务类型",@"折扣类",@"抵用类",@"体验类",@"实物类" ,nil];
    }
    
    return _data2;
}

- (NSMutableArray *)data3{
    if (_data3 == nil) {
        _data3 = [NSMutableArray arrayWithObjects:@"情感状态",@"单身",@"热恋",@"已婚" ,nil];
    }
    
    return _data3;
}

@end
