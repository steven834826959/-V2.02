//
//  AlertTool.h
//  ailibuli
//
//  Created by ypp on 16/11/11.
//  Copyright © 2016年 Qiaofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertTool : NSObject

+ (UIAlertController *)alertWithTitle:(NSString *)title Message:(NSString *)message actionTitle:(NSString *)ationTitle andStyle:(NSInteger)style;

@end
