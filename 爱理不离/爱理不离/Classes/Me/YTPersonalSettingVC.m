//
//  YTPersonalSettingVC.m
//  爱理不离
//
//  Created by ios on 16/12/5.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTPersonalSettingVC.h"
#import "ChooseLocationView.h"
#import "CitiesDataTool.h"
#import "HcdDateTimePickerView.h"
#import "YTPickerView.h"
#import "UIBarButtonItem+MJ.h"
#import "YTUserModel.h"
@interface YTPersonalSettingVC ()<UIGestureRecognizerDelegate,UITextFieldDelegate>

@property (nonatomic,strong) ChooseLocationView *chooseLocationView;
@property (nonatomic,strong) UIView  *cover;

@property(nonatomic,strong)HcdDateTimePickerView *dateTimePickerView;
@property(nonatomic,strong)YTPickerView *sexPicker;

@property(nonatomic,strong)NSArray *sexArr;
@property(nonatomic,strong)YTUserModel *userInfo;
@end

@implementation YTPersonalSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    self.view.backgroundColor = YTColor(239, 209, 211);
    self.userInfo = [YTUserModel sharedYTUserModel];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    //右边导航栏按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(updateUserInfo)];
    //左边返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
    
    [self initEditView];
    //地址相关
    [[CitiesDataTool sharedManager] requestGetData];
    [self.view addSubview:self.cover];
    
    //性别相关
    self.sexPicker = [[YTPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, self.view.frame.size.height)];
    self.sexPicker.arrPickerData = self.sexArr;
    [self.sexPicker.pickerView selectRow:0 inComponent:0 animated:YES]; //pickerview默认选中行
    
    __block YTPersonalSettingVC *weakSelf = self;
    [self.view addSubview:self.sexPicker];
    
    self.sexPicker.selectBlock = ^(NSString *str){

        weakSelf.infoTF.text = str;
    };
    
    
  
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.navigationController.viewControllers.count == 1) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //去掉透明后导航栏下边的黑边
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
}




#pragma mark  - custom
- (void)initEditView{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 100)];
    backView.backgroundColor = [UIColor clearColor];
    
    self.infoTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 20,SCREEN_WIDTH - 20 , 40)];
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,8,self.infoTF.frame.size.height)];
    leftView.backgroundColor = [UIColor clearColor];
    
    self.infoTF.leftView = leftView;
    
    self.infoTF.leftViewMode = UITextFieldViewModeAlways;
    self.infoTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    self.infoTF.backgroundColor = [UIColor whiteColor];
    self.infoTF.layer.cornerRadius = 3;
    self.infoTF.layer.masksToBounds =YES;
    self.infoTF.text = self.editStr;
    self.infoTF.delegate = self;
    [backView addSubview:self.infoTF];
    
    UIButton *chooseBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(self.infoTF.frame), SCREEN_WIDTH - 80, 40)];
    [chooseBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [chooseBtn addTarget:self action:@selector(chooseBtnClicked) forControlEvents:UIControlEventTouchUpInside];

    if (self.isChoose) {
        [backView addSubview:chooseBtn];
    }
    [self.view addSubview:backView];

}
//更新新用户信息
- (void)updateUserInfo {
    [self.infoTF resignFirstResponder];
    
    
    //更新信息请求
    NSDictionary *param;
    if ([self.titleStr isEqualToString:@"昵称"]) {
        param = @{@"nickName":self.infoTF.text};
    }else if ([self.titleStr isEqualToString:@"性别"]){
        if ([self.infoTF.text isEqualToString:@"男"]) {
            param = @{@"gender":@(1)};
        }else{
            param = @{@"gender":@(2)};
        }
    }else if ([self.titleStr isEqualToString:@"出生日期"]){
            param = @{@"birthday":self.infoTF.text};
    }else if ([self.titleStr isEqualToString:@"地区"]){
            param = @{@"city":self.infoTF.text};
    }else if ([self.titleStr isEqualToString:@"邮箱"]){
            param = @{@"email":self.infoTF.text};
    }

    
    NSLog(@"----传递参数%@",param);
    
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer.timeoutInterval = 10.0f;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [manger POST:[kDominURL URLStringWithStr:@"/user/user_info.update"] parameters:@{@"object":str} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"-----返回%@",dic);
        if ([[dic objectForKey:@"code"] intValue] == 0) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"更新成功" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([self.titleStr isEqualToString:@"昵称"]) {
                    self.userInfo.nickName = self.infoTF.text;
                }else if ([self.titleStr isEqualToString:@"性别"]){
                    if ([self.infoTF.text isEqualToString:@"男"]) {
                        self.userInfo.gender = 1;
                    }else{
                        self.userInfo.gender = 2;
                    }
                }else if ([self.titleStr isEqualToString:@"出生日期"]){
                    self.userInfo.birthday = [self.infoTF.text changToDateIntervalStr];
                    
                    //创建推送
                    [self creatPushWithDateStr:self.infoTF.text andKey:@"birthday"];
                    
                }else if ([self.titleStr isEqualToString:@"地区"]){
                    self.userInfo.city = self.infoTF.text;
                }else if ([self.titleStr isEqualToString:@"邮箱"]){
                    self.userInfo.email = self.infoTF.text;
                }
                
                //将文件写入内存
                NSString *file = [NSTemporaryDirectory() stringByAppendingPathComponent:@"userInfo.plist"];
                // 归档
                [NSKeyedArchiver archiveRootObject: self.userInfo toFile:file];
                
                //跳转会控制器传值
                [self.delegate valuesBack:self andValues:self.infoTF.text];
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self presentViewController:[AlertTool alertWithTitle:@"提示" Message:@"网络故障,请重新提交" actionTitle:@"好" andStyle:1] animated:YES completion:nil];
    }];
    
}

