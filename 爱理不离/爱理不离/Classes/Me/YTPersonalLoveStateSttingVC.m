//
//  YTPersonalLoveStateSttingVC.m
//  爱理不离
//
//  Created by ios on 16/12/6.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTPersonalLoveStateSttingVC.h"
#import "HcdDateTimePickerView.h"
#import "UIBarButtonItem+MJ.h"
#import "YTPickerView.h"
#import "YTPickerView.h"
#import "YTUserModel.h"

typedef enum{
    LoveStateSingle = 1,
    LoveStateLove, 
    LoveStateMarried
}LoveState;



@interface YTPersonalLoveStateSttingVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *secretArr;
@property(nonatomic,strong)UILabel *topLabel;
@property(nonatomic,strong)UILabel *bottomLabel;

@property(nonatomic,strong)UITextField *topTF;
@property(nonatomic,strong)UITextField *bottomTF;


@property(nonatomic,strong)UILabel *topTFLabel;
@property(nonatomic,strong)UILabel *downTFLabel;

@property(nonatomic,strong)UIButton *loveStateBtn;

@property(nonatomic,strong)UIView *baseView;

//选择器相关
@property(nonatomic,strong)HcdDateTimePickerView *dateTimePickerView;
@property(nonatomic,strong)YTPickerView *pickerViewIsLove;
@property(nonatomic,strong)YTPickerView *pickerViewLoveStatus;
@property(nonatomic,strong)NSArray *isLoveArr;
@property(nonatomic,strong)NSArray *loveStatesArr;
@property(nonatomic,strong)YTUserModel *userInfo;

@end

@implementation YTPersonalLoveStateSttingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"感情状态";
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    
    
    NSString *file = [NSTemporaryDirectory() stringByAppendingPathComponent:@"userInfo.plist"];
    //读档
    self.userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, self.view.frame.size.height - 10) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [_tableView  setSeparatorColor:YTColor(237, 205, 206)];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    //创建头部视图
    [self createHeaderView];
    //配置页面信息
    [self configView];
    
}

#pragma mark  - custom
- (void)createHeaderView{
    self.baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
    self.baseView.backgroundColor = [UIColor clearColor];
    //中间情感状态的button
    self.loveStateBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH - 200, 35)];
    [_loveStateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.loveStateBtn addTarget:self action:@selector(loveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:self.loveStateBtn];
    [self initTopTF];
    [self initBottomTF];
    [self initToplabel];
    [self initBottomLabel];
    self.tableView.tableHeaderView = _baseView;
}


- (void)configView{
    //获取当前时间
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];

    if (self.userInfo.loveStatus) {
        switch (self.userInfo.loveStatus) {
            case LoveStateSingle:
                //设置文字
                [self.loveStateBtn setTitle:@"情感状态-单身" forState:UIControlStateNormal];
                self.topTFLabel.text = @"是否恋爱过";
                self.downTFLabel.text = @"分手日期";
                self.topLabel.text = @"爱你妹帮你搞定两性健康关系";
                self.bottomLabel.text = @"T I P S 脱单大法";
                 //设置日期
                if (self.userInfo.isLoved) {
                    self.topTF.text = @"是";
                    self.bottomTF.text = [self.userInfo.breakDate changeToDateStr] ? [self.userInfo.breakDate changeToDateStr] : dateStr;
                    self.bottomTF.hidden = NO;
                }else{
                    self.topTF.text = @"否";
                    self.bottomTF.hidden = YES;
                }
                break;
            case LoveStateLove:
                //设置文字
                [self.loveStateBtn setTitle:@"情感状态-恋爱" forState:UIControlStateNormal];
                self.topTFLabel.text = @"恋爱日期";
                self.downTFLabel.text = @"对象生日";
                self.topLabel.text = @"守爱侠助您维系恋爱关系";
                self.bottomLabel.text = @"T I P S 表白秘诀";
                 //设置日期
                self.topTF.text = [self.userInfo.marriedDate changeToDateStr] ? [self.userInfo.marriedDate changeToDateStr] : dateStr;
                self.topTF.text = [self.userInfo.loverBirthday changeToDateStr] ? [self.userInfo.loverBirthday changeToDateStr] : dateStr;
                break;
            case LoveStateMarried:
                //设置文字
                [self.loveStateBtn setTitle:@"情感状态-已婚" forState:UIControlStateNormal];
                self.topTFLabel.text = @"结婚日期";
                self.downTFLabel.text = @"配偶生日";
                self.topLabel.text = @"潘多拉守护关系";
                self.bottomLabel.text = @"T I P S 婚姻保鲜";
                
                //设置日期
                self.topTF.text = [self.userInfo.marriedDate changeToDateStr] ? [self.userInfo.marriedDate changeToDateStr] : dateStr;
                self.bottomTF.text = [self.userInfo.birthday changeToDateStr] ? [self.userInfo.birthday changeToDateStr] : dateStr;
                break;
            default:
                break;
        }

    }
    //获取爱情秘籍
    [self getSecret:self.userInfo.loveStatus];
    
}
//时间戳的转换
- (NSString *)dateStrWith:(NSString *)dateStamp{
    
    
    NSDate *stampDate = [NSDate dateWithTimeIntervalSince1970:[dateStamp longLongValue] / 1000.0f];
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //用[NSDate date]可以获取系统当前时间
    
    NSString *dateStr = [dateFormatter stringFromDate:stampDate];
    return dateStr;
    
}


