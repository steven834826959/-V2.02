//
//  YTProuctModel.m
//  爱理不离
//
//  Created by ypp on 16/12/9.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTProuctModel.h"
#import "MJExtension.h"
@implementation YTProuctModel

- (instancetype)init {
    if (self = [super init]) {
        [YTProuctModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"product_Id":@"id"};
        }];
    }
    return self;
}

@end
