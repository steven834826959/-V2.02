//
//  AlertTool.m
//  ailibuli
//
//  Created by ypp on 16/11/11.
//  Copyright © 2016年 Qiaofeng. All rights reserved.
//

#import "AlertTool.h"

@implementation AlertTool

+ (UIAlertController *)alertWithTitle:(NSString *)title Message:(NSString *)message actionTitle:(NSString *)actionTitle andStyle:(NSInteger)style {
    if (style == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *act = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            //提示之后的操作
            
        }];
        [alertController addAction:act];
        return alertController;
    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *act = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            //提示之后的操作
            
        }];
        [alertController addAction:act];
        
        return alertController;
    }
    
}
@end