- (void)getSecret:(int)loveStates{
    
    [YTHttpTool get:[kDominURL URLStringWithStr:@"/secret/list.get"] parameters:@{@"loveStatus":@(loveStates)} withCallBack:^(id obj) {
        NSString *dataStr = obj[@"data"];
        
        NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        self.secretArr = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        NSLog(@"------秘籍返回%@",self.secretArr);
        
        
        [self.tableView reloadData];
        
    }];

}


- (void)leftButtonTapped{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)saveAction{
    //更新个人信息到网络上
    NSDictionary *param;
    if ([self.loveStateBtn.currentTitle isEqualToString:@"情感状态-单身"]){
        if ([self.topTF.text isEqualToString:@"是"]) {;
            param = @{@"loveStatus":@(1),@"isLove":@(1),@"breakDate":self.bottomTF.text};
        }else{
            param = @{@"loveStatus":@(1),@"isLove":@(0)};
        }
    }else if([self.loveStateBtn.currentTitle isEqualToString:@"情感状态-恋爱"]){
        param = @{@"loveStatus":@(2),@"loverBirthday":self.topTF.text,@"birthday":self.bottomTF.text};
    }else if ([self.loveStateBtn.currentTitle isEqualToString:@"情感状态-已婚"]){
        param =@{@"loveStatus":@(3),@"marriedDate":self.topTF.text,@"loverBirthday":self.bottomTF.text};
    }

    
    NSLog(@"-----参数%@",param);
    
    
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
                //更新成功,文件归档
                if ([self.loveStateBtn.currentTitle isEqualToString:@"情感状态-单身"]){
                    self.userInfo.loveStatus = 1;
                    if ([self.topTF.text isEqualToString:@"是"]) {
                        self.userInfo.isLoved = 1;
                        self.userInfo.breakDate = [self.bottomTF.text changToDateIntervalStr];
                        //创建推送
                        [self creatPushWithDateStr:self.bottomTF.text andKey:@"breakDate"];
                        
                        
                    }else{
                        self.userInfo.isLoved = 0;
                    }
                }else if([self.loveStateBtn.currentTitle isEqualToString:@"情感状态-恋爱"]){
                    self.userInfo.loveStatus = 2;
                    self.userInfo.marriedDate = [self.topTF.text changToDateIntervalStr];
                    //创建推送
                    [self creatPushWithDateStr:self.topTF.text andKey:@"marriedDate"];
                    self.userInfo.loverBirthday = [self.bottomTF.text changToDateIntervalStr];
                    //创建推送
                    [self creatPushWithDateStr:self.bottomTF.text andKey:@"loverBirthday"];
                }else if ([self.loveStateBtn.currentTitle isEqualToString:@"情感状态-已婚"]){
                    self.userInfo.loveStatus = 3;
                    self.userInfo.marriedDate = [self.topTF.text changToDateIntervalStr];
                    //创建推送
                    [self creatPushWithDateStr:self.topTF.text andKey:@"marriedDate"];
                    self.userInfo.loverBirthday = [self.bottomTF.text changToDateIntervalStr];
                    //创建推送
                    [self creatPushWithDateStr:self.bottomTF.text andKey:@"loverBirthday"];
                }
                //将文件写入内存
                NSString *file = [NSTemporaryDirectory() stringByAppendingPathComponent:@"userInfo.plist"];
                // 归档
                [NSKeyedArchiver archiveRootObject: self.userInfo toFile:file];
                
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
- (void)initBottomLabel{
    //底部lable
    self.bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _baseView.frame.size.height - 20, SCREEN_WIDTH, 20)];
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomLabel.textColor = YTColor(230, 195, 191);
    self.bottomLabel.backgroundColor = YTColor(255, 250, 236);
    self.bottomLabel.font = [UIFont systemFontOfSize:14];
    //设置文字
    self.bottomLabel.text = @"";
    [_baseView addSubview:self.bottomLabel];

}

