//
//  YTProductListVC.h
//  爱理不离
//
//  Created by ypp on 16/12/5.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTProuctModel.h"
@interface YTProductListVC : UIViewController
@property(nonatomic,strong)YTProuctModel *product;
@property(nonatomic,copy)NSString *productName;
@end
