//
//  YTServiceDetailVC.m
//  爱理不离
//
//  Created by ypp on 16/12/12.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTServiceDetailVC.h"
#import "YTCollectionView.h"
#import "YTServiceDetailTableViewCell.h"
#import "UIBarButtonItem+MJ.h"
#import "LoginViewController.h"
#import "YTSocreChangeVC.h"


@interface YTServiceDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIToolbar *toolBar;
@property(nonatomic,strong)UIWebView *webView;
@property (assign, nonatomic) float oldOffset_y;
@property(nonatomic,strong)NSMutableArray *carouselArr;


@end

@implementation YTServiceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务详情";
    
    NSLog(@"---------%@",self.seviceModel.remark);
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    
    //网页预加载
    self.webView = [[UIWebView alloc]init];
    
    NSString *remarkStr = [self.seviceModel.remark stringByReplacingOccurrencesOfString:@"src=\"" withString:@"src=\"http://117.78.50.198"];
    
    [self.webView loadHTMLString:remarkStr baseURL:nil];
    self.webView.delegate = self;
    
    self.webView.scrollView.scrollEnabled = NO;
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView setOpaque:NO];
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"YTServiceDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"serviceDetailCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
    [self.view addSubview:self.tableView];
    //设置代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //初始化轮播数组,必须在创建headerView之前
    self.carouselArr = [NSMutableArray array];
    NSArray *baseURL = [self.seviceModel.cover componentsSeparatedByString:@","];
    
    NSLog(@"封面%@",baseURL);
    for (int i = 1; i < baseURL.count ; i++) {
        [self.carouselArr addObject:[kDominURL URLStringWithStr:baseURL[i]]];
    }
    NSLog(@"-------封面完整%@",self.carouselArr);
    
    
    
    [self creatHeaderView];
    
    [self creatToolBar];
    
    
 
}

#pragma mark - custom
- (void)leftButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatToolBar{
    self.navigationController.toolbar.hidden = NO;
    self.navigationController.toolbar.frame = CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44);
    UIButton *exchangeBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH, 44)];
    [exchangeBtn setBackgroundColor:YTColor(159, 156, 194)];
    [exchangeBtn setTitle:@"兑  换" forState:UIControlStateNormal];
    [exchangeBtn addTarget:self action:@selector(clickToolBarItem1) forControlEvents:UIControlEventTouchUpInside];
    //设置主item
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:exchangeBtn];
    //设置左缩进
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //设置右缩进
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    NSArray<UIBarButtonItem *> *arr = [NSArray arrayWithObjects:item2, item1, item3,  nil];
    self.navigationController.toolbar.items = arr;
    
}



//时间戳的转换
- (NSString *)dateStr{
    
    NSString *startTime = self.seviceModel.createTime;//时间戳
    NSString *endTime = self.seviceModel.endTime;
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[startTime intValue] / 1000.0f];
    
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[endTime intValue]];
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //用[NSDate date]可以获取系统当前时间
    
    NSString *startDateStr = [dateFormatter stringFromDate:startDate];
    
    NSString *endDateStr = [dateFormatter stringFromDate:endDate];
    return [NSString stringWithFormat:@"%@ 至 %@",startDateStr,endDateStr];

}






#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 3) {
         YTServiceDetailTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"serviceDetailCell" forIndexPath:indexPath];
        NSArray *textLabelArr = @[@"积分",@"使用有效期",@"库存"];
        NSArray *detailArr = @[[NSString stringWithFormat:@"%d",self.seviceModel.credits],[self dateStr],[NSString stringWithFormat:@"%d",self.seviceModel.stock]];
        cell.leftlabel.text = textLabelArr[indexPath.row];
        [cell.rightLable sizeToFit];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.rightLable.text = detailArr[indexPath.row];
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
        cell.backgroundColor = YTColor(159, 156, 194);
        
        UILabel *remarklabel = [cell.contentView viewWithTag:500];
        if (remarklabel == nil) {
            remarklabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
            remarklabel.textAlignment = NSTextAlignmentCenter;
            remarklabel.text = @"备注";
            remarklabel.textColor = [UIColor whiteColor];
            [cell.contentView addSubview:remarklabel];
        }
        
        [cell.contentView addSubview:self.webView];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        NSLog(@"---------返回高度%f",self.webView.frame.size.height + 30);
        
        return self.webView.frame.size.height + 30;
        
        
    }else {
        return 44;
    }
}

#pragma mark - webviewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取到webview的高度
    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    self.webView.frame = CGRectMake(0,30, SCREEN_WIDTH,height);
    [self.tableView reloadData];
}

#pragma mark ToolMethods
- (void)clickToolBarItem1 {
    NSLog(@"-----服务兑换请求");
    NSLog(@"------服务id  %d",self.seviceModel.seviceId);
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"loginStatus"]) {
        
        [YTHttpTool post:[kDominURL URLStringWithStr:@"/user/service.exchange"] parameters:@{@"serviceId":@(self.seviceModel.seviceId)} withCallBack:^(id obj) {
            NSLog(@"-------兑换返回%@",obj);
            
            if ([[obj objectForKey:@"code"] intValue] == 0) {
                NSLog(@"兑换成功");
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜" message:@"兑换成功！" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"去我的兑换看看？" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //执行操作
                    YTSocreChangeVC *changed = [[YTSocreChangeVC alloc]init];
                    [self.navigationController pushViewController:changed animated:YES];
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:action];
                [alert addAction:action2];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                 [self presentViewController:[AlertTool alertWithTitle:@"提示" Message:[obj objectForKey:@"message"] actionTitle:@"确认" andStyle:1] animated:YES completion:nil];
            }
            
            
        }];

        
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有登录！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //弹出登录控制器
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
            [self presentViewController:nav animated:YES completion:nil];
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
}
#pragma mark 图片轮播
- (void)creatHeaderView {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 230)];
    YTCollectionView *cycleView = [[YTCollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    UIView *headBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 30)];
    [headerView addSubview:cycleView];
    [headerView addSubview:headBottomView];
    headBottomView.backgroundColor = [UIColor redColor];
    cycleView.placeHolderImageName = @"0K143Xa_0.jpg";
    cycleView.imagesArr = self.carouselArr;
    
    NSLog(@"--------封面返回%@",self.carouselArr);
    
    UIImageView *photoDetailImg = [[UIImageView alloc]initWithFrame:CGRectMake(12, 0, 200, headBottomView.frame.size.height)];
    photoDetailImg.image = [UIImage resizedImage:@""];
    [headBottomView addSubview:photoDetailImg];
    
    UILabel *photoDetail = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 200, headBottomView.frame.size.height)];
    headBottomView.backgroundColor = [UIColor clearColor];
    photoDetail.text = @"服务说明";
    [headBottomView addSubview:photoDetail];
    photoDetail.textColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
}
#pragma mark lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , self.view.frame.size.height - 46 - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}



@end
