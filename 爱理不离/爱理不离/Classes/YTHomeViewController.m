//
//  YTHomeViewController.m
//  爱理不离
//
//  Created by Steven on 2016/12/1.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTHomeViewController.h"
#import "YTHttpTool.h"
#import "AFNetworking.h"
#import "YTCollectionView.h"
#import "YTHomeCell.h"
#import "YTProductDetailViewController.h"
#import "YTAcitvityShakeVC.h"



@interface YTHomeViewController ()<UITableViewDelegate,UITableViewDataSource,YTCollectionViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSArray * imagesArr;
@end

@implementation YTHomeViewController
#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏透明
    [self initNavTitle];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, self.view.frame.size.height + 64)
                      ];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //去除tableView的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //创建头部视图
    [self createHeaderView];
    //创建尾部视图
    [self createFooterView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [HiddenAndShowTool show];
}

#pragma mark - custom

- (void)initNavTitle{
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

/**
 表头视图
 */
- (void)createHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 200)];
    //图片轮播
    YTCollectionView *cycleView = [[YTCollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    cycleView.imagesArr = self.imagesArr;
    cycleView.delegate  = self;
    cycleView.placeHolderImageName = @"0K143Xa_0.jpg";
    [headerView addSubview:cycleView];
    self.tableView.tableHeaderView = cycleView;
    
}
/**
 表尾视图
 */
- (void)createFooterView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 350)];
    //图片
    UIImageView *footerTopView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    footerTopView.image = [UIImage imageNamed:@"首页商家"];
    UIImageView *footerBottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 150)];
    footerBottomView.image = [UIImage imageNamed:@"首页邀请有礼"];
    [footerView addSubview:footerTopView];
    [footerTopView addSubview:footerBottomView];
    self.tableView.tableFooterView = footerView;
}


//跳转控制器
- (void)btnClicked:(UIButton *)sender{
    //点击产品之后跳转
    YTProductDetailViewController *detail = [[YTProductDetailViewController alloc]init];
    
    detail.productID = sender.tag;
    if (sender.tag == 5) {
        detail.centerImgTag = 0;
        detail.productName = @"爱你妹";
    }else if (sender.tag == 8){
        detail.centerImgTag = 1;
        detail.productName = @"守爱侠";
    }else{
        detail.centerImgTag = 2;
        detail.productName = @"潘多拉";
    }

    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - delegate
// 实现协议－－获取轮播图片的点击事件
- (void)ZYCollectionViewClick:(NSInteger)index {
    NSLog(@"%ld", index);
    
    YTAcitvityShakeVC *activity = [[YTAcitvityShakeVC alloc]init];
    [self.navigationController pushViewController:activity animated:YES];
    
}

#pragma mark - tabeleViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YTHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (cell == nil) {
        cell = [[YTHomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    //设置cell的背景图片
    cell.backImg.image = [UIImage imageNamed:@"三个@2x-1"];
    
    for (UIButton *btn in cell.buttonArr) {
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    //设置cell点击时不回变颜色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 540;
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


@end
