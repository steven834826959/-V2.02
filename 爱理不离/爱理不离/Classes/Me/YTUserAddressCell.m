//
//  YTUserAddressCell.m
//  爱理不离
//
//  Created by ypp on 16/12/7.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTUserAddressCell.h"

@implementation YTUserAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.selectedBtn addTarget:self action:@selector(changeBackgroundmage) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(YTAddressModel *)model {
    
    _model = model;
    self.phoneNumber.text = model.shippingMobile;
    
    
}
#pragma mark ToolMethods
- (void)changeBackgroundmage {
    [self.selectedBtn setBackgroundImage:[UIImage imageNamed:@"感情5"] forState:UIControlStateNormal];
}
@end
