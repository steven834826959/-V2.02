//
//  YTTitleView.m
//  爱理不离
//
//  Created by ios on 2016/12/18.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTTitleView.h"

@implementation YTTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.图片
        self.headerImg = [[UIImageView alloc]init];
        self.headerImg.contentMode = UIViewContentModeScaleAspectFit;
        //文字
        self.descLabel = [[UILabel alloc]init];
        self.descLabel.textAlignment = NSTextAlignmentCenter;
        self.descLabel.textColor = [UIColor whiteColor];
        
        
        [self addSubview:self.headerImg];
        [self addSubview:self.descLabel];
        
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.headerImg.frame = CGRectMake(0, 0, SCREEN_WIDTH / 3.0f, 100);
    self.descLabel.frame = CGRectMake(0, 100, SCREEN_WIDTH / 3.0f, 20);
}



@end
