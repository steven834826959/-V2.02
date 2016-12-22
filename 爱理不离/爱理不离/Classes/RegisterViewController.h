//
//  RegisterViewController.h
//  YPP
//
//  Created by ypp on 16/10/28.
//  Copyright © 2016年 ypp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RegisterViewController;
@protocol RegisterViewControllerDelegate<NSObject>
- (void)valuesBackToLoginViewController:(RegisterViewController *)sender mobile:(NSString *)mobile pwd:(NSString *)pwd;
@end
@interface RegisterViewController : UIViewController
@property(nonatomic,weak)id<RegisterViewControllerDelegate>delegate;

@end
