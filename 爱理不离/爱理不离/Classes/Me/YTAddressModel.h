//
//  YTAddressModel.h
//  爱理不离
//
//  Created by ypp on 16/12/15.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface YTAddressModel : NSObject


@property (strong, nonatomic) NSString *address;

@property (strong, nonatomic) NSString *city;

@property (strong, nonatomic) NSString *province;

@property (strong, nonatomic) NSString *shippingMobile;

@property (strong, nonatomic) NSString *shippingName;

@property (assign, nonatomic) NSInteger userId;

@property (strong, nonatomic) NSString *userMobile;

@property (strong, nonatomic) NSString *zipCode;


@property (assign, nonatomic) NSInteger ID;

@end
