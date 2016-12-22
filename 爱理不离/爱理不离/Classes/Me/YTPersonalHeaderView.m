//
//  YTPersonalHeaderView.m
//  爱理不离
//
//  Created by ios on 16/12/2.
//  Copyright © 2016年 . All rights reserved.
//

#import "YTPersonalHeaderView.h"
#import "YTUserModel.h"
@implementation YTPersonalHeaderView

- (void)setupWithFrame:(CGRect)frame headerImage:(NSString *)headerImageUrl myScore:(int)score balanceMoney:(float)balance{
    self.backgroundColor = [UIColor clearColor];
    self.frame = frame;
    //设置背景视图
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
//    backView.image = headerImage;
    [backView sd_setImageWithURL:[NSURL URLWithString:headerImageUrl]];
    [self addSubview:backView];
    //设置圆形图像
    UIImageView *roundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    roundImg.layer.cornerRadius = 60;
    roundImg.layer.masksToBounds = YES;
    roundImg.userInteractionEnabled = YES;
    roundImg.center = CGPointMake(SCREEN_WIDTH * 0.5, CGRectGetMaxY(backView.frame) - 20);
    
    [roundImg sd_setImageWithURL:[NSURL URLWithString:headerImageUrl]];
    [self addSubview:roundImg];
    
    roundImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageTaped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(roundImageTaped)];
    [roundImg addGestureRecognizer:imageTaped];

    //设置积分余额视图
    UIButton *scoreButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5 - 120, frame.size.height - 55, 120, 55)];
    [scoreButton setImage:[UIImage imageNamed:@"积分"] forState:UIControlStateNormal];
    [scoreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [scoreButton setTitle:[NSString stringWithFormat:@"积分  %d",score] forState:UIControlStateNormal];
    UIButton *balancButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5, frame.size.height - 55, 120, 55)];
    [balancButton setImage:[UIImage imageNamed:@"余额"] forState:UIControlStateNormal];
    [balancButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [balancButton setTitle:[NSString stringWithFormat:@"余额  %.1f",balance] forState:UIControlStateNormal];
    scoreButton.adjustsImageWhenHighlighted = NO;
    scoreButton.enabled = NO;
    balancButton.adjustsImageWhenHighlighted = NO;
    balancButton.enabled = NO;
    
    [self addSubview:scoreButton];
    [self addSubview:balancButton];
}

- (void)roundImageTaped{

    [[NSNotificationCenter defaultCenter]postNotificationName:@"roundImageTaped" object:nil];
}

@end
