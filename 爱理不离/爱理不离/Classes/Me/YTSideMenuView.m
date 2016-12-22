//
//  YTSideMenuView.m
//  爱理不离
//
//  Created by Steven on 2016/12/4.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTSideMenuView.h"

@interface YTSideMenuView()

@property(nonatomic,strong)NSMutableArray *buttonArr;

//弹出动画属性
@property (nonatomic, strong) NSArray *menuTitles;
@property(nonatomic,strong)NSArray *menuBgImgs;
@property (nonatomic, strong) NSArray *menuIcons;
@end
@implementation YTSideMenuView




- (instancetype)initWithFrame:(CGRect)frame{
    self  = [super initWithFrame:frame];
    
    if (self) {
        
        for (int i = 0; i < 6; i++) {
            self.backgroundColor = [UIColor clearColor];
            YTContextMenuButton *button = [[YTContextMenuButton alloc]init];
            CGFloat btnH = 60;
            CGFloat btnY = i * (btnH + 5);
            button.frame = CGRectMake(frame.origin.x, btnY, frame.size.width, btnH);
            button.alpha = 0.0;
            [button setImage:[UIImage imageNamed:self.menuIcons[i]] forState:UIControlStateNormal];
            [button setTitle:self.menuTitles[i] forState:UIControlStateNormal];
            button.tag = i;
           
            [button setBackgroundImage:[UIImage resizedImage:self.menuBgImgs[i]] forState:UIControlStateNormal];
             [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [self.buttonArr addObject:button];
        }
        
    }
    
    return self;
}

#pragma mark - custom
- (void)show{
    
    for (int i = 0; i < 6; i++) {
        YTContextMenuButton *button = self.buttonArr[i];
        [UIView animateWithDuration:i * 0.3f animations:^{
            button.alpha = 1.0f;
        } completion:^(BOOL finished) {
            self.hidden = NO;
        }];
        
    }
}
- (void)hide{
    for (int i = 0; i < 6; i++) {
        YTContextMenuButton *button = self.buttonArr[i];
        [UIView animateWithDuration:i * 0.3f animations:^{
            button.alpha = 0.0f;
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
        
    }
}

- (void)buttonClicked:(YTContextMenuButton *)sender{
    NSLog(@"点击按钮的tag值-----%ld",(long)sender.tag);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"sideBtnClicked" object:@{@"tag":@(sender.tag)}];
}





#pragma mark - lazy
- (NSArray *)menuBgImgs{
    if (_menuBgImgs == nil) {
        _menuBgImgs = @[@"个人4",@"个人5",@"个人5",@"个人5",@"个人5",@"个人5"];
    }
    return _menuBgImgs;
}
- (NSArray *)menuIcons{
    if (_menuIcons == nil) {
        _menuIcons = @[@"个人IOCN",@"个人1IOCN",@"个人2IOCN",@"个人6IOCN",@"个人5IOCN",@"个人3"];
    }
    return _menuIcons;
}

- (NSArray *)menuTitles{
    if (_menuTitles == nil){
        
        _menuTitles = @[@"个人信息",@"银行卡管理",@"我的产品",@"个人设置",@"关于我们",@"退出登录"];
    }
    return _menuTitles;
}

- (NSMutableArray *)buttonArr{
    if (_buttonArr == nil) {
        _buttonArr = [NSMutableArray array];
    }
    return _buttonArr;
}

@end
