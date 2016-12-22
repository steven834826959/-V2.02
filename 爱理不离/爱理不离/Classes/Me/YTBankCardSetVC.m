//
//  YTBankCardSetVC.m
//  爱理不离
//
//  Created by ios on 16/12/7.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTBankCardSetVC.h"
#import "UIBarButtonItem+MJ.h"
@interface YTBankCardSetVC ()<UITextFieldDelegate>
@property(nonatomic,strong)NSArray *discribLabelArr;
@end

@implementation YTBankCardSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定银行卡";
    self.view.backgroundColor = YTColor(239, 209, 211);;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(cardBand)];
   self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
    
    [self initInputView];
    
}

#pragma mark  - custom
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
        discribe.textColor = [UIColor whiteColor];
        [input addSubview:discribe];
        
        UITextField *inputTF = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(discribe.frame), input.frame.size.width, 40)];
        inputTF.tag = i;
        inputTF.delegate = self;
        UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,8,inputTF.frame.size.height)];
        leftView.backgroundColor = [UIColor clearColor];
        
        inputTF.leftView = leftView;
        
        inputTF.leftViewMode = UITextFieldViewModeAlways;
        inputTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

        
        inputTF.backgroundColor = [UIColor whiteColor];
        inputTF.layer.cornerRadius = 5;
        inputTF.layer.masksToBounds = YES;
        inputTF.placeholder = @"请选择";
        [input addSubview:inputTF];
        input.backgroundColor = [UIColor clearColor];
        [baseView addSubview:input];
    }
    
    
    
}

- (void)cardBand{
  //绑定银行卡请求
    


}

#pragma mark  - textFieldDeglegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.inputView = nil;

    if (textField.tag == 0) {
        //弹出银行地址选择器
        
        
    }else{
       //弹出银行选择器
        
        
    
    }
    return YES;

}



#pragma mark  - lazy
- (NSArray *)discribLabelArr{
        if (_discribLabelArr == nil) {
            _discribLabelArr = @[@"开户行地址",@"开户银行"];
        }
        return _discribLabelArr;
}
@end
