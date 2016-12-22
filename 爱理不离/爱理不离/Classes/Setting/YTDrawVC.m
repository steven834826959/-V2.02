//
//  YTDrawVC.m
//  爱理不离
//
//  Created by ios on 16/12/13.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTDrawVC.h"
#import "UIBarButtonItem+MJ.h"

@interface YTDrawVC ()

@end

@implementation YTDrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
}

#pragma mark - custom
- (void)leftButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)next{
    
    if (self.balanceTF.text.length == 0) {
        [self presentViewController:[AlertTool alertWithTitle:@"提示" Message:@"请输入金额" actionTitle:@"好" andStyle:1] animated:YES completion:nil];
    }else{
        
        
    }
    
    NSLog(@"提走环控制器");
    
}


@end
