//
//  YTProductListVC.m
//  爱理不离
//
//  Created by ypp on 16/12/5.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTProductListVC.h"
#import "UIBarButtonItem+MJ.h"
#import "YTBuyDetermineVC.h"
@interface YTProductListVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *textLableArr;
@property(nonatomic,strong)NSArray *detaillabelArr;
//数量相关
@property(nonatomic,strong)UIView *numView;
@property(nonatomic,strong)UIButton *deleteBtn;
@property(nonatomic,strong)UIButton *addBtn;
@property(nonatomic,strong)UITextField *numTF;
@property(nonatomic,strong)UILabel *amountLabel;
@property(nonatomic,strong)UILabel *distrubiton;
@property(nonatomic,strong)UILabel *scoreLabel;

@property(nonatomic,assign)int count;
@property(nonatomic,assign)int amountMoney;
@property(nonatomic,assign)int ytScore;

@end

@implementation YTProductListVC

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    
    self.title = self.productName;
    self.count = 1;
    self.amountMoney = self.count * (int)self.product.minBuy;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                      ];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //去除tableView的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.estimatedRowHeight = 150;  //  随便设个不那么离谱的值
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    //创建头部视图
    [self createHeaderView];
    //创建footerView
    [self creatFooterView];
    
    
}


#pragma mark - custom
- (void)leftButtonTapped{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//永同积分算法
- (NSString *)getMyYTScore{
    int count = self.product.credits;
    
    if (self.amountMoney >= 100 && self.amountMoney <= 400) {
        self.ytScore = count * self.count;
    }else if (self.amountMoney >= 500 && self.amountMoney <=900){
        self.ytScore =  count * 5 + count * 1 + count * (self.count - 5);
    }else if (self.amountMoney >= 1000 && self.amountMoney <= 1400){
        self.ytScore = count * 10 + count * 1 + count * 2 + count * (self.count - 10);
    }else if (self.amountMoney >= 1500 && self.amountMoney <2000){
        self.ytScore = count * 15 + count * 1 + count * 2 + count * 3 + count * (self.count - 15);
    }else if (self.amountMoney == 2000){
        self.ytScore = count * 30;
    }else if (self.amountMoney > 2000){
        self.ytScore = count * 30 + count * (self.count - 20);
    }
    NSString *scoreStr = [NSString stringWithFormat:@"%d",self.ytScore];
    
    return scoreStr;
}


- (void)initNavTitle{
    self.navigationController.navigationBar.tintColor = YTColor(216, 162, 164);
}
- (void)createHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *titleView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    titleView.image = [UIImage resizedImage:@"爱你妹"];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.text = self.product.name;
    [headerView addSubview:titleView];
    [headerView addSubview:titleLabel];
    self.tableView.tableHeaderView = headerView;
}

- (void)creatFooterView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    
    
    UIButton *buyBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 30, SCREEN_WIDTH - 100, 40)];
    [buyBtn setBackgroundImage:[UIImage resizedImage:@"服务兑换"] forState:UIControlStateNormal];
    [buyBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];

    [footerView addSubview:buyBtn];
    
    self.tableView.tableFooterView = footerView;

}




- (CGFloat)fontWidth:(NSString *)src fontSize:(float)size width:(float)width {
    return [src boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size.height;
}

//购买之后跳转到详细页面
- (void)buy{
    
    YTBuyDetermineVC *buyDetermine = [[YTBuyDetermineVC alloc]init];
    
    buyDetermine.rate = self.product.annualRate;
    buyDetermine.amountMoney = self.amountMoney;
    buyDetermine.productModel = self.product;
    buyDetermine.count = self.count;
    [self.navigationController pushViewController:buyDetermine animated:YES];
}

- (void)initNumView{
    self.numView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 180, 44)];
    
    self.numView.backgroundColor = [UIColor clearColor];
    
    self.deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    [self.deleteBtn setTitle:@"-" forState:UIControlStateNormal];
    
    [self.deleteBtn addTarget:self action:@selector(deletedClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.numView addSubview:self.deleteBtn];
    self.numTF = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.deleteBtn.frame), 0, 80, 44)];
    [self.deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.numTF.text = [NSString stringWithFormat:@"%d",self.count];
    self.numTF.textAlignment = NSTextAlignmentCenter;
    self.numTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.numView addSubview:self.numTF];
    self.addBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.numTF.frame), 0, 50, 44)];
    [self.addBtn setTitle:@"+" forState:UIControlStateNormal];
    [self.addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.numView addSubview:self.addBtn];
}

