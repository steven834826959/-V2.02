//
//  UIView+HUD.h
//  YPP
//
//  Created by ypp on 16/8/1.
//  Copyright © 2016年 ypp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIView (HUD)
//忙提示
- (void)showBusyHUD;
//文字提示
- (void)showWarning:(NSString *)warning;
//隐藏提示
- (void)hideBusyHUD;
@end

