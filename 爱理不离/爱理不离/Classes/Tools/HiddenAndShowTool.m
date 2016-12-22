//
//  HiddenAndShowTool.m
//  新版框架
//
//  Created by ios on 16/12/1.
//  Copyright © 2016年 ytshanghai. All rights reserved.
//

#import "HiddenAndShowTool.h"

@interface HiddenAndShowTool ()

@end

@implementation HiddenAndShowTool

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)hide{
    
        YTTabBarController *main = (YTTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        main.button.hidden = YES;
        main.socialMenu.hidden = YES;
        main.circleView.hidden = YES;
        main.homeButton.hidden = YES;
        main.productButton.hidden = YES;
        main.sevicesButton.hidden = YES;
        main.meButton.hidden = YES;
    
}
+ (void)show{
    
    YTTabBarController *main = (YTTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    main.button.hidden = NO;
    main.socialMenu.hidden = NO;
    main.circleView.hidden = NO;
    main.homeButton.hidden = NO;
    main.productButton.hidden = NO;
    main.sevicesButton.hidden = NO;
    main.meButton.hidden = NO;
}
@end
