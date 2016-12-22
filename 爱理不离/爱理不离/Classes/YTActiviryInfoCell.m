//
//  YTActiviryInfoCell.m
//  爱理不离
//
//  Created by ios on 2016/12/20.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTActiviryInfoCell.h"
@interface YTActiviryInfoCell()
@property(nonatomic,strong)NSMutableArray *labels;
@end
@implementation YTActiviryInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        for (int i = 0; i < 3; i++) {
            UILabel *label = [[UILabel alloc]init];
            label.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:label];
            [self.labels addObject:label];
        }
 
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    for (int i = 0; i < 3; i++) {
        UILabel *label = self.labels[i];
        label.frame = CGRectMake(i * SCREEN_WIDTH / 3.0f, 0, SCREEN_WIDTH / 3.0f, self.frame.size.height);
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
