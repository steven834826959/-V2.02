//
//  ForgetPwdVC.h
//  YPP
//
//  Created by ypp on 16/10/28.
//  Copyright © 2016年 ypp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ForgetPwdVC;
@protocol ForgetPwdDelegate<NSObject>

- (void)forgotValuesBackToLoginViewController:(ForgetPwdVC *)sender mobile:(NSString *)mobile pwd:(NSString *)pwd;

@end
@interface ForgetPwdVC : UIViewController
@property(nonatomic,weak)id<ForgetPwdDelegate>delegate;

@end
