//
//  YTAddBankCardVC.m
//  爱理不离
//
//  Created by ios on 16/12/7.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTAddBankCardVC.h"
#import "UIBarButtonItem+MJ.h"
#import "YTBankCardSetVC.h"
@interface YTAddBankCardVC ()
@property(nonatomic,strong)UIView *inputView;
@property(nonatomic,strong)NSArray *discribLabelArr;
@property(nonatomic,strong)NSArray *textFiledPlaceHolderStr;

@end

@implementation YTAddBankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行卡绑定";
    self.view.backgroundColor = YTColor(239, 209, 211);;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
    [self initInputView];
    
    
}
#pragma mark  - custom
- (void)leftButtonTapped{
   
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)nextStep{
    YTBankCardSetVC *setVc = [[YTBankCardSetVC alloc]init];
    [self.navigationController pushViewController:setVc animated:YES];
}


- (void)initInputView{
    UIImageView *baseView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 350)];
    UIImage *baseImg = [UIImage imageNamed:@"确认密码"];
    baseView.userInteractionEnabled = YES;
    baseView.image = [baseImg resizableImageWithCapInsets:UIEdgeInsetsMake(60, 60, 60, 60) resizingMode:UIImageResizingModeStretch];
    [self.view addSubview:baseView];
    
    
    for (int i = 0; i < 3 ; i++) {
        UIView *input = [[UIView alloc]initWithFrame:CGRectMake(30, 30 + i * (baseView.frame.size.height - 60) / 3.0f, baseView.frame.size.width - 60, (baseView.frame.size.height - 60) / 3.0f)];
        
        UILabel *discribe =  [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        discribe.text = self.discribLabelArr[i];
        discribe.textColor = [UIColor whiteColor];
        [input addSubview:discribe];
        
        UITextField *inputTF = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(discribe.frame), input.frame.size.width, 40)];
        inputTF.tag = i;
        
        if (i == 0) {
            inputTF.keyboardType = UIKeyboardTypeDefault;
        }else{
            inputTF.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,8,inputTF.frame.size.height)];
        leftView.backgroundColor = [UIColor clearColor];
        
        inputTF.leftView = leftView;
        
        inputTF.leftViewMode = UITextFieldViewModeAlways;
        inputTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        inputTF.backgroundColor = [UIColor whiteColor];
        inputTF.layer.cornerRadius = 5;
        inputTF.layer.masksToBounds = YES;
        inputTF.placeholder = self.textFiledPlaceHolderStr[i];
        [input addSubview:inputTF];
        input.backgroundColor = [UIColor clearColor];
        [baseView addSubview:input];
    }
    


}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark  - lazy
- (NSArray *)discribLabelArr{
    if (_discribLabelArr == nil) {
        _discribLabelArr = @[@"姓名",@"身份证",@"银行卡"];
    }
    return _discribLabelArr
    ;
}


- (NSArray *)textFiledPlaceHolderStr{
    if (_textFiledPlaceHolderStr == nil) {
        _textFiledPlaceHolderStr = @[@" 请输入姓名",@" 请输入身份证号",@" 请输入银行卡号"];
    }
    return _textFiledPlaceHolderStr;
}

@end
