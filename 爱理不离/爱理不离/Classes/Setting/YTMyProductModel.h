//
//  YTMyProductModel.h
//  爱理不离
//
//  Created by ios on 2016/12/18.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTMyProductModel : NSObject
@property(nonatomic,copy)NSString *orderId;//订单id
@property(nonatomic,copy)NSString *name;//产品名称
@property(nonatomic,assign)int count;//数量
@property(nonatomic,copy)NSString *creatTime;//购买时间
@property(nonatomic,assign)int money;//金额
@property(nonatomic,assign)int states;//状态

@end
