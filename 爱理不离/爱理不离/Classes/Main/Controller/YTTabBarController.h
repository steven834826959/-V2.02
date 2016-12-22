//
//  YTTabBarController.h
//  爱理不离
//
//  Created by Steven on 2016/10/15.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALRadialMenu.h"
#import "YTCircleView.h"
#import "ALRadialButton.h"
@interface YTTabBarController : UITabBarController
@property (strong, nonatomic) ALRadialMenu *socialMenu;
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)YTCircleView *circleView;

@property(nonatomic,strong)ALRadialButton *meButton;
@property(nonatomic,strong)ALRadialButton *productButton;
@property(nonatomic,strong)ALRadialButton *sevicesButton;
@property(nonatomic,strong)ALRadialButton *homeButton;
@end
