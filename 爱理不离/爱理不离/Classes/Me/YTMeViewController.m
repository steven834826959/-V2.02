//
//  YTMeViewController.m
//  爱理不离
//
//  Created by Steven on 2016/10/15.
//  Copyright © 2016年 cn.stevenyongtong All rights reserved.
//

#import "YTMeViewController.h"
#import "YTPersonalHeaderView.h"
#import "UIBarButtonItem+MJ.h"
#import "ContextMenuCell.h"
#import "YALContextMenuTableView.h"
#import "YALNavigationBar.h"
#import "YTPersonalSettingVC.h"
#import "YTPersonalLoveStateSttingVC.h"
#import "YTHeaderImageSettingVC.h"
#import "YTMyBankCardVC.h"
#import "YTMyAddressVC.h"
#import "YTSettingViewController.h"
#import "YTMyBalanceVC.h"
#import "LoginViewController.h"
#import "YTUserModel.h"
#import "MJExtension.h"
#import "YTMyProductVC.h"
#import "YTAboutVC.h"
#import "UIImage+MultiFormat.h"
#import "YTSocreChangeVC.h"
#import "YTMyListVC.h"


static NSString *const menuCellIdentifier = @"rotationCell";

@interface YTMeViewController ()<UITableViewDelegate,UITableViewDataSource,YALContextMenuTableViewDelegate,YTPersonalSettingVCDelegate,YTHeaderImageSettingVCDelegate>
@property (strong, nonatomic)UITableView *tableView;
@property(nonatomic,strong)NSArray *sectionOneArr;
@property(nonatomic,strong)NSArray *sectionTwoArr;
@property(nonatomic,assign)BOOL isHide;
@property(nonatomic,strong)UIImageView *cornerBgImg;
@property(nonatomic,strong)UIImage *roundImage;

@property(nonatomic,assign)NSNumber *tag;

@property (nonatomic, strong) YALContextMenuTableView* contextMenuTableView;

@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuIcons;
/*status*/
@property (nonatomic) BOOL dropStatus;
@property (nonatomic) NSInteger section1;
@property (nonatomic) NSInteger *row1;

//传值使用
@property(nonatomic,strong)UILabel *nickName;
@property(nonatomic,strong)UILabel *address;
@property(nonatomic,strong)UILabel *birthday;
@property(nonatomic,strong)UILabel *mail;
@property(nonatomic,strong)UILabel *gender;



@property(nonatomic,strong)YTUserModel *userInfo;

@property(nonatomic,assign)float balance;
@property(nonatomic,assign)int score;


@end
@implementation YTMeViewController
static NSString *const personCellIdentify = @"personalCell";
static NSString *const reusableIdentify = @"reusable";

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    //获取账户余额
    [self getMyBalance];

    //设置导航栏
    [self initNavTitle];
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    
    NSString *file = [NSTemporaryDirectory() stringByAppendingPathComponent:@"userInfo.plist"];
    //读档
    self.userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    
    
    NSLog(@"-----是否认证%d",self.userInfo.isCertification);
    NSLog(@"-----是否认证%@",self.userInfo.payAccount);
    
    [self initiateMenuOptions];
    //右边导航栏按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"三条" highIcon:@"叉" target:self action:@selector(presentMenuButtonTapped:)];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [_tableView  setSeparatorColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.tableView];
    
    //创建头部视图
    [self createHeaderView];
    [self creatInfoView];
    //配置信息
    [self configInfomation];
    
    [self setupCornerBgImg];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(roundImagetap) name:@"roundImageTaped" object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loginStatus"]) {
        NSString *file = [NSTemporaryDirectory() stringByAppendingPathComponent:@"userInfo.plist"];
        //读档
        self.userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
        
        [self configInfomation];
        
        [self createHeaderView];
        [self.tableView reloadData];
        
    }
    [self initNavTitle];
    [HiddenAndShowTool show];
}

- (void)viewDidLayoutSubviews{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}



#pragma mark - custom
- (void)initNavTitle{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"透明"] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)creatInfoView{
    self.nickName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    self.nickName.textAlignment = NSTextAlignmentRight;
    self.nickName.textColor = [UIColor lightGrayColor];
    
    self.gender = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    self.gender.textAlignment = NSTextAlignmentRight;
    self.gender.textColor = [UIColor lightGrayColor];
    
    self.address = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    self.address.textAlignment = NSTextAlignmentRight;
    self.address.textColor = [UIColor lightGrayColor];
    self.address.font = [UIFont systemFontOfSize:14];
    
    
    self.birthday = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    self.birthday.textAlignment = NSTextAlignmentRight;
    self.birthday.textColor = [UIColor lightGrayColor];
    
    self.mail = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    self.mail.textAlignment = NSTextAlignmentRight;
    self.mail.textColor = [UIColor lightGrayColor];
    self.mail.font = [UIFont systemFontOfSize:15];
}



