//
//  YTMyAddressVC.m
//  爱理不离
//
//  Created by ios on 16/12/7.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTMyAddressVC.h"
#import "UIBarButtonItem+MJ.h"
#import "YTUserAddressCell.h"
#import "YTAddAddressVC.h"
#import "UIBarButtonItem+MJ.h"
#import "MJExtension.h"
#import "YTAddressModel.h"
#import "YTReviseAddressVC.h"

static const CGFloat MJDuration = 1.0;
@interface YTMyAddressVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *addressArr;

@end

@implementation YTMyAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置UI
    [self setUpInterface];
    //获取所有地址
//    [self getUserAddresses];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self getUserAddresses];
}
#pragma mark  - custom
- (void)setUpInterface {
    
    self.title = @"收货地址管理";
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.size.width, self.view.size.height)];
    backView.image = [UIImage imageNamed:@"backView"];
    [self.view addSubview:backView];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImage:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    //右边导航栏按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"银行卡1" highIcon:@"银行卡1" target:self action:@selector(addMenuButtonTapped)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"返回" highIcon:@"返回" target:self action:@selector(back)];
    
    [self tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YTUserAddressCell" bundle: [NSBundle mainBundle]] forCellReuseIdentifier:@"userAddressCell"];
}
//新增地址
- (void)addMenuButtonTapped{
    
    YTAddAddressVC *VC = [YTAddAddressVC new];
    
    VC.addressIndex = self.addressArr.count;
    
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.addressArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    YTUserAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userAddressCell"];
    cell.reviseAddress.tag = indexPath.row;
    cell.deleteAddress.tag = indexPath.row;
    
    YTAddressModel *model = self.addressArr[indexPath.row];
    cell.userName.text = model.shippingName;
    cell.phoneNumber.text = model.shippingMobile;
    
    //拼接用户的收货地址
    cell.userAddress.text = [NSString stringWithFormat:@"%@ %@",model.province,model.address];
    
    //修改地址
    [cell.reviseAddress addTarget:self action:@selector(reviseAddressWithAddressId:) forControlEvents:UIControlEventTouchUpInside];
    //删除地址
    [cell.deleteAddress addTarget:self action:@selector(deleteUserAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    //让cell不可选
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}



#pragma mark ToolMethods
//删除地址
- (void)deleteUserAddress:(UIButton *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    
    YTAddressModel *model = self.addressArr[sender.tag];
    [YTHttpTool post:[kDominURL URLStringWithStr:@"/user/user_address.delete"] parameters:@{@"addressId":@(model.ID)} withCallBack:^(id obj) {
        //请求成功后
        if ([[obj objectForKey:@"code"] intValue] == 0) {
            [self.addressArr removeObjectAtIndex:sender.tag];
            
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            [self.tableView reloadData];
        }
    }];
}

//修改地址
- (void)reviseAddressWithAddressId:(UIButton *)sender{
    
    YTReviseAddressVC *vc = [[YTReviseAddressVC alloc]init];
    YTAddressModel *model = self.addressArr[sender.tag];
    vc.userNameStr = model.shippingName;
    vc.phoneNumberStr = model.shippingMobile;
    vc.provinceStr = model.province;
    vc.detailAddressStr = model.address;
    vc.postalCodeStr = model.zipCode;
    
    vc.addressID = model.ID;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)getUserAddresses {
    
    [YTHttpTool post:[kDominURL URLStringWithStr:@"/user/user_address_list.get"] parameters:nil withCallBack:^(id obj) {
       
        NSString *dataString = [obj objectForKey:@"data"];
        NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"...........%@",dataArray);
        self.addressArr = [YTAddressModel mj_objectArrayWithKeyValuesArray:dataArray];
        
        NSLog(@"---------------count：%ld",self.addressArr.count);
        [self.tableView reloadData];
        
    }];
    
}

#pragma mark  - lazy
- (NSMutableArray *)addressArr{
    if (_addressArr == nil) {
        _addressArr = [NSMutableArray array];
    }
    return _addressArr;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        //设置代理
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //注册cell
        
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}



@end
