//
//  YTProdutViewController.m
//  爱理不离
//
//  Created by Steven on 2016/10/15.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTProdutViewController.h"
#import "YTProductDetailViewController.h"
@interface YTProdutViewController ()
@property(nonatomic,strong)NSMutableArray *btnArr;

@property(nonatomic,strong)NSArray *productArr;

@property(nonatomic,assign)NSInteger productID;

@end

@implementation YTProdutViewController
#pragma mark  - life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    
    //设置导航栏透明
    [self initNavTitle];
    
    //设置背景View
    [self initVBackView];
    
    //拿到产品ID
    [self getProductID];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [HiddenAndShowTool show];
    [self initNavTitle];
}


#pragma mark -custom
- (void)initNavTitle{
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)buttonClicked:(UIButton *)btn{
    YTProductDetailViewController *detail = [[YTProductDetailViewController alloc]init];
    //传值产品ID
    detail.productName = [self.productArr[btn.tag] objectForKey:@"name"];
    detail.productID = [[self.productArr[btn.tag] objectForKey:@"id"] integerValue];
    detail.centerImgTag = btn.tag;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)initVBackView{
    UIImageView *productView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    productView.userInteractionEnabled = YES;
    productView.image = [UIImage imageNamed:@"product"];
    productView.userInteractionEnabled = YES;
    for (int i = 0; i < 3; i++) {
        CGFloat btnW = productView.frame.size.height / 3.0f;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, i * btnW, SCREEN_WIDTH, btnW)];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnArr addObject:button];
        [productView addSubview:button];
        
    }
    [self.view addSubview:productView];

}

- (void)getProductID{
    //发送网络请求拿到产品ID；
    [YTHttpTool get:[kDominURL URLStringWithStr:@"/product/get_all_categories"] parameters:nil withCallBack:^(id obj) {
        
        NSString *jsonStr = obj[@"data"];
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        //反序列化
        NSArray *productArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"------获取产品Arr%@",productArr);
        self.productArr = productArr;
    }];
}

#pragma mark - lazy
- (NSMutableArray *)btnArr{
    if (_btnArr == nil) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

- (NSArray *)productArr{
    if (_productArr == nil) {
        _productArr = [NSArray array];
    }
    return _productArr;
}

@end
