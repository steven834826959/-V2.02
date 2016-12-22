//
//  YTNavigationController.m
//  爱理不离
//
//  Created by Steven on 2016/10/15.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTNavigationController.h"
#import "HiddenAndShowTool.h"
@interface YTNavigationController ()
@property (nonatomic,strong) UIButton *backBtn;
@end

@implementation YTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 重新拥有滑动出栈的功能
    self.interactivePopGestureRecognizer.delegate = nil;
    

 
}

/**
 *  第一次使用这个类的时候会调用(1个类只会调用1次)
 */
+ (void)initialize
{
    //设置导航栏按钮主题
//    [self setupTitleTheme];
    // 取出appearance对象
    UINavigationBar *navBar = [UINavigationBar appearance];

    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor] = [UIColor whiteColor];
    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    textAttrs[UITextAttributeFont] = [UIFont boldSystemFontOfSize:19];
    [navBar setTitleTextAttributes:textAttrs];
    
    // 2.设置导航栏按钮主题
    [self setupBarButtonItemTheme];
    
}

/**
 *  设置导航栏按钮主题
 */
+ (void)setupBarButtonItemTheme
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    //设置文本颜色
    textAttrs[UITextAttributeTextColor] = [UIColor whiteColor];
    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    textAttrs[UITextAttributeFont] = [UIFont systemFontOfSize:16];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];
}




/**隐藏掉tabbar*/
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        
        [HiddenAndShowTool hide];
    }
    [super pushViewController:viewController animated:animated];
}




@end
