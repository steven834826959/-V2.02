//
//  NSString+URL.m
//  YPP
//
//  Created by ios on 16/11/24.
//  Copyright © 2016年 ypp. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

- (NSString *)URLStringWithStr:(NSString *)str{
    NSString *appendStr = [self stringByAppendingString:str];
    return appendStr;
}
@end
