//
//  YTProductDetailViewController.m
//  爱理不离
//
//  Created by ios on 16/12/2.
//  Copyright © 2016年 cn.stevenyongtong All rights reserved.
//

#import "YTProductDetailViewController.h"
#import "YTProductListVC.h"
#import "UIBarButtonItem+MJ.h"
#import "MJExtension.h"
#import "YTProuctModel.h"

@interface YTProductDetailViewController ()
@property(nonatomic,strong)UIImageView *headerView;

@property (strong, nonatomic) NSMutableArray *product_Array;

@end

@implementation YTProductDetailViewController
#pragma mark  - life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    
    
    //设置导航栏透明
    [self initNavTitle];
    
    NSLog(@"-------产品ID  %ld",self.productID);
    
    //拿到产品的详细信息
    [self getProductDetail];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
    self.headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 3.0f)];
    self.headerView.image = [UIImage imageNamed:@"新产品列表"];
    [self.view addSubview:self.headerView];

    [self initBottomView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavTitle];
}


#pragma mark - custom

- (void)leftButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initNavTitle{
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
- (void)initBottomView{
    //底板view
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.headerView.frame))];
    bottomView.backgroundColor = [UIColor clearColor];
    bottomView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:bottomView];
    
    NSArray *productImgs = @[@"新产品列表底板",@"新产品列表底板2",@"新产品列表底板2",@"新产品列表底板"];
    
    //产品分类view
    
    for (int i = 0; i < 4; i++) {
        
        CGFloat btnX;
        CGFloat btnY;
        CGFloat btnW;
        CGFloat btnH;
        
        switch (i) {
            case 0:
                btnX = 0;
                btnY = 5;
                btnW = SCREEN_WIDTH * 0.45 - 2.5;
                btnH = bottomView.frame.size.height * 0.55 - 5;
                break;
            case 1:
                btnX = SCREEN_WIDTH * 0.45 + 2.5;
                btnY = 5;
                btnW = SCREEN_WIDTH * 0.55 - 2.5;
                btnH = bottomView.frame.size.height * 0.45 - 5;
                break;
            case 2:
                btnX = 0;
                btnY = bottomView.frame.size.height * 0.55 + 5;
                btnW = SCREEN_WIDTH * 0.55 - 2.5;
                btnH = bottomView.frame.size.height * 0.45 - 5;
                break;
            case 3:
                btnX = SCREEN_WIDTH * 0.55 + 2.5;
                btnY = bottomView.frame.size.height * 0.45 + 5;
                btnW = SCREEN_WIDTH * 0.45 - 2.5;
                btnH = bottomView.frame.size.height * 0.55 - 5;
                break;
            default:
                break;
        }
        
        UIButton *productBtn = [[UIButton alloc]init];
        productBtn.backgroundColor = [UIColor redColor];
        productBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        productBtn.tag = i;
        
        [productBtn setBackgroundImage:[UIImage imageNamed:productImgs[i]] forState:UIControlStateNormal];
        [productBtn addTarget:self action:@selector(productBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:productBtn];
    }
    
    //中心处view
    UIImageView *centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 125, 100)];
    centerImageView.center = CGPointMake(SCREEN_WIDTH / 2.0f, bottomView.frame.size.height / 2.0f);
    centerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"productCover_%ld",self.centerImgTag + 1]];
    
    [bottomView addSubview:centerImageView];

}

- (void)getProductDetail{
    
    [YTHttpTool post:[kDominURL URLStringWithStr:@"/product/list.get"] parameters:@{@"categoryId":@(self.productID)} withCallBack:^(id obj) {
        
        
        NSString *jsonStr = [obj objectForKey:@"data"];
        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"-------------分类产品返回%@",arr);
        self.product_Array = [YTProuctModel mj_objectArrayWithKeyValuesArray:arr];
    }];
    

}




- (void)productBtnClicked:(UIButton *)sender{
    YTProductListVC *list = [[YTProductListVC alloc]init];
    //向下一个控制器传值
    list.productName = self.productName;
    list.product = self.product_Array[sender.tag];
    [self.navigationController pushViewController:list animated:YES];
}

#pragma mark lazy
- (NSMutableArray *)product_Array {
    if (!_product_Array) {
        _product_Array = [NSMutableArray array];
    }
    return _product_Array;
}

@end