- (void)initToplabel{
    //底部上label
    self.topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _baseView.frame.size.height - 52, SCREEN_WIDTH, 32)];
    self.topLabel.backgroundColor = YTColor(185, 152, 199);
    self.topLabel.textColor = [UIColor whiteColor];
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    //设置文字
    self.topLabel.text = @"";
    [_baseView addSubview:self.topLabel];
}

- (void)initTopTF{

    //上部TF
    self.topTF = [[UITextField alloc]initWithFrame:CGRectMake(16, 55, SCREEN_WIDTH - 32, 35)];
    self.topTF.delegate = self;
    self.topTF.backgroundColor = [UIColor whiteColor];
    self.topTFLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 35)];
    self.topTFLabel.backgroundColor = YTColor(223, 170, 212);
    UIImageView *rightViewTop = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    rightViewTop.contentMode = UIViewContentModeCenter;
    rightViewTop.image = [UIImage imageNamed:@"感情1"];
    
    //设置文字
    self.topTFLabel.text = @"恋爱日期";
    self.topTFLabel.textColor = [UIColor whiteColor];
    self.topTFLabel.textAlignment = NSTextAlignmentCenter;
    self.topTF.leftViewMode = UITextFieldViewModeAlways;
    self.topTF.leftView = self.topTFLabel;
    self.topTF.textAlignment = NSTextAlignmentCenter;
    self.topTF.rightViewMode = UITextFieldViewModeAlways;
    self.topTF.rightView = rightViewTop;
    [_baseView addSubview:self.topTF];

}

- (void)initBottomTF{
    //下部TF
    UIImageView *rightViewDown = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    rightViewDown.contentMode = UIViewContentModeCenter;
    rightViewDown.image = [UIImage imageNamed:@"感情1"];
    self.bottomTF = [[UITextField alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(self.topTF.frame) + 15, SCREEN_WIDTH - 32, 35)];
    self.bottomTF.delegate = self;
    self.bottomTF.backgroundColor = [UIColor whiteColor];
    self.downTFLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 35)];
    self.downTFLabel.backgroundColor = YTColor(223, 170, 212);
    
    //设置文字
    self.downTFLabel.text = @"结婚日期";
    self.downTFLabel.textColor = [UIColor whiteColor];
    self.downTFLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomTF.leftViewMode = UITextFieldViewModeAlways;
    self.bottomTF.leftView = self.downTFLabel;
    self.bottomTF.textAlignment = NSTextAlignmentCenter;
    self.bottomTF.rightViewMode = UITextFieldViewModeAlways;
    self.bottomTF.rightView = rightViewDown;
    [_baseView addSubview:self.bottomTF];
}

