//
//  YTReviseAddressVC.h
//  爱理不离
//
//  Created by ypp on 16/12/15.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTAddAddressVC.h"

@interface YTReviseAddressVC : YTAddAddressVC


@property (assign, nonatomic) NSInteger addressID;

@property (strong, nonatomic) NSString *userNameStr;

@property (strong, nonatomic) NSString *phoneNumberStr;

@property (strong, nonatomic) NSString *provinceStr;

@property (strong, nonatomic) NSString *detailAddressStr;

@property (strong, nonatomic) NSString *postalCodeStr;

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *province;
@property (weak, nonatomic) IBOutlet UITextField *detailAddress;
@property (weak, nonatomic) IBOutlet UITextField *postalCode;

@end
