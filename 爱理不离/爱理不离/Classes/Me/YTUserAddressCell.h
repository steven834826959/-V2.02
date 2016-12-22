//
//  YTUserAddressCell.h
//  爱理不离
//
//  Created by ypp on 16/12/7.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTAddressModel.h"
@interface YTUserAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *userAddress;
@property (weak, nonatomic) IBOutlet UIButton *reviseAddress;
@property (weak, nonatomic) IBOutlet UIButton *deleteAddress;

@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@property (strong, nonatomic) YTAddressModel *model;

@end
