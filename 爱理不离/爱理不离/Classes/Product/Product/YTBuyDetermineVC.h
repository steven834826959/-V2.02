//
//  YTBuyDetermineVC.h
//  爱理不离
//
//  Created by Steven on 2016/12/7.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YTProuctModel.h"
@interface YTBuyDetermineVC : UIViewController
@property(nonatomic,assign)int amountMoney;
@property(assign,nonatomic)float rate;
@property(nonatomic,assign)int count;
@property(nonatomic,strong)YTProuctModel *productModel;
@end
