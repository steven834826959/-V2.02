//
//  YTPersonalSettingVC.h
//  爱理不离
//
//  Created by ios on 16/12/5.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTPersonalSettingVC;
@protocol YTPersonalSettingVCDelegate<NSObject>
- (void)valuesBack:(YTPersonalSettingVC *)sender andValues:(NSString *)values;

@end
@interface YTPersonalSettingVC : UIViewController
@property(nonatomic,weak)id<YTPersonalSettingVCDelegate>delegate;

@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,copy)NSString *editStr;
@property(nonatomic,assign)BOOL isChoose;
@property(nonatomic,strong)UITextField *infoTF;

@end
