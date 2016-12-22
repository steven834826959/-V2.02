//
//  NSString+YTDateStr.m
//  爱理不离
//
//  Created by ios on 2016/12/21.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "NSString+YTDateStr.h"

@implementation NSString (YTDateStr)

- (NSString *)changeToDateStr;{
    
    NSDate *stampDate = [NSDate dateWithTimeIntervalSince1970:[self longLongValue] / 1000.0f];
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //用[NSDate date]可以获取系统当前时间
    
    NSString *dateStr = [dateFormatter stringFromDate:stampDate];
    return dateStr;
    
}


- (NSString *)changToDateIntervalStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:self];
    NSTimeInterval interval = date.timeIntervalSince1970 * 1000.0f;
    return [NSString stringWithFormat:@"%f",interval];
}

@end
