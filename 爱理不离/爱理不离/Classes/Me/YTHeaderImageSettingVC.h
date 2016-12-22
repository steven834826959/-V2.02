//
//  YTHeaderImageSettingVC.h
//  爱理不离
//
//  Created by ios on 16/12/7.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTHeaderImageSettingVC;
@protocol YTHeaderImageSettingVCDelegate <NSObject>
- (void)imageBackToMeVC:(YTHeaderImageSettingVC *)sender image:(UIImage *)headImage;
@end
@interface YTHeaderImageSettingVC : UIViewController
@property(nonatomic,strong)UIImage *headImg;
@property(nonatomic,weak)id<YTHeaderImageSettingVCDelegate>delegate;
@end
