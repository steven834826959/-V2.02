//
//  YTScoreChangeModel.h
//  爱理不离
//
//  Created by ios on 16/12/15.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface YTScoreChangeModel : NSObject
@property(nonatomic,assign)int type;//类型 0 消费  1 收获
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)int amount;//数量
@property(nonatomic,assign)int service_id;//服务id
@end
