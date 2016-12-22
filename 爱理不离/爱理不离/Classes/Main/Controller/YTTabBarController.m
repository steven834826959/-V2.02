//
//  YTTabBarController.m
//  爱理不离
//
//  Created by Steven on 2016/10/15.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTTabBarController.h"
#import "YTServicesViewController.h"
#import "YTProdutViewController.h"
#import "YTMeViewController.h"
#import "YTSettingViewController.h"
#import "YTNavigationController.h"
#import "YTHomeViewController.h"


@interface YTTabBarController ()<ALRadialMenuDelegate>

@end

@implementation YTTabBarController


#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自动登录App
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loginStatus"]) {
        //发送登录请求
//        [self login];
    }
    self.tabBar.hidden = YES;
    self.circleView = [[YTCircleView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 250, [UIScreen mainScreen].bounds.size.height - 250, 250, 250)];
    self.circleView.alpha = 0;
    self.circleView.hidden = YES;
    [self.view addSubview:self.circleView];
    
    self.socialMenu = [[ALRadialMenu alloc] init];
    self.socialMenu.delegate = self;
    self.button = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 70,[UIScreen mainScreen].bounds.size.height - 70, 70, 70)];
    [self.button setImage:[UIImage imageNamed:@"导航按钮"] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    [self initSubViews];
    
    
    //接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(circleViewHidde) name:@"circleViewHidden" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(circleViewShow) name:@"circleViewShow" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 移除之前的4个UITabBarButton
    [self.tabBar removeFromSuperview];
}

#pragma mark - 自定义方法
- (void)circleViewHidde{
    [UIView animateWithDuration:.5 animations:^{
        
        self.circleView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        self.circleView.hidden = YES;
    }];
    
}

- (void)circleViewShow{
    [UIView animateWithDuration:.5 animations:^{
        self.circleView.hidden = NO;
        self.circleView.alpha = 1;
    }];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)buttonPressed{
    [self.socialMenu buttonsWillAnimateFromButton:self.button withFrame:self.button.frame inView:self.view];
}


#pragma mark - radial menu delegate methods
- (NSInteger) numberOfItemsInRadialMenu:(ALRadialMenu *)radialMenu {
    return 4;
}


- (NSInteger) arcSizeForRadialMenu:(ALRadialMenu *)radialMenu {
    return -90;
    
}

//半径长度
- (NSInteger) arcRadiusForRadialMenu:(ALRadialMenu *)radialMenu {
    
    return 110;
}

//设置UI
- (ALRadialButton *) radialMenu:(ALRadialMenu *)radialMenu buttonForIndex:(NSInteger)index {
    ALRadialButton *button = [[ALRadialButton alloc] init];
    if (radialMenu == self.socialMenu) {
        if (index == 0) {
            [button setImage:[UIImage imageNamed:@"dribbble"] forState:UIControlStateNormal];
            //            self. = button
        } else if (index == 1) {
            [button setImage:[UIImage imageNamed:@"iocn1"] forState:UIControlStateNormal];
            [button setTitle:@"首页" forState:UIControlStateNormal];
            [self buttonRotateWithAngle: - M_PI * 2 inView:button];
            self.homeButton = button;
        } else if (index == 2) {
            [button setImage:[UIImage imageNamed:@"iocn3"] forState:UIControlStateNormal];
            [self buttonRotateWithAngle:(- M_PI_2 / 3.0f) * 1.0f inView:button];
            [button setTitle:@"产品" forState:UIControlStateNormal];
            self.productButton = button;
        } else if (index == 3) {
            [button setImage:[UIImage imageNamed:@"iocn2"] forState:UIControlStateNormal];
            [self buttonRotateWithAngle:(- M_PI_2 / 3.0f) * 2.0f inView:button];
            [button setTitle:@"商户" forState:UIControlStateNormal];
            self.sevicesButton = button;
        } else if (index == 4) {
            [button setImage:[UIImage imageNamed:@"iocn4"] forState:UIControlStateNormal];
            self.meButton = button;
            //开始动画
            [self buttonRotateWithAngle:- M_PI_2 inView:button];
            [button setTitle:@"我" forState:UIControlStateNormal];
            
        }
        
    }
        return button;
}


- (void) radialMenu:(ALRadialMenu *)radialMenu didSelectItemAtIndex:(NSInteger)index {
    if (radialMenu == self.socialMenu) {
        [self.socialMenu itemsWillDisapearIntoButton:self.button];
        self.selectedIndex = index - 1;
    }
    
}


- (void)buttonRotateWithAngle:(float)angle inView:(ALRadialButton *)button;{
    
    //开始动画
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //            rotationAnimation.delegate = self;
    rotationAnimation.toValue = [NSNumber numberWithFloat:angle];
    rotationAnimation.duration = .3f;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeBoth;
    [button.layer addAnimation:rotationAnimation forKey:@"revItUpAnimation"];
}

- (void)initSubViews{
    YTHomeViewController *home = [[YTHomeViewController alloc]init];
    YTNavigationController *nav1 = [[YTNavigationController alloc]initWithRootViewController:home];
    [self addChildViewController:nav1];
    
    YTProdutViewController *product = [[YTProdutViewController alloc]init];
    YTNavigationController *nav2 = [[YTNavigationController alloc]initWithRootViewController:product];
    [self addChildViewController:nav2];
    YTServicesViewController *sevices = [[YTServicesViewController alloc]init];
    YTNavigationController *nav3 = [[YTNavigationController alloc]initWithRootViewController:sevices];
    [self addChildViewController:nav3];
    
    YTMeViewController *me = [[YTMeViewController alloc]init];
    YTNavigationController *nav4 = [[YTNavigationController alloc]initWithRootViewController:me];
    [self addChildViewController:nav4];
}

@end
