//
//  YTMyInviteCodeVC.m
//  爱理不离
//
//  Created by ios on 16/12/15.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTMyInviteCodeVC.h"
#import "UIBarButtonItem+MJ.h"
#import "YTUserModel.h"
@interface YTMyInviteCodeVC ()
@property(nonatomic,strong)YTUserModel *userInfo;
@end

@implementation YTMyInviteCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请好友";
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    
    self.userInfo = [YTUserModel sharedYTUserModel];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
    
    UILabel *myInviteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 30)];
    myInviteLabel.text = @"我的邀请码";
    myInviteLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:myInviteLabel];
    
    UILabel *codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(myInviteLabel.frame), SCREEN_WIDTH, 80)];
    codeLabel.text = self.userInfo.inviteCode;
    codeLabel.text = @"1234567890";
    codeLabel.textAlignment = NSTextAlignmentCenter;
    codeLabel.font = [UIFont systemFontOfSize:23];
    codeLabel.textColor = [UIColor redColor];
    [self.view addSubview:codeLabel];
}

#pragma mark  - custom
- (void)leftButtonTapped{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}




@end
