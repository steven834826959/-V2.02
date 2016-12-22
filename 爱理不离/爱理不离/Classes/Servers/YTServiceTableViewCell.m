//
//  YTServiceTableViewCell.m
//  ServiceTest
//
//  Created by ypp on 16/12/9.
//  Copyright © 2016年 YongtTong. All rights reserved.
//

#import "YTServiceTableViewCell.h"

@implementation YTServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.cellBgImg.image = [UIImage resizedImage:@"商户@2x-1"];
    
    self.circleImageView.layer.cornerRadius = self.circleImageView.frame.size.width / 2.0f;
    
   
    self.circleImageView.layer.masksToBounds = YES;
    
    self.backgroundColor = [UIColor clearColor];

    
    
    
}

- (void)setShopModel:(YTShopModel *)shopModel{
    _shopModel = shopModel;
    
    NSArray *urlArr = [shopModel.image componentsSeparatedByString:@","];
    
    
    [self.circleImageView sd_setImageWithURL:[NSURL URLWithString:[kDominURL URLStringWithStr:urlArr.lastObject]]];
    self.topLabel.text = shopModel.name;
    self.downLabel.font = [UIFont systemFontOfSize:12];
    self.downLabel.numberOfLines = 0;
    self.downLabel.text = shopModel.address;
    
}

- (void)setSeviceModel:(YTServiceModel *)seviceModel{
    _seviceModel = seviceModel;
    
    self.topLabel.text = seviceModel.name;
    self.downLabel.text = [NSString stringWithFormat:@"积分：%d",seviceModel.credits];
    [self.circleImageView sd_setImageWithURL:[NSURL URLWithString:[kDominURL URLStringWithStr:seviceModel.carousel]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
