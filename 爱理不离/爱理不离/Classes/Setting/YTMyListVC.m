//
//  YTMyListVC.m
//  爱理不离
//
//  Created by ios on 16/12/16.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTMyListVC.h"
#import "UIBarButtonItem+MJ.h"
@interface YTMyListVC ()

@end

@implementation YTMyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"愿望清单";
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, 60)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"暂未开放";
    label.font = [UIFont systemFontOfSize:23];
    [self.view addSubview:label];
 
}

#pragma mark  - custom
- (void)leftButtonTapped{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
