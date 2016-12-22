//
//  YTAddressModel.m
//  爱理不离
//
//  Created by ypp on 16/12/15.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTAddressModel.h"

@implementation YTAddressModel
- (instancetype)init {
    if (self = [super init]) {
        [YTAddressModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID":@"id"};
        }];
    }
    return self;
}
@end
