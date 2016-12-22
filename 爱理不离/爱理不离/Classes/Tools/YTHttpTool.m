//
//  YTHttpTool.m
//  爱理不离
//
//  Created by Steven on 2016/10/15.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTHttpTool.h"
#import "AFNetworking.h"
#import "UIView+HUD.h"
#import "MBProgressHUD.h"

@implementation YTHttpTool

/**发送get请求*/
+ (void)get:(NSString *)url parameters:(NSDictionary *)parameters withCallBack:(MyCallBack)calllBack{
    //显示状态栏的网络指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //创建请求管理对象
    AFHTTPSessionManager *mgr = [self manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    //设置加载时间
    mgr.requestSerializer.timeoutInterval = 10.0f;
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 加载get请求
    [mgr GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"--------个人信息返回%@",dic);
        
        calllBack(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

/**发送post请求*/
+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters withCallBack:(MyCallBack)calllBack{
    //显示状态栏的网络指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //创建请求管理对象
    AFHTTPSessionManager *mgr = [self manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    //设置加载时间
    mgr.requestSerializer.timeoutInterval = 10.0f;
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    //加载post请求
    [mgr POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        calllBack(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //弹窗提示网络不好
        MBProgressHUD *hub=[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
        hub.mode=MBProgressHUDModeText;
        hub.label.text = @"无网络，请稍后再试";
        //设置弹出时间
        [hub hideAnimated:YES afterDelay:1];
        
    }];
}

//mgr对象创建
+ (AFHTTPSessionManager *)manager {
    static AFHTTPSessionManager *manager = nil;
    if (manager == nil) {
        manager = [AFHTTPSessionManager manager];
    }
    return manager;
}



@end
