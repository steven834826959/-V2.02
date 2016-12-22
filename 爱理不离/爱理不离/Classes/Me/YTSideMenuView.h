//
//  YTSideMenuView.h
//  爱理不离
//
//  Created by Steven on 2016/12/4.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTContextMenuButton.h"
@interface YTSideMenuView : UIView
@property(nonatomic,strong)YTContextMenuButton *button;
- (void)show;
- (void)hide;
@end
