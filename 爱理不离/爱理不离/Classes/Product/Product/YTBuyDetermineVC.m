//
//  YTBuyDetermineVC.m
//  爱理不离
//
//  Created by Steven on 2016/12/7.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTBuyDetermineVC.h"
#import "UIBarButtonItem+MJ.h"
#import "LoginViewController.h"
#import "YTServicesViewController.h"
@interface YTBuyDetermineVC ()

@property(nonatomic,assign)float balance;
@property(nonatomic,strong)UIView *infoView;
@end

@implementation YTBuyDetermineVC
#pragma mark - life
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"确认购买";
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(leftButtonTapped)];
    
    
    [self initBuyView];
    
    [self setupBuyBtn];
    
}
#pragma mark  - custom
- (void)leftButtonTapped{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)initBuyView{
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 30)];
    headerLabel.backgroundColor = YTColor(159.0, 156.0, 194.0);
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.text = @"支付信息";
    headerLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:headerLabel];
    
    UIImageView *infoView = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(headerLabel.frame) + 10, SCREEN_WIDTH - 20, 200)];
    UIImage *baseImg = [UIImage imageNamed:@"确认密码"];
    infoView.userInteractionEnabled = YES;
    infoView.image = [baseImg resizableImageWithCapInsets:UIEdgeInsetsMake(80, 80, 80, 80) resizingMode:UIImageResizingModeStretch];
    [self.view addSubview:infoView];
    
    self.infoView = infoView;
    
    //信息视图中的内容
    UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH - 20 - 20, 1)];
    topLineView.backgroundColor = [UIColor lightGrayColor];
    topLineView.alpha = .5f;
    
    UIView *bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(infoView.frame) - 110, SCREEN_WIDTH - 20 - 20, 1)];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    bottomLineView.alpha = .5f;
    [infoView addSubview:topLineView];
    [infoView addSubview:bottomLineView];
    
    UILabel *leftTop = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 100, 30)];
    leftTop.textColor = [UIColor lightGrayColor];
    leftTop.text = @"购买金额";
    leftTop.font =[UIFont systemFontOfSize:14];
    [infoView addSubview:leftTop];
    
    UILabel *rightTop = [[UILabel alloc]initWithFrame:CGRectMake(infoView.frame.size.width - 10 - 100, leftTop.frame.origin.y, 100, 30)];
    rightTop.textAlignment = NSTextAlignmentRight;
    rightTop.textColor = [UIColor lightGrayColor];
    rightTop.text = [NSString stringWithFormat:@"%d元",self.amountMoney];
    rightTop.font =[UIFont systemFontOfSize:14];
    [infoView addSubview:rightTop];
    
    UILabel *bottomLeft = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMinY(bottomLineView.frame) - 30, 100, 30)];
    bottomLeft.textColor = [UIColor lightGrayColor];
    bottomLeft.font =[UIFont systemFontOfSize:14];
    bottomLeft.text = @"以往利率";
    [infoView addSubview:bottomLeft];
    
    UILabel *bottomRight = [[UILabel alloc]initWithFrame:CGRectMake(infoView.frame.size.width - 110, bottomLeft.frame.origin.y, 100, 30)];
    bottomRight.textAlignment = NSTextAlignmentRight;
    bottomRight.textColor = [UIColor lightGrayColor];
    bottomRight.font =[UIFont systemFontOfSize:14];
    bottomRight.text = [NSString stringWithFormat:@"%.1f%%(仅供参考)",self.rate];
    [infoView addSubview:bottomRight];
    
    //余额label
    UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMinY(bottomLineView.frame) + 5, infoView.frame.size.width - 100, 30)];
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    balanceLabel.textColor =[UIColor lightGrayColor];
    balanceLabel.text =[NSString stringWithFormat:@"余额    %.2f元",self.balance];
    [infoView addSubview:balanceLabel];
}
- (void)setupBuyBtn{
    //协议Label
    UILabel *protocolLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.infoView.frame) + 50 , SCREEN_WIDTH, 30)];
    //添加手势敲击事件
    UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTaped)];
    [protocolLabel addGestureRecognizer:labelTap];
    protocolLabel.text = @"我已阅读并同意《永同财富平台用户协议》";
    protocolLabel.font = [UIFont systemFontOfSize:14];
    protocolLabel.textColor = [UIColor whiteColor];
    protocolLabel.textAlignment =NSTextAlignmentCenter;
    [self.view addSubview: protocolLabel];
    
    //购买button
    UIButton *buySureBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(protocolLabel.frame) + 20 , SCREEN_WIDTH - 100, 40)];
    [buySureBtn setBackgroundImage:[UIImage resizedImage:@"服务兑换"] forState:UIControlStateNormal];
    [buySureBtn setTitleColor:YTColor(206, 143, 146) forState:UIControlStateNormal];
    [buySureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [buySureBtn addTarget:self action:@selector(buyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buySureBtn];
}

- (void)labelTaped{
    //跳转到协议控制器
    

    
}
- (void)buyBtnClicked{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"loginStatus"]) {
        
        //购买请求
        [YTHttpTool post:[kDominURL URLStringWithStr:@"/user/order/order.place"] parameters:@{@"productId":@(self.productModel.product_Id),@"buyNum":@(self.count)} withCallBack:^(id obj) {
            
            NSLog(@"--------购买产品返回%@",obj);
            if ([[obj objectForKey:@"code"] intValue] == 0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜" message:@"购买成功！" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"去积分兑换区看看？" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    YTServicesViewController *sevice = [[YTServicesViewController alloc]init];
                    
                    [self.navigationController pushViewController:sevice animated:YES];
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

@end
