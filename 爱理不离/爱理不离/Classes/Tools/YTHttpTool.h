//
//  YTHttpTool.h
//  爱理不离
//
//  Created by Steven on 2016/10/15.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^MyCallBack)(id obj);
@interface YTHttpTool : NSObject
/**发送get请求*/
+ (void)get:(NSString *)url parameters:(NSDictionary *)parameters withCallBack:(MyCallBack)calllBack;

/**发送post请求*/
+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters withCallBack:(MyCallBack)calllBack;



@end
