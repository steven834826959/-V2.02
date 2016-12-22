//
//  YTRecodModel.h
//  爱理不离
//
//  Created by Steven on 2016/12/7.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface YTRecodModel : NSObject
@property(nonatomic,assign)int type;//交易类型  1 充值 2消费 3交易 4 提现
@property(nonatomic,copy)NSString *create_time;//购买时间
@property(nonatomic,assign)float money;//购买钱数
@end
