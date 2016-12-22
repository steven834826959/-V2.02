//
//  YTIdentificationVC.m
//  爱理不离
//
//  Created by ios on 2016/12/20.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTIdentificationVC.h"
#import "UIBarButtonItem+MJ.h"
@interface YTIdentificationVC ()
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,copy)NSString *chkValue;
@end

@implementation YTIdentificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户认证";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.webView];
    NSURL *url = [NSURL URLWithString:[kDominURL URLStringWithStr:@"/user/user_register"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    [request setHTTPMethod: @"POST"];
    [self.webView loadRequest: request];
}

#pragma mark - custom
- (void)leftButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
