//
//  YTReviseAddressVC.m
//  爱理不离
//
//  Created by ypp on 16/12/15.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTReviseAddressVC.h"

@interface YTReviseAddressVC ()
@property (weak, nonatomic) IBOutlet UIButton *reviseBtn;

@end

@implementation YTReviseAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.reviseBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    self.userName.text = self.userNameStr;
    self.phoneNumber.text = self.phoneNumberStr;
    self.province.text = self.provinceStr;
    self.detailAddress.text = self.detailAddressStr;
    self.postalCode.text = self.postalCodeStr;
    
    [self.reviseBtn addTarget:self action:@selector(saveAddress) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)saveAddress {
    [YTHttpTool post:[kDominURL URLStringWithStr:@"/user/user_address.edit"] parameters:@{@"addressId":@(self.addressID), @"province":self.province.text,@"address":self.detailAddress.text, @"shippingMobile":self.phoneNumber.text,@"zipCode":self.postalCode.text,@"shippingName":self.userName.text} withCallBack:^(id obj) {
        
        if ([[obj objectForKey:@"code"] intValue] == 0) {
            //修改成功
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"地址修改成功！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }];
}

@end
