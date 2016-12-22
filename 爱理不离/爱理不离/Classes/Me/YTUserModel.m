//
//  YTUserModel.m
//  爱理不离
//
//  Created by ios on 16/12/7.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTUserModel.h"
#import "MJExtension.h"
@implementation YTUserModel
singleton_implementation(YTUserModel)
// NSCoding实现
MJExtensionCodingImplementation

- (instancetype)init{
    
    if (self=[super init]) {
        
        [YTUserModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{
                     @"ID" : @"id"
                     };
        }];
        
    }
    return self;
}


@end
