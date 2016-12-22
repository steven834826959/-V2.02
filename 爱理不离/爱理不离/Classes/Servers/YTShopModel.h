//
//  YTShopModel.h
//  爱理不离
//
//  Created by ios on 16/12/15.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface YTShopModel : NSObject
@property(nonatomic,copy)NSString *shopId;
@property(nonatomic,copy)NSString *name;//名称
@property(nonatomic,copy)NSString *phone;//手机号码
@property(nonatomic,copy)NSString *image;//图片
@property(nonatomic,copy)NSString *address;//地址
@property(nonatomic,assign)int type;//类型
@property(nonatomic,copy)NSString *site;
@property(nonatomic,assign)int merchantCategoryId;
@property(nonatomic,copy)NSString *introduction;
@end
/*
 {
 address = "\U4e0a\U6d77\U5e02\U95f5\U884c\U533a\U6d66\U6c5f\U9547\U6c5f\U6708\U8def";
 createTime = 1479892106000;
 id = 4;
 image = ",/upload/ailibuli/product/3bdc0e4e60ba894dcd1620ded5b5f4ad.jpg";
 introduction = "<null>";
 isShow = 1;
 merchantCategoryId = 4;
 name = "\U7855\U9053\U4fe1\U606f";
 phone = 12345678901;
 site = "www.123.com";
 sort = 20;
 type = 2;
 writerId = sodo;
 },

*/
