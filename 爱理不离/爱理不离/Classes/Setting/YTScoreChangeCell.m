//
//  YTScoreChangeCell.m
//  爱理不离
//
//  Created by ios on 16/12/15.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTScoreChangeCell.h"
@interface YTScoreChangeCell()
@property(nonatomic,strong)UIView *baseView;
@property(nonatomic,strong)NSMutableArray *labelArr;



@end
@implementation YTScoreChangeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, self.frame.size.height - 10)];
        
        [self.contentView addSubview:self.baseView];
        
        
        for (int i = 0; i < 3; i++) {
            UILabel *detailLabel = [[UILabel alloc]init];
            detailLabel.textAlignment = NSTextAlignmentCenter;
            [self.baseView addSubview:detailLabel];
            [self.labelArr addObject:detailLabel];
            
        }
        

    }

    return self;


}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (int i = 0; i < 3; i++) {
        UILabel *detailLabel = self.labelArr[i];
        
        detailLabel.frame = CGRectMake(i * SCREEN_WIDTH / 3.0f, 0, SCREEN_WIDTH / 3.0f, self.baseView.frame.size.height);
    }
}

- (void)setChanged:(YTScoreChangeModel *)changed{
    _changed = changed;
    
    for (int i = 0; i < 3; i++) {
       UILabel *detailLabel = self.labelArr[i];
        
        switch (i) {
            case 0:
                detailLabel.text = changed.name;
                break;
            case 1:
                detailLabel.text = [NSString stringWithFormat:@"%d",changed.amount];
                break;
            case 2:
                detailLabel.text = changed.type == 0 ? @"未使用" : @"已使用";
                break;
            default:
                break;
        }
        
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - lazy
- (NSMutableArray *)labelArr{
    if (_labelArr == nil) {
        _labelArr = [NSMutableArray array];
    }
    return _labelArr;
}


@end
