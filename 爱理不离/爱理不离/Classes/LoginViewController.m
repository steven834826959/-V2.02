//
//  LoginViewController.m
//  YPP
//
//  Created by ypp on 16/10/28.
//  Copyright © 2016年 ypp. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+isValidateMobile.h"
#import "RegisterViewController.h"
#import "ForgetPwdVC.h"
#import "UIBarButtonItem+MJ.h"
#import "YTUserModel.h"
#import "MJExtension.h"

@interface LoginViewController ()<UITextFieldDelegate,RegisterViewControllerDelegate,ForgetPwdDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UITextField *userPwd;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.mobile.keyboardType = UIKeyboardTypeNumberPad;
    self.userPwd.delegate = self;
    
    
    [self initNavBar];
    
    //单击空白部分，收起键盘
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapResignFirstResponser)];
    singleTap.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:singleTap];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"感情1" highIcon:@"感情1" target:self action:@selector(leftButtonTapped)];
}
#pragma mark - custom
- (void)leftButtonTapped{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initNavBar{
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

#pragma mark 开始登录
- (IBAction)startLogin:(UIButton *)sender {

    if (![self.mobile.text isValidateMobile] || [self.mobile.text isEqualToString:@""]) {
        //1.如果用户输入的手机号不是合法的手机号格式
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"请输入正确的手机号" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *act = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:act];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }else if ([self.userPwd.text isEqualToString:@""]){
        //2.用户必须输入密码
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"密码不可为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *act = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:act];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *registrationID = [defaults objectForKey:@"registrationID"];
        
        NSLog(@"registrationID--- %@",registrationID);
        //满足上面两个请求即可开始进行登录的网络请求
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:[kDominURL URLStringWithStr:@"/user/login"] parameters:@{@"mobile":self.mobile.text,@"password":self.userPwd.text,@"deviceNum":@"111"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //网络请求成功
            NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"-----------123---%@",str);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([[dic objectForKey:@"code"] intValue] == 0) {
                //登录成功
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setBool:YES forKey:@"loginStatus"];
                [defaults setObject:self.mobile.text forKey:@"phone"];
                [defaults setObject:self.userPwd.text forKey:@"userPwd"];
                
                [defaults synchronize];
                
                
                NSString *jsonStr = dic[@"data"];
                NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                
                
                NSLog(@"---------登录后拿到个人信息 %@",dicData);
                
                //字典转模型
                YTUserModel *userInfo = [YTUserModel mj_objectWithKeyValues:dicData];
                
                //将文件写入内存
                NSString *file = [NSTemporaryDirectory() stringByAppendingPathComponent:@"userInfo.plist"];
                // 归档
                [NSKeyedArchiver archiveRootObject: userInfo toFile:file];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }else {
                //登录失败
                
                [self presentViewController:[AlertTool alertWithTitle:@"提示" Message:[dic objectForKey:@"message"] actionTitle:@"确认" andStyle:1] animated:YES completion:nil];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@".............netError occured:%@",error);
            [self presentViewController:[AlertTool alertWithTitle:@"提示" Message:@"网络不太好，无法确认手机号是否可以注册！" actionTitle:@"确认" andStyle:1] animated:YES completion:nil];
        }];
    }
}



#pragma mark textFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

#pragma mark  - RegistDelegate
- (void)valuesBackToLoginViewController:(RegisterViewController *)sender mobile:(NSString *)mobile pwd:(NSString *)pwd{
    self.mobile.text = mobile;
    self.userPwd.text = pwd;
}
#pragma mark  - forgotDelegate
- (void)forgotValuesBackToLoginViewController:(ForgetPwdVC *)sender mobile:(NSString *)mobile pwd:(NSString *)pwd{
    self.mobile.text = mobile;
    self.userPwd.text = pwd;
}

#pragma mark ToolMethods
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 90;
    
    const float movementDuration = 0.35f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
    
}


- (void)tapResignFirstResponser {
    [self.view endEditing:YES];
}
- (IBAction)jumpToRegisterPage:(id)sender{
    RegisterViewController *regist = [RegisterViewController new];
    regist.delegate = self;
    [self.navigationController pushViewController:regist animated:YES];
}

- (IBAction)jumpToForgetPwdPage:(id)sender {
    ForgetPwdVC *forgot = [[ForgetPwdVC alloc]init];
    
    
    
    [self.navigationController pushViewController:forgot animated:YES];
}

- (BOOL)becomeFirstResponder {
    return YES;
}

@end

