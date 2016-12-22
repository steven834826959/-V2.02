//
//  YTShopModel.m
//  爱理不离
//
//  Created by ios on 16/12/15.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTShopModel.h"

@implementation YTShopModel
- (instancetype)init{
    
    if (self=[super init]) {
        
        [YTShopModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"shopId" : @"id"
                     };
        }];
        
    }
    return self;
}

@end
