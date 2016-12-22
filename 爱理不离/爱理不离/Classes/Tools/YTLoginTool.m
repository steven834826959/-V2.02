//
//  YTLoginTool.m
//  爱理不离
//
//  Created by ios on 16/12/9.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTLoginTool.h"
#import "YTUserModel.h"
#import "MJExtension.h"
@interface YTLoginTool()
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation YTLoginTool
/**
 监测网络状态
 */
+ (void)autoLogin{
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    //开启监听，记得开启，不然不走block
    [mgr startMonitoring];
    //2.监听改变
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown = -1,
         AFNetworkReachabilityStatusNotReachable = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi");
            {
                //登录操作
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                manager.requestSerializer.timeoutInterval = 10.0f;
                [manager POST:@"http://117.78.50.198/user/login" parameters:@{@"mobile":[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"],@"password":[[NSUserDefaults standardUserDefaults] objectForKey:@"userPwd"],@"deviceNum":@"111"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    //网络请求成功
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    if ([[dic objectForKey:@"code"] intValue] == 0) {
                        //登录成功
                        NSLog(@"-----------再次登录成功！！！");
                        [[NSUserDefaults standardUserDefaults] setBool:YES  forKey:@"loginStatus"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
        
                        //发送通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginAgain" object:nil];
                        
                        NSString *jsonStr = dic[@"data"];
                        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                        
                        
                        NSLog(@"---------登录后拿到个人信息 %@",dicData);
                        
                        //字典转模型
                        YTUserModel *userInfo = [YTUserModel mj_objectWithKeyValues:dicData];
                        
                        //将文件写入内存
                        NSString *file = [NSTemporaryDirectory() stringByAppendingPathComponent:@"userInfo.plist"];
                        // 归档
                        [NSKeyedArchiver archiveRootObject: userInfo toFile:file];
            
                    }else {

                        
                    }
                  
                 
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              

                }];
                
            }
                break;
        }
    }];

    
}





@end
