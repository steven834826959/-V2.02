//
//  YTProuctModel.h
//  爱理不离
//
//  Created by ypp on 16/12/9.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTProuctModel : NSObject

@property (assign, nonatomic) NSInteger categoryId;//产品分类ID

@property (copy, nonatomic) NSString *name;//产品名称

@property (assign, nonatomic)int product_Id;//产品Id

@property (assign, nonatomic) NSInteger minBuy;//起够金额

@property (assign, nonatomic) NSInteger maxBuy;//最大购买额

@property (assign, nonatomic) int credits;//积分

@property (assign, nonatomic) NSInteger deadline;//截止日期

@property (strong, nonatomic) NSString *image; //显示截图

@property (copy, nonatomic) NSString *productDesc;//产品描述

@property (assign, nonatomic) NSInteger sellCount;

@property (assign, nonatomic) float annualRate;//利率




@end
