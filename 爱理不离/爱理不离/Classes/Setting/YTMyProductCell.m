//
//  YTMyProductCell.m
//  爱理不离
//
//  Created by ios on 2016/12/18.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTMyProductCell.h"
@interface YTMyProductCell()
@property(nonatomic,strong)NSMutableArray *labelArr;
@end
@implementation YTMyProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        for (int i = 0; i < 5; i++) {
            UILabel *label = [[UILabel alloc]init];
            [self.contentView addSubview:label];
            [self.labelArr addObject:label];
            
        }
    }

    return self;


}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (int i = 0; i < 5 ; i++) {
        UILabel *label = self.labelArr[i];
        label.frame = CGRectMake(i * SCREEN_WIDTH / 5.0f, 0, SCREEN_WIDTH / 5.0f, self.frame.size.height);
    }
    
}


- (void)setProductModel:(YTMyProductModel *)productModel{
    _productModel = productModel;
    
    //模型赋值
    for (int i = 0; i < 5 ; i++) {
        UILabel *label = self.labelArr[i];
        switch (i) {
            case 0:
                label.text = productModel.name;
                break;
            case 1:
                label.text = [NSString stringWithFormat:@"%d",productModel.count];
                break;
            case 2:
                label.text = [productModel.creatTime changeToDateStr];
                break;
            case 3:
                label.text = [NSString stringWithFormat:@"%d",productModel.money];
                break;
            case 4:
                if (productModel.states == 0) {
                    label.text = @"拥有中";
                }else if(productModel.states == 1){
                    label.text = @"赎回中";
                }else{
                    label.text = @"已赎回";
                }
                
                break;
            default:
                break;
        }
        
        
        
        
    }
    
    
    
    
    
}

#pragma mark - lazy
- (NSMutableArray *)labelArr{
    if (_labelArr == nil) {
        _labelArr = [NSMutableArray array];
    }
    return _labelArr;
}


@end
