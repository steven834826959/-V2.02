//
//  YTAddAddressVC.m
//  爱理不离
//
//  Created by ypp on 16/12/7.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTAddAddressVC.h"
#import "UIBarButtonItem+MJ.h"
#import "ChooseLocationView.h"
#import "CitiesDataTool.h"


@interface YTAddAddressVC ()<NSURLSessionDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *province;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *detailAddress;
@property (weak, nonatomic) IBOutlet UITextField *postalCode;

@property (nonatomic,strong) ChooseLocationView *chooseLocationView;
@property (nonatomic,strong) UIView  *cover;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;


@end

@implementation YTAddAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增收货地址";
    [self setInterface];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    //设置代理
    self.userName.delegate = self;
    self.province.delegate = self;
    self.postalCode.delegate = self;
    self.detailAddress.delegate = self;
    //设置默认的省份，区等信息
    [[CitiesDataTool sharedManager] requestGetData];
    [self.view addSubview:self.cover];
    self.chooseLocationView.address = @"上海市 市辖区 黄浦区";
    self.chooseLocationView.areaCode = @"310101";
    
    self.province.userInteractionEnabled = YES;
    [self.province addTarget:self action:@selector(chooseLocation) forControlEvents:UIControlEventTouchUpInside];
    
    [self.saveBtn addTarget:self action:@selector(saveAddress) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setInterface {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(back)];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    //设置省份
    UILabel *provinceLabel = [[UILabel alloc]init];
    provinceLabel.frame = CGRectMake(0, 0, self.province.frame.size.width * 0.3, self.province.frame.size.height);
    provinceLabel.backgroundColor = YTColor(224, 192, 215);
    provinceLabel.textAlignment = NSTextAlignmentCenter;
    provinceLabel.text = @"省  份";
    provinceLabel.textColor = [UIColor whiteColor];
    self.province.leftViewMode = UITextFieldViewModeAlways;
    self.province.leftView = provinceLabel;
    
    //设置详细地址
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.frame = CGRectMake(0, 0, self.detailAddress.frame.size.width * 0.3, self.detailAddress.frame.size.height);
    detailLabel.backgroundColor = YTColor(224, 192, 215);
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.text = @"详细地址";
    detailLabel.textColor = [UIColor whiteColor];
    self.detailAddress.leftViewMode = UITextFieldViewModeAlways;
    self.detailAddress.leftView = detailLabel;
    self.detailAddress.userInteractionEnabled = YES;
    //设置邮编
    UILabel *postalLabel = [[UILabel alloc]init];
    postalLabel.frame = CGRectMake(0, 0, self.postalCode.frame.size.width * 0.3, self.postalCode.frame.size.height);
    postalLabel.backgroundColor = YTColor(224, 192, 215);
    postalLabel.textAlignment = NSTextAlignmentCenter;
    postalLabel.text = @"邮政编码";
    postalLabel.textColor = [UIColor whiteColor];
    self.postalCode.leftViewMode = UITextFieldViewModeAlways;
    self.postalCode.leftView = postalLabel;
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)chooseLocation:(id)sender {
    [self chooseLocation];
}

- (void)saveAddress {
    
    if ([self.userName.text isEqualToString:@""]) {
        //用户名未输入
        [self presentViewController:[AlertTool alertWithTitle:nil Message:@"请输入用户名" actionTitle:@"确认" andStyle:1] animated:YES completion:nil];
        
    }else if([self.phoneNumber.text isEqualToString:@""]) {
        //手机号未输入
        [self presentViewController:[AlertTool alertWithTitle:nil Message:@"请输入手机号" actionTitle:@"确认" andStyle:1] animated:YES completion:nil];
        
    }else {
//        @"addressId":@(self.addressIndex ++),
        [YTHttpTool post:[kDominURL URLStringWithStr:@"/user/user_address.edit"] parameters:@{@"province":self.province.text,@"address":self.detailAddress.text, @"shippingMobile":self.phoneNumber.text,@"zipCode":self.postalCode.text,@"shippingName":self.userName.text} withCallBack:^(id obj) {
            
            NSLog(@"...obj...%@",obj);
            if ([[obj objectForKey:@"code"] intValue] == 0) {
                //新增地址成功
                NSString *dataString = [obj objectForKey:@"data"];
                NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"---%@",dataDic);
                //提示
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"新增地址成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        
        }];

    }
    
    
    
    
}

#pragma mark SelectAddress
- (void)chooseLocation {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform =CGAffineTransformMakeScale(0.95, 0.95);
    }];
    self.cover.hidden = !self.cover.hidden;
    self.chooseLocationView.hidden = self.cover.hidden;
    
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //用户点击省份按钮，弹出地区选择
    if (textField == self.province) {
        [self chooseLocation];
    }
    //用户点击详细地址或者邮编，上拉界面
    if (textField == self.detailAddress || textField == self.postalCode) {
        [self animateTextField:textField up:YES];
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.province) {
        return NO;
    }else {
        return YES;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    //用户编辑完详细地址和邮编之后，页面上拉
    if (textField == self.postalCode || textField == self.detailAddress) {
        [self animateTextField:textField up:NO];
        
    }
    if (textField == self.userName) {
        [self.view endEditing:YES];
        NSLog(@"iii.............i.......................................................");
//        [self.userName resignFirstResponder];
    }
    
}
#pragma mark ToolMethods
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
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
- (UIView *)cover{
    
    if (!_cover) {
        _cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_cover addSubview:self.chooseLocationView];
        __weak typeof (self) weakSelf = self;
        _chooseLocationView.chooseFinish = ^{
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.province.text = weakSelf.chooseLocationView.address;
                weakSelf.view.transform = CGAffineTransformIdentity;
                weakSelf.cover.hidden = YES;
            }];
        };
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCover:)];
        [_cover addGestureRecognizer:tap];
        tap.delegate = self;
        _cover.hidden = YES;
    }
    return _cover;
}

- (ChooseLocationView *)chooseLocationView{
    
    if (!_chooseLocationView) {
        _chooseLocationView = [[ChooseLocationView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 350, [UIScreen mainScreen].bounds.size.width, 350)];
        [self.view addSubview:_chooseLocationView];
    }
    return _chooseLocationView;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(_chooseLocationView.frame, point)){
        return NO;
    }
    return YES;
}


- (void)tapCover:(UITapGestureRecognizer *)tap{
    
    if (_chooseLocationView.chooseFinish) {
        _chooseLocationView.chooseFinish();
    }
}





@end
