//
//  YTBankCell.m
//  爱理不离
//
//  Created by ios on 16/12/15.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTBankCell.h"
@interface YTBankCell()
@property(nonatomic,strong)UIImageView *bankView;
@property(nonatomic,strong)UIView *lineView;
@end
@implementation YTBankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //bank主视图
        self.bankView = [[UIImageView alloc]init];
        UIImage *baseImg = [UIImage imageNamed:@"确认密码"];
        self.bankView.userInteractionEnabled = YES;
        self.bankView.image = [baseImg resizableImageWithCapInsets:UIEdgeInsetsMake(60, 60, 100, 100) resizingMode:UIImageResizingModeStretch];

//        self.bankView.layer.cornerRadius = 10;
//        self.bankView.layer.borderColor = [UIColor redColor].CGColor;
//        self.bankView.layer.borderWidth = 1;
//        self.bankView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.bankView];
        //银行卡视图
        self.bankTitle = [[UILabel alloc]init];
        self.bankTitle.text = @"银行卡";
        self.bankTitle.textColor = [UIColor lightGrayColor];
        self.bankTitle.font = [UIFont systemFontOfSize:25];
        [self.bankView addSubview:self.bankTitle];
        
        self.bankNameLabel = [[UILabel alloc]init];
        self.bankNameLabel.textColor = [UIColor lightGrayColor];
        [self.bankView addSubview:self.bankNameLabel];
        //分隔线
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = [UIColor lightGrayColor];
        self.lineView.alpha = .5f;
        [self.bankView addSubview:self.lineView];
        //银行卡号
        self.bankNumLabel = [[UILabel alloc]init];
        self.bankNumLabel.textColor = [UIColor lightGrayColor];
        [self.bankView addSubview:self.bankNumLabel];
        
        self.backgroundColor = [UIColor clearColor];

    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.bankView.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 150);
    self.bankTitle.frame = CGRectMake(20, 5, self.bankView.frame.size.width, 50);
    self.lineView.frame = CGRectMake(20, CGRectGetMaxY(self.bankTitle.frame), self.bankView.frame.size.width - 40, 1);
    self.bankNameLabel.frame = CGRectMake(20, CGRectGetMaxY(self.lineView.frame) + 8, self.bankView.frame.size.width, 30);
    self.bankNumLabel.frame = CGRectMake(20, CGRectGetMaxY(self.bankNameLabel.frame) + 5, self.bankView.frame.size.width, 30);
}

@end
