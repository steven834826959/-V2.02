//
//  YTPickerView.h
//  爱理不离
//
//  Created by ios on 16/12/6.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MyBasicBlock)(id result);

@interface YTPickerView : UIView
@property (retain, nonatomic) NSArray *arrPickerData;
@property (retain, nonatomic) UIPickerView *pickerView;
@property (nonatomic, copy) MyBasicBlock selectBlock;
- (void)popPickerView;
@end
