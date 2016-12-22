//
//  YTPersonalHeaderView.h
//  爱理不离
//
//  Created by ios on 16/12/2.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTPersonalHeaderView : UIView

- (void)setupWithFrame:(CGRect)frame headerImage:(NSString *)headerImageUrl myScore:(int)score balanceMoney:(float)balance;

@property(nonatomic,strong)UIImageView *roundImg;
@property(nonatomic,strong)UIImageView *backView;

@end

