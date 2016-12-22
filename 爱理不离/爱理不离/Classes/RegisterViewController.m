//
//  RegisterViewController.m
//  YPP
//
//  Created by ypp on 16/10/28.
//  Copyright © 2016年 ypp. All rights reserved.
//

#import "RegisterViewController.h"
#import "NSString+isValidateMobile.h"
#import "LoginViewController.h"
#import "UIBarButtonItem+MJ.h"
@interface RegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UITextField *userPwd;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwd;
@property (weak, nonatomic) IBOutlet UIImageView *picCheckCode;
@property (weak, nonatomic) IBOutlet UITextField *picCodeUserInputed;
@property (weak, nonatomic) IBOutlet UITextField *phoneCodeUserInputed;

@property (weak, nonatomic) IBOutlet UITextField *inviteTF;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self getPictureCheckCode];
    //点击图片验证码，更换图片
    self.picCheckCode.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getPictureCheckCode)];
    [self.picCheckCode addGestureRecognizer:tap];
    

    
    self.mobile.delegate = self;
    self.phoneCodeUserInputed.delegate = self;
    self.inviteTF.delegate = self;
    
    //判断用户是否输入了信息
    if (![self.mobile.text isEqualToString:@""]) {
        [self textFieldDidEndEditing:self.mobile];
    }
    
    self.mobile.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneCodeUserInputed.keyboardType = UIKeyboardTypeNumberPad;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
}


#pragma mark 点击方法

- (void)leftButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}

//验证用户的手机号，图形验证码，type后，发送手机验证码
- (IBAction)sendPhoneCheckCode:(UIButton *)sender {
    if ([self.mobile.text isEqualToString:@""]) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入手机号！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:nil];
    }else {
        if ([self.picCodeUserInputed.text isEqualToString:@""]) {
            //如果用户没有输入图片验证码，那么提示用户输入图片验证码
            [self presentViewController:[AlertTool alertWithTitle:@"提示" Message:@"请输入图片验证码" actionTitle:@"确认" andStyle:1] animated:YES completion:nil];
        }else {
            //如果用户输入了验证码，那么开始发送请求
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            [manager POST:@"http://117.78.50.198/send_msg" parameters:@{@"mobile":self.mobile.text, @"code":self.picCodeUserInputed.text,@"type":@"1"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"--------获取手机验证码成功--------dic:%@",dic);
                if ([[dic objectForKey:@"code"] intValue] == 0) {
                    [self presentViewController:[AlertTool alertWithTitle:@"提示" Message:@"发送手机验证码成功！" actionTitle:@"确认" andStyle:1] animated:YES completion:nil];
                    NSLog(@"2.获取手机验证码成功");
                }else{
                
                   [self presentViewController:[AlertTool alertWithTitle:@"提示" Message:[dic objectForKey:@"message"] actionTitle:@"确认" andStyle:1] animated:YES completion:nil];
        
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSLog(@".............error occured:%@",error);
                [self presentViewController:[AlertTool alertWithTitle:@"提示" Message:@"网络不太好，获取手机验证码失败！" actionTitle:@"确认" andStyle:1] animated:YES completion:nil];
            }];
        }
    }
    
}
//开始注册
- (IBAction)startRegister:(UIButton *)sender {
    if(![self.userPwd.text isEqualToString:self.confirmPwd.text]){
        //如果用户输入的密码不同，则提示：请再次确认密码
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"您输入的两次密码不符！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *act = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:act];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }else if ([self.phoneCodeUserInputed.text isEqualToString:@""]) {
        //如果用户输入的手机验证码为空，提示：请输入手机验证码
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"请输入手机验证码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *act = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:act];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }else {
        //如果页面上的问题不存在，那么即可开始注册
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:@"http://117.78.50.198/register" parameters:@{@"mobile":self.mobile.text, @"password":self.userPwd, @"msgCode":self.phoneCodeUserInputed.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"............%@",str);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"注册情况................%@",dic);
            if ([[dic objectForKey:@"code"] intValue] == 0) {
                NSLog(@"3.注册成功");
                //跳转会登录页面
                //反向传值
                [self.delegate valuesBackToLoginViewController:self mobile:self.mobile.text pwd:self.userPwd.text];
                [self.navigationController popViewControllerAnimated:YES];
            }else if([[dic objectForKey:@"code"] intValue] == 15){
                
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号已注册！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"前往登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
                }];
                [alertVC addAction:action];
                [alertVC addAction:action1];
                [self presentViewController:alertVC animated:YES completion:nil];
                
                
                
                
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //网络请求失败
            NSLog(@".............error occured:%@",error);
            [self presentViewController:[AlertTool alertWithTitle:@"提示" Message:@"网络不太好，注册失败！" actionTitle:@"确认" andStyle:1] animated:YES completion:nil];
        }];
 
    }
    
}

#pragma mark 工具方法
//获取图片验证码
- (void)getPictureCheckCode {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://117.78.50.198/verifyImg" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.picCheckCode.image = [UIImage imageWithData:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self presentViewController:[AlertTool alertWithTitle:@"提示" Message:@"网络不太好，获取图片验证码失败！" actionTitle:@"确认" andStyle:1] animated:YES completion:nil];
    }];
    
}

//检测手机号是否注册
- (void)checkPhoneNumberRegisteredOrNot {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://117.78.50.198/check_mobile" parameters:@{@"mobile":self.mobile.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"----------str:%@",str);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"-------dic:%@",dic);
        if ([[dic objectForKey:@"code"] intValue] != 0) {
            //未注册
            NSLog(@"1.手机号可以注册");
        }else {
            //已注册
            //提示用户，该手机号码已注册
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号已注册！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                [self.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"前往登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController pushViewController:[LoginViewController new] animated:YES];
            }];
            [alertVC addAction:action];
            [alertVC addAction:action1];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error occured!,error:%@",error);
        [self presentViewController:[AlertTool alertWithTitle:@"提示" Message:@"网络不太好，无法确认手机号是否可以注册！" actionTitle:@"确认" andStyle:1] animated:YES completion:nil];
    }];
}

#pragma mark textFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.mobile) {
        
    }else{
        [self animateTextField: textField up: YES];
    }
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.mobile.text isEqualToString:@""]) {
        
    }else if (![self.mobile.text isValidateMobile]) {
        //如果用户输入的手机号不是正确的格式，那么提示：请输入正确的手机号
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"请输入正确的手机号" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *act = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:act];
        [self presentViewController:alertVC animated:YES completion:nil];
        //如果用户输入的手机号格式正确，那么执行下一步:
    }else {
        [self checkPhoneNumberRegisteredOrNot];
    }
    
    
    if (textField == self.phoneCodeUserInputed) {
        [self animateTextField: textField up: NO];
    }
}



#pragma mark ToolMethods
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 170;
    
    const float movementDuration = 0.35f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
    
}

@end