- (void)configInfomation{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loginStatus"]) {
        NSString *file = [NSTemporaryDirectory() stringByAppendingPathComponent:@"userInfo.plist"];
        //读档
        self.userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
        
        self.nickName.text = self.userInfo.nickName;
        
        if (self.userInfo.gender == 1) {
            self.gender.text = @"男";
        }else if(self.userInfo.gender == 2){
            self.gender.text = @"女";
        }else{
            self.gender.text = @"未知";
        }
        self.address.text = self.userInfo.city ? self.userInfo.city : @"未设置";
        self.birthday.text = [self.userInfo.birthday changeToDateStr] ? [self.userInfo.birthday changeToDateStr] : @"未设置";
        self.mail.text = self.userInfo.email ? self.userInfo.email : @"未设置";
    }else{
        //未登录状态
        self.nickName.text = @"未设置";
        self.address.text = @"未设置";
        self.gender.text = @"未设置";
        self.mail.text = @"未设置";
        self.birthday.text = @"未设置";
        
    }
}

//时间戳的转换
- (NSString *)dateStrWith:(NSString *)dateStamp{
    
    
    NSDate *stampDate = [NSDate dateWithTimeIntervalSince1970:[dateStamp longLongValue] / 1000];
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateStr = [dateFormatter stringFromDate:stampDate];
    return dateStr;
    
}




- (void)getMyBalance{

    if (self.userInfo.isCertification) {
        [YTHttpTool get:[kDominURL URLStringWithStr:@"/user/query_balance_bg"] parameters:nil withCallBack:^(id obj) {
            NSString *dataStr = obj[@"data"];
            NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *balance = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            if ([[obj objectForKey:@"code"] intValue] == 0) {
                self.balance = [[balance[0] objectForKey:@"AvlBal"] floatValue];
            }
            NSLog(@"------获取余额返回%@",balance);
            
        }];
    }
}

- (void)setupCornerBgImg{
    self.cornerBgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
    self.cornerBgImg.contentMode = UIViewContentModeScaleAspectFill;
    //左上角按钮的背景图片
    self.cornerBgImg.image = [UIImage imageNamed:@"扇形角@2x-1"];
    [self.view addSubview:self.cornerBgImg];
    
}

- (void)createHeaderView{
    YTPersonalHeaderView *headerView = [[YTPersonalHeaderView alloc]init];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loginStatus"]) {
        [headerView setupWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) headerImage:[kDominURL URLStringWithStr:self.userInfo.avatar] myScore:self.score balanceMoney:self.balance];
    }else{
        [headerView setupWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) headerImage:nil myScore:self.score balanceMoney:self.balance];
    }
    
    self.tableView.tableHeaderView = headerView;
    
    //单击空白部分，收起键盘
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideLeftMenu)];
    singleTap.cancelsTouchesInView = YES;
    [headerView addGestureRecognizer:singleTap];
    
}