- (void)loveBtnClicked{
    //底部弹出选择框
    self.pickerViewLoveStatus = [[YTPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    self.pickerViewLoveStatus.arrPickerData = self.loveStatesArr;
    [self.pickerViewLoveStatus.pickerView selectRow:0 inComponent:0 animated:YES]; //pickerview默认选中行
    
    __block YTPersonalLoveStateSttingVC *weakSelf = self;
    [self.view addSubview:self.pickerViewLoveStatus];
    [self.pickerViewLoveStatus popPickerView];
    self.pickerViewLoveStatus.selectBlock = ^(NSString *str){
        [weakSelf.loveStateBtn setTitle:str forState:UIControlStateNormal];
        
        if ([str isEqualToString:@"情感状态-单身"]) {
            //获取爱情秘籍
            [weakSelf getSecret:1];
            
            weakSelf.topTFLabel.text = @"是否恋爱";
            if (weakSelf.userInfo.isLoved) {
                weakSelf.topTF.text = @"是";
                weakSelf.bottomTF.hidden = NO;
                weakSelf.downTFLabel.text  =@"分手日期";
            }else{
                weakSelf.topTF.text = @"否";
                weakSelf.bottomTF.hidden = YES;
            }
        }else if ([str isEqualToString:@"情感状态-恋爱"]){
            //获取爱情秘籍
            [weakSelf getSecret:2];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *topStr = [formatter stringFromDate:[NSDate date]];
            
            NSString *bottomStr = [formatter stringFromDate:[NSDate date]];
            
            weakSelf.topTF.text = [weakSelf dateStrWith:weakSelf.userInfo.marriedDate] ? [weakSelf dateStrWith:weakSelf.userInfo.marriedDate] :topStr;
            weakSelf.bottomTF.text =[weakSelf dateStrWith:weakSelf.userInfo.loverBirthday]  ? [weakSelf dateStrWith:weakSelf.userInfo.loverBirthday] : bottomStr;

            weakSelf.bottomTF.hidden = NO;
            weakSelf.topTFLabel.text = @"恋爱日期";
            weakSelf.downTFLabel.text = @"对象生日";
            
        }else if ([str isEqualToString:@"情感状态-已婚"]){
            //获取爱情秘籍
            [weakSelf getSecret:3];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *topStr = [formatter stringFromDate:[NSDate date]];
            
            NSString *bottomStr = [formatter stringFromDate:[NSDate date]];
            
            weakSelf.topTF.text = [weakSelf dateStrWith:weakSelf.userInfo.marriedDate] ? [weakSelf dateStrWith:weakSelf.userInfo.marriedDate] :topStr;
            weakSelf.bottomTF.text = [weakSelf dateStrWith:weakSelf.userInfo.loverBirthday] ? [weakSelf dateStrWith:weakSelf.userInfo.loverBirthday] : bottomStr;
            weakSelf.bottomTF.hidden = NO;
            weakSelf.topTFLabel.text = @"结婚日期";
            weakSelf.downTFLabel.text = @"配偶生日";
        }
        [weakSelf.pickerViewLoveStatus removeFromSuperview];
        
    };
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

//下面为了防止UItextfield弹出键盘

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    __block YTPersonalLoveStateSttingVC *weakSelf = self;
    textField.inputView = nil;
    if ([self.loveStateBtn.currentTitle isEqualToString:@"情感状态-单身"]) {
        if (textField == self.topTF) {
            
            self.pickerViewIsLove = [[YTPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
            
            self.pickerViewIsLove.arrPickerData = self.isLoveArr;
            [self.pickerViewIsLove.pickerView selectRow:0 inComponent:0 animated:YES]; //pickerview默认选中行
            __block YTPersonalLoveStateSttingVC *weakSelf = self;
            [self.view addSubview:self.pickerViewIsLove];
            [self.pickerViewIsLove popPickerView];
            self.pickerViewIsLove.selectBlock = ^(NSString *str){
                if ([str isEqualToString:@"是"]) {
                        weakSelf.topTF.text = @"是";
                        weakSelf.bottomTF.hidden = NO;
                        weakSelf.downTFLabel.text  =@"分手日期";
                    }else{
                        weakSelf.topTF.text = @"否";
                        weakSelf.bottomTF.hidden = YES;
                    }
                
                [weakSelf.topTF resignFirstResponder];
                [weakSelf.pickerViewIsLove removeFromSuperview];

            };

        }else{
            self.bottomTF.hidden = NO;
            [self setupDatePickerWihtTextField:textField];
        }
    }else{
        self.bottomTF.hidden = NO;
        [self setupDatePickerWihtTextField:textField];
    
    }
    

    return NO;
}


- (void)setupDatePickerWihtTextField:(UITextField *)textField{
    self.dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000]];
    [self.dateTimePickerView setMinYear:1900];
    [self.dateTimePickerView setMaxYear:2058];
    self.dateTimePickerView.clickedOkBtn = ^(NSString * datetimeStr){
        NSLog(@"%@", datetimeStr);
        textField.text = datetimeStr;
        [textField resignFirstResponder];
    };
    if (self.dateTimePickerView) {
        [self.view addSubview:self.dateTimePickerView];
        [self.dateTimePickerView showHcdDateTimePicker];
    }

}





#pragma mark  - delegate;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.secretArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = YTColor(241, 218, 218);
    cell.textLabel.text = [self.secretArr[indexPath.row] objectForKey:@"title"];
    return cell;

}
//设置分割线长度
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}




#pragma mark  - lazy
- (NSMutableArray *)secretArr{
    if (_secretArr == nil) {
        _secretArr = [NSMutableArray array];
    }
    return _secretArr;
}

- (NSArray *)loveStatesArr{
    if (_loveStatesArr == nil) {
        _loveStatesArr = @[@"情感状态-单身",@"情感状态-恋爱",@"情感状态-已婚"];
    }
    return _loveStatesArr;
}

- (NSArray *)isLoveArr{
    if (_isLoveArr == nil) {
        _isLoveArr = @[@"是",@"否"];
    }
    return _isLoveArr;
}
@end
