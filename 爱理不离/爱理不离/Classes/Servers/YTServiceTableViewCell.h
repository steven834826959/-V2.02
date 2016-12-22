//
//  YTServiceTableViewCell.h
//  ServiceTest
//
//  Created by ypp on 16/12/9.
//  Copyright © 2016年 YongtTong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTShopModel.h"
#import "YTServiceModel.h"
@interface YTServiceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property(nonatomic,strong)YTShopModel *shopModel;
@property(nonatomic,strong)YTServiceModel *seviceModel;

@property (weak, nonatomic) IBOutlet UIImageView *cellBgImg;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property(nonatomic,strong)UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *downLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellBackImage;

@end
