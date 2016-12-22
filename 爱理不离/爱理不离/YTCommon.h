//
//  YTCommon.h
//  爱理不离
//
//  Created by Steven on 2016/10/15.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#ifndef YTCommon_h
#define YTCommon_h
// 2.获得RGB颜色
#define YTColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 3.全局背景色
#define YTGlobalBg IWColor(232, 233, 232)

// 4.自定义Log
#ifdef DEBUG
#define YTLog(...) NSLog(__VA_ARGS__)
#else
#define YTLog(...)
#endif

// 5.颜色、字体常量
/** 导航栏 */
// 导航栏标题颜色
#define YTNavigationBarTitleColor YTColor(65, 65, 65)
// 导航栏标题字体
#define YTNavigationBarTitleFont [UIFont boldSystemFontOfSize:19]

// 导航栏按钮文字颜色
#define YTBarButtonTitleColor YTColor(239, 113, 0)
#define YTBarButtonTitleDisabledColor YTColor(208, 208, 208)

// 导航栏按钮文字字体
#define YTBarButtonTitleFont [UIFont systemFontOfSize:15]
// 6.常用的尺寸
/** 表格边框的宽度 */
extern const CGFloat YTTableBorderW;
/** cell之间的间距 */
extern const CGFloat YTCellMargin;

// 7.数据存储
#define YTUserDefaults [NSUserDefaults standardUserDefaults]


#endif /* YTCommon_h */