- (void)hideLeftMenu {
    self.dropStatus = 0;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.contextMenuTableView dismisWithIndexPath:indexPath];
}
- (void)roundImagetap{
    //隐藏侧边栏
    [self hideLeftMenu];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loginStatus"]) {
        //跳转控制器
        YTHeaderImageSettingVC *imageSetting = [[YTHeaderImageSettingVC alloc]init];
        imageSetting.delegate = self;
        imageSetting.headImg = self.roundImage;
        [self.navigationController pushViewController:imageSetting animated:YES];
    }else{
        //弹出登录控制器
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
        [self presentViewController:nav animated:YES completion:nil];
    }
  
}
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([tableView isKindOfClass:[YALContextMenuTableView class]]) {
        return 1;
    }else {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([tableView isKindOfClass:[YALContextMenuTableView class]]) {
        
        return self.menuIcons.count;
    }else {
        if (section == 0) {
            return 5;
        }else if (section == 1){
            return 2;
        }else{
            return 1;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isKindOfClass:[YALContextMenuTableView class]]) {
        ContextMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier forIndexPath:indexPath];
        
        if (cell) {
            cell.menuImageView.image = [self.menuIcons objectAtIndex:indexPath.row];
            cell.backgroundColor = [UIColor clearColor];
        }
        
        return cell;
        
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PerCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PerCell"];

            if (indexPath.section == 0) {
                cell.textLabel.text = self.sectionOneArr[indexPath.row];
                switch (indexPath.row) {
                    case 0:
                        cell.accessoryView = self.nickName;
                        break;
                    case 1:
                        cell.accessoryView = self.gender;
                        break;
                    case 2:
                        cell.accessoryView = self.birthday;
                        break;
                    case 3:
                        cell.accessoryView = self.address;
                        break;
                    case 4:
                        cell.accessoryView = self.mail;
                        break;
                    default:
                        break;
                }
                
            }else if (indexPath.section == 1){
                cell.textLabel.text = self.sectionTwoArr[indexPath.row];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.accessoryView.backgroundColor = [UIColor whiteColor];
            }else{
                cell.textLabel.text = @"收货地址";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        return cell;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([tableView isKindOfClass:[YALContextMenuTableView class]]) {
        return 0;
    }else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([tableView isKindOfClass:[YALContextMenuTableView class]]) {
        return 0;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(YALContextMenuTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isKindOfClass:[YALContextMenuTableView class]]) {
        return 70;
    }else {
        return 44;
    }
    
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


- (void)tableView:(YALContextMenuTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断是否登录
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    if ([tableView isKindOfClass:[YALContextMenuTableView class]]){
        switch (indexPath.row) {
            case 0:
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loginStatus"]) {
                    YTMyBalanceVC *balance = [[YTMyBalanceVC alloc]init];
                    [self.navigationController pushViewController:balance animated:YES];
                }else{
                    //弹出登录控制器
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
                    [self presentViewController:nav animated:YES completion:nil];
                }
                break;
            case 1:
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loginStatus"]) {
                    YTSocreChangeVC *change = [[YTSocreChangeVC alloc]init];
                    [self.navigationController pushViewController:change animated:YES];
                }else{
                    //弹出登录控制器
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
                    [self presentViewController:nav animated:YES completion:nil];
                }
                
                break;
            case 2:
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loginStatus"]) {
                    YTMyProductVC *product = [[YTMyProductVC alloc]init];
                    [self.navigationController pushViewController:product animated:YES];
                }else{
                    //弹出登录控制器
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
                    [self presentViewController:nav animated:YES completion:nil];
                }
                break;
            case 3:
            {
                //弹窗敬请期待
                [self.navigationController pushViewController:[YTMyListVC new] animated:YES];
                
            }
                break;
            case 4:
                   [self.navigationController pushViewController:[YTAboutVC new] animated:YES];
                break;
            case 5:
            {
                YTSettingViewController *setting = [[YTSettingViewController alloc]init];
                [self.navigationController pushViewController:setting animated:YES];
            }
                
                break;
            default:
                break;
        }
        [tableView dismisWithIndexPath:indexPath];
    }else{
        //隐藏侧边栏
        [self hideLeftMenu];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        YTPersonalSettingVC *setting = [[YTPersonalSettingVC alloc]init];

        
        if ([defaluts boolForKey:@"loginStatus"]) {
            
            if (indexPath.section == 0) {
                
                switch (indexPath.row) {
                    case 0:
                    case 4:
                        setting.titleStr = cell.textLabel.text;
                        setting.delegate = self;
                        setting.isChoose = NO;
                        setting.infoTF.enabled = YES;
                        setting.editStr = cell.detailTextLabel.text;
                        [self.navigationController pushViewController:setting animated:YES];
                        break;
                    case 1:
                    case 2:
                    case 3:
                        setting.titleStr = cell.textLabel.text;
                        setting.isChoose = YES;
                        setting.infoTF.enabled = NO;
                        setting.delegate = self;
                        setting.editStr = cell.detailTextLabel.text;
                        [self.navigationController pushViewController:setting animated:YES];
                    default:
                        break;
                }
                
            }else if (indexPath.section == 1){
                if (indexPath.row == 0) {
                    YTPersonalLoveStateSttingVC *loveState = [[YTPersonalLoveStateSttingVC alloc]init];
                    [self.navigationController pushViewController:loveState animated:YES];
                }else{
                    //跳转到银行卡管理页面
                    YTMyBankCardVC *bankCard = [[YTMyBankCardVC alloc]init];
                    [self.navigationController pushViewController:bankCard animated:YES];
                }
            }else{
                //跳转到地址页面
                YTMyAddressVC *address = [[YTMyAddressVC alloc]init];
                [self.navigationController pushViewController:address animated:YES];
            }
        }else{
            //弹出登录控制器
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
            [self presentViewController:nav animated:YES completion:nil];
        }
  
    }
}

