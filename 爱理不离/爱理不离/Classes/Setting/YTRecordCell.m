//
//  YTRecordCell.m
//  爱理不离
//
//  Created by Steven on 2016/12/7.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTRecordCell.h"
@interface YTRecordCell()
@property(nonatomic,strong)NSMutableArray *labels;
@end
@implementation YTRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        for (int i = 0; i < 3 ; i++) {
            UILabel *label = [[UILabel alloc]init];
            label.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:label];
            [self.labels addObject:label];
        }
        
    }
    return self;
}

- (void)layoutSubviews{
    for (int i = 0; i < 3; i++) {
        UILabel *label = self.labels[i];
        label.frame = CGRectMake(i * SCREEN_WIDTH / 3.0f, 0, SCREEN_WIDTH / 3.0f, self.frame.size.height);
    }
}


- (void)setRecord:(YTRecodModel *)record{
    _record = record;
    //设置数据
    for (int i = 0; i < 3; i++) {
        UILabel *label = self.labels[i];
        if (i == 0) {
            switch (record.type) {
                case 1:
                    label.text = @"充值";
                    break;
                case 2:
                    label.text = @"消费";
                    break;
                case 3:
                    label.text = @"交易";
                    break;
                case 4:
                    label.text = @"提现";
                    break;
                default:
                    break;
            }
        }else if (i == 1){
            label.text = [NSString stringWithFormat:@"%f",record.money];
        }else{
            label.text = [NSString stringWithFormat:@"%@",[record.create_time changeToDateStr]];
        }
    }
}

#pragma mark - lazy
- (NSMutableArray *)labels{
    if (_labels == nil) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}
@end
