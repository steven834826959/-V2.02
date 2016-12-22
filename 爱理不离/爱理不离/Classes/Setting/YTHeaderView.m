//
//  YTHeaderView.m
//  爱理不离
//
//  Created by ios on 2016/12/18.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTHeaderView.h"
#import "YTTitleView.h"
@interface YTHeaderView()


@property(nonatomic,strong)UIImageView *countView;
@property(nonatomic,strong)UIImageView *scoreView;
@property(nonatomic,strong)UIView *titleView;
@end
@implementation YTHeaderView


- (instancetype)initWithMyScore:(int)score procutCountArr:(NSArray *)procutCountArr{
    
    self = [super init];
    
    if (self) {
        UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 250)];
        self.countView = [[UIImageView alloc]init];
        self.scoreView = [[UIImageView alloc]init];
        self.titleView = [[UIView alloc]init];
        
        self.countView.backgroundColor = [UIColor redColor];
        self.scoreView.backgroundColor = [UIColor blueColor];
        
        
        self.titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
        self.countView.frame = CGRectMake(0, 120, SCREEN_WIDTH, 40);
        self.scoreView.frame = CGRectMake(0, 160, SCREEN_WIDTH, 40);
        
        
        for (int i = 0; i < 3; i++) {
            
            YTTitleView *title = [[YTTitleView alloc]init];
            title.frame = CGRectMake(i * SCREEN_WIDTH/ 3.0f, 0, SCREEN_WIDTH/ 3.0f, self.titleView.frame.size.height);
            NSArray *titleTextArr = @[@"爱你妹",@"守爱侠",@"潘多拉"];
            NSArray *titleImgArr = @[@"chanping3@2X-1",@"chanping4@2X-1",@"panduola@2x-1"];
           
            title.headerImg.image = [UIImage imageNamed:titleImgArr[i]];
            title.descLabel.text = titleTextArr[i];
            
    
            [self.titleView addSubview:title];
            
            UILabel *countLabel = [[UILabel alloc]init];
            countLabel.textAlignment = NSTextAlignmentCenter;
            countLabel.frame = CGRectMake(i * SCREEN_WIDTH / 3.0f, 0, SCREEN_WIDTH / 3.0f, self.countView.frame.size.height);
            
            NSArray *productArr = @[@1,@1,@1];
            countLabel.text = [NSString stringWithFormat:@"%@个",productArr[i]];
            
            [self.countView addSubview:countLabel];
            
            UILabel *scoreLabel = [[UILabel alloc]init];
            scoreLabel.textAlignment = NSTextAlignmentCenter;
            NSArray *scoreText = @[@"获得积分",@"",[NSString stringWithFormat:@"%d",100]];
            scoreLabel.frame = CGRectMake(i * SCREEN_WIDTH / 3.0f, 0, SCREEN_WIDTH / 3.0f, self.scoreView.frame.size.height);
            scoreLabel.text = scoreText[i];
            [self.scoreView addSubview:scoreLabel];
        }
        
        [baseView addSubview:self.titleView];
        [baseView addSubview:self.countView];
        [baseView addSubview:self.scoreView];
        //展示View
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scoreView.frame), SCREEN_WIDTH, 50)];
        
        UIView *introductionView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 30)];
        
        
        for (int i = 0; i < 5; i++) {
            UILabel *indructionLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * SCREEN_WIDTH / 5.0f, 0, SCREEN_WIDTH/ 5.0f, 30)];
            indructionLabel.textAlignment = NSTextAlignmentCenter;
            NSArray *inTextArr = @[@"产品",@"数量",@"时间",@"金额",@"状态"];
            indructionLabel.text = inTextArr[i];
            [introductionView addSubview:indructionLabel];
        }
        
        [bottomView addSubview:introductionView];
        
        [baseView addSubview:bottomView];
        
        [self addSubview:baseView];
    }
    
    
    return self;
}


@end