- (void)leftButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)chooseBtnClicked{
    
     __block YTPersonalSettingVC *weakSelf = self;
    if ([self.titleStr isEqualToString:@"地区"]) {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.view.transform =CGAffineTransformMakeScale(0.95, 0.95);
        }];
        self.cover.hidden = !self.cover.hidden;
        self.chooseLocationView.hidden = self.cover.hidden;
        
    }else if ([self.titleStr isEqualToString:@"出生日期"]){
        self.dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000]];
        [self.dateTimePickerView setMinYear:1900];
        [self.dateTimePickerView setMaxYear:2058];
        self.dateTimePickerView.clickedOkBtn = ^(NSString * datetimeStr){
            NSLog(@"%@", datetimeStr);
            weakSelf.infoTF.text = datetimeStr;
        };
        if (self.dateTimePickerView) {
            [self.view addSubview:self.dateTimePickerView];
            [self.dateTimePickerView showHcdDateTimePicker];
        }
        
    }else if([self.titleStr isEqualToString:@"性别"]){
        
        [self.sexPicker popPickerView];
    
    }

}

#pragma mark  - lazy
- (void)tapCover:(UITapGestureRecognizer *)tap{
    
    if (_chooseLocationView.chooseFinish) {
        _chooseLocationView.chooseFinish();
    }
}


#pragma mark  - delegateMethod
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(_chooseLocationView.frame, point)){
        return NO;
    }
    return YES;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.isChoose) {
        return NO;
        
    }else{
        return YES;
    }
    
}


#pragma mark - push
- (void)creatPushWithDateStr:(NSString *)dateStr andKey:(NSString *)key{
    NSDictionary *info = [NSDictionary dictionaryWithObject:key forKey:@"key"];
    //建立本地推送
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //判断程序是否在后台运行
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        
        // 获得 UIApplication
        
        UIApplication *app = [UIApplication sharedApplication];
        
        //获取本地推送数组
        
        NSArray *localArray = [app scheduledLocalNotifications];
        
        //声明本地通知对象
        
        UILocalNotification *localNotification;
        for (UILocalNotification *noti in localArray) {
            NSDictionary *dict = noti.userInfo;
            if (dict) {
                NSString *inKey = [dict objectForKey:@"key"];
                if ([inKey isEqualToString:key]) {
                        
                    localNotification.fireDate = [dateFormatter dateFromString:dateStr];
                    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

                }else{
                    //添加本地通知
                    localNotification = [UILocalNotification new];
                    localNotification.userInfo = info;
                    //显示时间
                    localNotification.fireDate = [dateFormatter dateFromString:dateStr];
                    localNotification.applicationIconBadgeNumber = 1;
                    localNotification.repeatInterval = kCFCalendarUnitYear;//每年都推送
                    localNotification.alertBody = [NSString stringWithFormat:@"您收到一条推送信息"];
                    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                }
            }
        }
    }
}


#pragma mark  - lazy
- (ChooseLocationView *)chooseLocationView{
    if (!_chooseLocationView) {
        _chooseLocationView = [[ChooseLocationView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 350, [UIScreen mainScreen].bounds.size.width, 350)];
        
    }
    return _chooseLocationView;
}

- (UIView *)cover{
    
    if (!_cover) {
        _cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_cover addSubview:self.chooseLocationView];
        __weak typeof (self) weakSelf = self;
        _chooseLocationView.chooseFinish = ^{
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.infoTF.text = weakSelf.chooseLocationView.address;
                weakSelf.view.transform = CGAffineTransformIdentity;
                weakSelf.cover.hidden = YES;
            }];
        };
        UITapGestureRecognizer *tapCover = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCover:)];
        [_cover addGestureRecognizer:tapCover];
        tapCover.delegate = self;
        _cover.hidden = YES;
    }
    return _cover;
}

- (NSArray *)sexArr{
    if (_sexArr == nil) {
        _sexArr = @[@"男",@"女"];
    }
    return _sexArr;
}


@end