#pragma mark  - YTPersonalDelegate
- (void)valuesBack:(YTPersonalSettingVC *)sender andValues:(NSString *)values{

    NSLog(@"传值成功——-----%@",values);
    if ([sender.titleStr isEqualToString:@"昵称"]) {
        self.nickName.text = values ;
    }else if ([sender.titleStr isEqualToString:@"性别"]){
       self.gender.text = values;
    }else if ([sender.titleStr isEqualToString:@"出生日期"]){
        self.birthday.text = values;
    }else if ([sender.titleStr isEqualToString:@"地区"]){
        self.address.text = values;
    }else if ([sender.titleStr isEqualToString:@"邮箱"]){
        self.mail.text = values;
    }
    
//    [self.tableView reloadData];

}
#pragma mark  - YTHeaderImageVCDelegate
- (void)imageBackToMeVC:(YTHeaderImageSettingVC *)sender image:(UIImage *)headImage{
    NSLog(@"-------头像传值");
    self.roundImage = headImage;
    [self createHeaderView];
}
#pragma mark 左侧栏
- (void)presentMenuButtonTapped:(UIBarButtonItem *)sender {

    
    if (!self.contextMenuTableView) {
        self.contextMenuTableView = [[YALContextMenuTableView alloc]initWithTableViewDelegateDataSource:self];
        self.contextMenuTableView.animationDuration = 0.0f;
        //optional - implement custom YALContextMenuTableView custom protocol
        self.contextMenuTableView.yalDelegate = self;
        //optional - implement menu items layout
        self.contextMenuTableView.menuItemsSide = Right;
        self.contextMenuTableView.menuItemsAppearanceDirection = FromTopToBottom;
        
        //register nib
        UINib *cellNib = [UINib nibWithNibName:@"ContextMenuCell" bundle:nil];
        [self.contextMenuTableView registerNib:cellNib forCellReuseIdentifier:menuCellIdentifier];
    }
    //如果是未展开状态，那么点击按钮即可展开
    if (!self.dropStatus) {
        // it is better to use this method only for proper animation
        [self.contextMenuTableView showInView:self.navigationController.view withEdgeInsets:UIEdgeInsetsZero animated:YES];
        self.dropStatus = 1;
    }else {
        //如果是展开状态，点击按钮即可收起
        self.dropStatus = 0;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.contextMenuTableView dismisWithIndexPath:indexPath];
    }
    
    
    
}

//Local methods

- (void)initiateMenuOptions {
    self.menuIcons = @[[UIImage imageNamed:@"yue@2x-1"],
                       [UIImage imageNamed:@"duihuan@2x-1"],
                       [UIImage imageNamed:@"chanpin@2x-1"],
                       [UIImage imageNamed:@"yuanwangqindan@2x-1"],
                       [UIImage imageNamed:@"guanyuwomen@2x-1"],
                       [UIImage imageNamed:@"shezi@2x-1"]];
}

//YALContextMenuTableViewDelegate
- (void)contextMenuTableView:(YALContextMenuTableView *)contextMenuTableView didDismissWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Menu dismissed with indexpath = %@", indexPath);
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    //should be called after rotation animation completed
    [self.contextMenuTableView reloadData];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.contextMenuTableView updateAlongsideRotation];
}

//lazy
- (BOOL)dropStatus {
    if (!_dropStatus) {
        _dropStatus = 0;
    }
    return _dropStatus;
}
- (NSInteger)section1 {
    if (_section1) {
        _section1 = 0;
    }
    return _section1;
}
- (NSInteger *)row1 {
    if (!_row1) {
        _row1 = 0;
    }
    return _row1;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.dropStatus = 0;
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //should be called after rotation animation completed
        [self.contextMenuTableView reloadData];
    }];
    [self.contextMenuTableView updateAlongsideRotation];
    
}

#pragma mark -lazy
- (NSArray *)sectionOneArr{
    if (_sectionOneArr == nil) {
        _sectionOneArr = @[@"昵称",@"性别",@"出生日期",@"地区",@"邮箱"];
    }
    return _sectionOneArr;
}

- (NSArray *)sectionTwoArr{
    if (_sectionTwoArr == nil) {
        _sectionTwoArr = @[@"感情状态",@"银行卡管理"];
    }
    return _sectionTwoArr;
}




@end
