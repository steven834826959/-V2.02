//
//  YTServiceModel.m
//  爱理不离
//
//  Created by ypp on 16/12/14.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTServiceModel.h"

@implementation YTServiceModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [YTServiceModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
           return  @{
              @"seviceId" : @"id"
              };
        }];
    }
    return self;
}


@end
