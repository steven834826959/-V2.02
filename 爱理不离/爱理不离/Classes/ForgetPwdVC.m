//
//  ForgetPwdVC.m
//  YPP
//
//  Created by ypp on 16/10/28.
//  Copyright © 2016年 ypp. All rights reserved.
//

#import "ForgetPwdVC.h"
#import "NSString+isValidateMobile.h"
#import "UIBarButtonItem+MJ.h"
@interface ForgetPwdVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UITextField *phoneCodeUserInputed;
@property (weak, nonatomic) IBOutlet UITextField *pwdNew;
@property (weak, nonatomic) IBOutlet UITextField *pwdConfirmed;
@property (weak, nonatomic) IBOutlet UIImageView *picCheckCode;
@property (weak, nonatomic) IBOutlet UITextField *picCodeInputed;


@end

@implementation ForgetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    //点击图片验证码，更换图片
    self.picCheckCode.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getPictureCheckCode)];
    [self.picCheckCode addGestureRecognizer:tap];
    
    [self getPictureCheckCode];
    self.pwdConfirmed.delegate = self;
    self.mobile.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneCodeUserInputed.keyboardType = UIKeyboardTypeNumberPad;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
   
}
#pragma mark 拖进来的触发方法
- (void)leftButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)getCheckCode:(UIButton *)sender {
    
    if (![self.mobile.text isValidateMobile]) {
        //如果手机号不合法
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"请输入正确的手机号" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *act = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:act];
        [self presentViewController:alertC animated:YES completion:nil];
        
    }else {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //判断用户是否已注册
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:@"http://117.78.50.198/check_mobile" parameters:@{@"mobile":self.mobile.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //测试用str查看返回的信息
            NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([[dic objectForKey:@"code"] integerValue] != 0) {
                //如果用户未注册
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"手机号未注册" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *act = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alertVC addAction:act];
                [self presentViewController:alertVC animated:YES completion:nil];
            }else {
                //1.如果用户已注册，开始为用户请求发送手机验证码
                [self sendSecurityCode];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //请求失败
            NSLog(@"..........................判断用户是否注册--请求失败：%@",error);
        }];
    }
}

- (IBAction)findPwd:(id)sender {
    if ([self.pwdNew.text isEqualToString:self.pwdConfirmed.text]) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:@"http://117.78.50.198/user/password.reset" parameters:@{@"mobile":self.mobile.text, @"password":self.pwdNew.text, @"msgCode":self.phoneCodeUserInputed.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"--------%@",str);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([[dic objectForKey:@"code"] intValue] == 0) {
                //修改密码成功
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改密码成功！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //返向传值
                    [self.delegate forgotValuesBackToLoginViewController:self mobile:self.mobile.text pwd:self.pwdNew.text];
    
                    //跳转回登录控制器
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }else {
                //修改密码失败
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self presentViewController:[AlertTool alertWithTitle:@"提示" Message:@"网络不太好，获取图片验证码失败！" actionTitle:@"确认" andStyle:1] animated:YES completion:nil];
        }];
    }else {
        [self presentViewController:[AlertTool alertWithTitle:nil Message:@"两次密码输入不一致！" actionTitle:@"重新输入" andStyle:1] animated:YES completion:nil];
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


#pragma mark ToolMethods
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 140;
    
    const float movementDuration = 0.35f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
    
}

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

- (void)sendSecurityCode{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://117.78.50.198/send_msg" parameters:@{@"mobile":self.mobile.text, @"code":self.picCodeInputed.text,@"type":@"2"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"--------获取手机验证码成功--------dic:%@",dic);
        if ([[dic objectForKey:@"code"] intValue] == 0) {
            NSLog(@"2.获取手机验证码成功");
             [self presentViewController:[AlertTool alertWithTitle:@"提示" Message:@"发送手机验证码成功！" actionTitle:@"确认" andStyle:1] animated:YES completion:nil];
        }else{
        
            [self presentViewController:[AlertTool alertWithTitle:@"提示" Message:[dic objectForKey:@"message"] actionTitle:@"确认" andStyle:1] animated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@".............error occured:%@",error);
        [self presentViewController:[AlertTool alertWithTitle:@"提示" Message:@"网络不太好，获取手机验证码失败！" actionTitle:@"确认" andStyle:1] animated:YES completion:nil];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
