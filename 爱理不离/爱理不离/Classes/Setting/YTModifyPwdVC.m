//
//  YTModifyPwdVC.m
//  爱理不离
//
//  Created by ios on 16/12/7.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTModifyPwdVC.h"
#import "UIBarButtonItem+MJ.h"
@interface YTModifyPwdVC ()<UITextFieldDelegate>
@property(nonatomic,strong)NSArray *discribLabelArr;

@property(nonatomic,copy)NSString *oldPwd;
@property(nonatomic,copy)NSString *reviewsPwd;
@end

@implementation YTModifyPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"修改密码";
    [self initInputView];

}
#pragma mark - custom
- (void)leftButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initInputView{
    UIImageView *baseView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 280)];
    UIImage *baseImg = [UIImage imageNamed:@"确认密码"];
    baseView.userInteractionEnabled = YES;
    baseView.image = [baseImg resizableImageWithCapInsets:UIEdgeInsetsMake(60, 60, 60, 60) resizingMode:UIImageResizingModeStretch];
    [self.view addSubview:baseView];
    
    
    for (int i = 0; i < 2 ; i++) {
        UIView *input = [[UIView alloc]initWithFrame:CGRectMake(30, 30 + i * (baseView.frame.size.height - 60) / 2.0f, baseView.frame.size.width - 60, (baseView.frame.size.height - 60) / 3.0f)];
        
        UILabel *discribe =  [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        discribe.text = self.discribLabelArr[i];
        discribe.textColor = [UIColor lightGrayColor];
        [input addSubview:discribe];
        
        UITextField *inputTF = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(discribe.frame), input.frame.size.width, 40)];
        inputTF.tag = i;
        inputTF.delegate  = self;
        
        
        UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,8,inputTF.frame.size.height)];
        leftView.backgroundColor = [UIColor clearColor];
        
        inputTF.leftView = leftView;
        inputTF.leftViewMode = UITextFieldViewModeAlways;
        inputTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        inputTF.backgroundColor = [UIColor lightGrayColor];
        inputTF.layer.cornerRadius = 5;
        inputTF.layer.masksToBounds = YES;
        inputTF.placeholder = @"请输入";
        [input addSubview:inputTF];
        input.backgroundColor = [UIColor clearColor];
        [baseView addSubview:input];
    }
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(baseView.frame) + 100, SCREEN_WIDTH - 200, 50)];
    
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"服务兑换"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(modifyPwd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    

}

- (void)modifyPwd{
//修改密码

    NSLog(@"-------修改密码%@,%@",self.oldPwd,self.reviewsPwd);
    
    
    if (self.oldPwd.length > 0 && self.reviewsPwd.length >0) {
        
        if ([self.oldPwd isEqualToString:self.reviewsPwd]) {
            [self presentViewController:[AlertTool alertWithTitle:nil Message:@"输入的密码必须不同！" actionTitle:@"确认" andStyle:1] animated:YES completion:nil];
        }else {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [manager POST:@"http://117.78.50.198/user/password.update" parameters:@{@"newPwd":self.reviewsPwd,@"oldPwd":self.oldPwd} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSLog(@"------------str----%@",str);
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([[dic objectForKey:@"code"] intValue] == 0) {
                    //修改密码成功
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"修改密码成功！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alertVC addAction:action1];
                    [self presentViewController:alertVC animated:YES completion:nil];
                }else if ([[dic objectForKey:@"code"] intValue] == 12){
                    //如果原密码输入错误
                    [self presentViewController:[AlertTool alertWithTitle:nil Message:@"原密码输入错误！" actionTitle:@"确认" andStyle:1] animated:YES completion:nil];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                 [self presentViewController:[AlertTool alertWithTitle:nil Message:@"网络连接超时！" actionTitle:@"好" andStyle:1] animated:YES completion:nil];
               
                
            }];
        }

    }else{
        
         [self presentViewController:[AlertTool alertWithTitle:nil Message:@"输入框不能为空！" actionTitle:@"好" andStyle:1] animated:YES completion:nil];
    
    }
    
    
   
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 0) {
        self.oldPwd = textField.text;
    }else{
        self.reviewsPwd = textField.text;
    }

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

#pragma mark  - lazy
- (NSArray *)discribLabelArr{
    if (_discribLabelArr == nil) {
        _discribLabelArr = @[@"原密码",@"新密码"];
    }
    return _discribLabelArr;
}
@end
