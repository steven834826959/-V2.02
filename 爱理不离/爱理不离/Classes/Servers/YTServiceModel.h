//
//  YTServiceModel.h
//  爱理不离
//
//  Created by ypp on 16/12/14.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface YTServiceModel : NSObject
@property(nonatomic,assign)int seviceId;


@property (strong, nonatomic) NSString *carousel;//展示图片

@property (strong, nonatomic) NSString *cover;//封面

@property (assign, nonatomic) int loveStatus;//情感状态

@property (strong, nonatomic) NSString *name;//服务名称

@property (strong, nonatomic) NSString *serviceNo;//服务编号

@property (strong, nonatomic) NSString *createTime;//开始时间

@property (strong, nonatomic) NSString *endTime;//截止时间

@property (assign, nonatomic) NSInteger type;//类型

@property(nonatomic,assign)int credits;//积分

@property(nonatomic,assign)int stock;//库存

@property(nonatomic,copy)NSString *remark;//备注
@end
/*
 {"id":2,"name":"花好月圆","carousel":"/upload/ailibuli/product/a566b852131f8e9288273ff8462b0b65.jpg","cover":",/upload/ailibuli/product/a566b852131f8e9288273ff8462b0b65.jpg,/upload/ailibuli/product/bf23cb0b2d0f69e53df2a19c7fde6a42.png","type":3,"loveStatus":3,"startTime":1479657600000,"endTime":1487001600000,"credits":100,"stock":200,"status":1,"writerId":"sodo","createTime":1479697853000,"serviceNo":"qq111","remark":"
 \t\t\t\t\t\t\t\t\t\t\t
 
 
 俄不到我配帆布钱包丰富表情包我背负 i 帮我付钱哦吧佛 i 欺负你起哦；不去北方吧佛不进去不起绿波开发不能把房间吧佛前部分 i 哦
 
 
 
 
 
 \r\n\t\t\t\t\t\t\t\t\t\t","sort":null,"merchantId":2}
 */








