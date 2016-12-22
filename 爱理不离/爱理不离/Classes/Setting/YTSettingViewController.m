//
//  YTSettingViewController.m
//  爱理不离
//
//  Created by Steven on 2016/10/15.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTSettingViewController.h"
#import "UIBarButtonItem+MJ.h"
#import "YTModifyPwdVC.h"
#import "LoginViewController.h"
#import "YTMyInviteCodeVC.h"

@interface YTSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *cellImages;
@property(nonatomic,strong)NSArray *cellTextLable;

@end

@implementation YTSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];

    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 2, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alwaysBounceVertical = NO;
    [self.view addSubview:self.tableView];

}
#pragma mark  - custom
- (void)leftButtonTapped{
    if (self.navigationController.viewControllers.count == 2) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //去掉透明后导航栏下边的黑边
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  -delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor clearColor];
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    backView.image = [UIImage resizedImage:@"白条@2x-1"];
    [cell.contentView addSubview:backView];
    cell.imageView.image = [UIImage imageNamed:self.cellImages[indexPath.row]];
    cell.textLabel.text = self.cellTextLable[indexPath.row];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
            case 0:
                    {
                        YTMyInviteCodeVC *invite = [[YTMyInviteCodeVC alloc]init];
                        [self.navigationController pushViewController:invite animated:YES];
                    }
            break;
        case 1:
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loginStatus"]) {
                YTModifyPwdVC *modify = [[YTModifyPwdVC alloc]init];
                [self.navigationController pushViewController:modify animated:YES];
            }
            break;
        case 2:
        {
            [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
                
                NSString *message = [NSString stringWithFormat:@"您确认清除%.2f M缓存吗？",totalSize/1024.0/1024];
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //清除内存缓存
                    [[SDImageCache sharedImageCache] clearMemory];
                    //清除磁盘缓存
                    [[SDImageCache sharedImageCache] clearDisk];
                    //清除系统网络请求时缓存的数据
                    [[NSURLCache sharedURLCache]removeAllCachedResponses];
                    
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [ac addAction:action1];
                [ac addAction:action2];
                [self presentViewController:ac animated:YES completion:nil];
                
                
            }];
            
        }
            break;
        case 3:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定退出" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self loginOut];
            }];
            
            [alert addAction:action1];
            [alert addAction:action2];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
            break;
        default:
            break;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}


- (void)loginOut{

    //退出登录请求
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loginStatus"]){
        
        //如果用户已登录
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:@"http://117.78.50.198/user/logout" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //网络请求成功
            NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"--------------%@",str);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([[dic objectForKey:@"code"] intValue] == 0) {
                
                NSLog(@"------退出成功！！！！");
                
                //注销成功
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setBool:NO forKey:@"loginStatus"];
                [defaults synchronize];
                
                //删除之前保存的文件
                NSString *file = [NSTemporaryDirectory() stringByAppendingPathComponent:@"userInfo.plist"];
                
                
                BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:file];
                NSLog(@"-----是否存在%d",isExist);
                if (isExist) {
                    //删除文件
                    [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
                    
                    BOOL isExistAgain = [[NSFileManager defaultManager] fileExistsAtPath:file];
                    NSLog(@"------删除之后是否存在%d",isExistAgain);
                    //弹出登录控制器
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
                    [self presentViewController:nav animated:YES completion:nil];
                }
                
                
            }else {
                //注销失败
                [self presentViewController:[AlertTool alertWithTitle:nil Message:@"注销失败，请确认网络通畅后再试！" actionTitle:@"确认" andStyle:1] animated:YES completion:nil];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@".............netError occured:%@",error);
            [self presentViewController:[AlertTool alertWithTitle:nil Message:@"注销失败，请确认网络通畅后再试！" actionTitle:@"确认" andStyle:1] animated:YES completion:nil];
        }];
        
    }else{
        
        [self presentViewController:[AlertTool alertWithTitle:nil Message:@"您还没有登录！" actionTitle:@"确认" andStyle:1] animated:YES completion:nil];
    }


}


#pragma mark - lazy
- (NSArray *)cellImages{
    if (_cellImages == nil) {
        _cellImages = @[@"设置",@"设置",@"设置3",@"设置4"];
    }
    return _cellImages;
}
- (NSArray *)cellTextLable{
    if (_cellTextLable == nil) {
        _cellTextLable = @[@"邀请好友",@"修改密码",@"清除缓存",@"退出登录"];
    }
    return _cellTextLable;
}

@end
