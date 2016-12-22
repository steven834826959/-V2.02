//
//  YTAboutUs.m
//  爱理不离
//
//  Created by ypp on 16/12/8.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTAboutUs.h"
#import "UIBarButtonItem+MJ.h"
@interface YTAboutUs ()

@end

@implementation YTAboutUs

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(back)];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
