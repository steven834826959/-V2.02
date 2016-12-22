//
//  YTAboutVC.m
//  爱理不离
//
//  Created by ypp on 16/12/8.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTAboutVC.h"
#import "YTAboutUs.h"
#import <MessageUI/MessageUI.h>
#import "UIBarButtonItem+MJ.h"

@interface YTAboutVC ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation YTAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self tableView];
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(back)]; 
}

#pragma mark  - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    //设置cell的背景图
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    imageV.image = [UIImage resizedImage:@"白条@2x-1"];
//    cell.backgroundView = imageV;
    
    [cell.contentView addSubview:imageV];
    
    //文字颜色
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"推荐给朋友";
            break;
        case 1:
            cell.textLabel.text = @"信息反馈";
            break;
        default:
            cell.textLabel.text = @"关于我们";
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //跳转到推荐给朋友
        [self sendUsToFriendWithReceiver:@[@""] Subject:@"这个应用很好玩，快用用吧!" andMessageBody:@"AppStore上搜索爱理不离！！！"];
        
    }else if (indexPath.row == 1) {
        //跳转到信息反馈
        [self sendUsToFriendWithReceiver:@[@"2631416033@qq.com"] Subject:@"无标题" andMessageBody:@"我的意见..."];
        
    }else{
        //跳转到关于我们
        [self.navigationController pushViewController:[YTAboutUs new] animated:YES];
    }
}





#pragma mark ToolMethods
- (void)back{
    if (self.navigationController.viewControllers.count == 2) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //去掉透明后导航栏下边的黑边
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendUsToFriendWithReceiver:(NSArray *)receiver Subject:(NSString *)subject andMessageBody:(NSString *)body {
    if ([MFMailComposeViewController canSendMail] == YES) {
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        // 设置代理(与以往代理不同,不是"delegate",千万不能忘记呀,代理有3步)
        mailVC.mailComposeDelegate = self;
        // 收件人
//        NSArray *sendToPerson = @[@""];
        [mailVC setToRecipients:receiver];
        // 抄送
        NSArray *copyToPerson = @[@"[email protected]"];
        [mailVC setCcRecipients:copyToPerson];
        // 密送
        NSArray *secretToPerson = @[@"[email protected]"];
        [mailVC setBccRecipients:secretToPerson];
        // 主题
//        [mailVC setSubject:@"这个应用很好玩，快用用吧!"];
        [mailVC setSubject:subject];
        [self presentViewController:mailVC animated:YES completion:nil];
//        [mailVC setMessageBody:@"AppStore上搜索爱理不离！！！" isHTML:NO];
        [mailVC setMessageBody:body isHTML:NO];
    }else{
        NSLog(@"此设备不支持邮件发送");
    }
}

#pragma mark MessageDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"取消发送");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"发送失败");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"保存草稿文件");
            break;
        case MFMailComposeResultSent:
            NSLog(@"发送成功");
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 系统发送,模拟器不支持,要用真机测试
- (void)didClickSendSystemEmailButtonAction{
    NSURL *url = [NSURL URLWithString:@"[email protected]"];
    if ([[UIApplication sharedApplication] canOpenURL:url] == YES) {
        [[UIApplication sharedApplication] openURL:url];
    }else{
        NSLog(@"此设备不支持");
    }
}

#pragma mark lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.alwaysBounceVertical = NO;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

@end