- (void)addClicked{
    self.count = self.count + 1;
    self.numTF.text = [NSString stringWithFormat:@"%d",self.count];
    self.amountMoney = self.count * 100;
    self.amountLabel.text = [NSString stringWithFormat:@"%d",self.amountMoney];
    
    self.scoreLabel.text = [self getMyYTScore];
    
}

- (void)deletedClicked{
    self.count = self.count -1;
    if (self.count == 0) {
        //提示不能为0；
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"数量不能为0" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.count = 1;
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        self.numTF.text = [NSString stringWithFormat:@"%d",self.count];
        self.amountMoney = self.count * 100;
        self.amountLabel.text = [NSString stringWithFormat:@"%d",self.amountMoney];
    }
    
    self.scoreLabel.text = [self getMyYTScore];
}

#pragma mark  - tabelViweDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }

    switch (indexPath.row) {
        case 0://购买期限
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.text = self.textLableArr[indexPath.row];
            cell.backgroundColor = [UIColor clearColor];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",self.product.deadline];
            break;
        case 2://起购金额
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.text = self.textLableArr[indexPath.row];
            cell.backgroundColor = [UIColor clearColor];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",self.product.minBuy];
            
            break;
        case 4://积分
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.text = self.textLableArr[indexPath.row];
            cell.backgroundColor = [UIColor clearColor];

            self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
            self.scoreLabel.textAlignment = NSTextAlignmentRight;
            self.scoreLabel.textColor = [UIColor blackColor];
            self.scoreLabel.font = [UIFont systemFontOfSize:14];
            
            self.scoreLabel.text = [NSString stringWithFormat:@"%d",self.product.credits];
            cell.accessoryView = self.scoreLabel;
             
            break;
        case 1:{//产品描述
            cell.textLabel.textColor = YTColor(216, 162, 164);
            cell.textLabel.text = self.textLableArr[indexPath.row];
            
            self.distrubiton = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 0)];
            self.distrubiton.textColor = YTColor(216, 162, 164);
            self.distrubiton.font = [UIFont systemFontOfSize:14];
            self.distrubiton.text = self.product.productDesc;
            self.distrubiton.text = @"1234567890";
            self.distrubiton.numberOfLines = 0;
            [self.distrubiton sizeToFit];
            cell.accessoryView = self.distrubiton;
        }
            break;
        case 3://数量
        {
            cell.textLabel.textColor = YTColor(216, 162, 164);
            cell.textLabel.text = self.textLableArr[indexPath.row];
            cell.backgroundColor = [UIColor whiteColor];
            [self initNumView];
            cell.accessoryView = self.numView;
        }
            break;
        case 5://总金额
            cell.textLabel.textColor = YTColor(216, 162, 164);
            cell.textLabel.text = self.textLableArr[indexPath.row];
        {
            self.amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
            self.amountLabel.text = [NSString stringWithFormat:@"%d",self.amountMoney];
            cell.accessoryView = self.amountLabel;
        
        }
            break;
        case 6:
            cell.backgroundColor = [UIColor clearColor];
            break;
        default:
            break;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
        CGSize size = [self.product.productDesc boundingRectWithSize:CGSizeMake(200.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        
        NSLog(@"-----------%f",size.height);
        
        
        return size.height > 44.0f ? size.height : 44;
    }else{
        return 44;
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark  - lazy
- (NSArray *)textLableArr{
    if (_textLableArr == nil) {
        _textLableArr = @[@"爱的期限",@"产品说明",@"起购金额",@"数量",@"积分",@"合计"];
    }
    return _textLableArr;
}

- (NSArray *)detaillabelArr{
    if (_detaillabelArr == nil) {
        _detaillabelArr = @[@(self.product.deadline),self.product.description,@(self.product.minBuy),@(self.product.credits)];
    }
    return _detaillabelArr;
}


@end
