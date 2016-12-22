//
//  YTHomeCell.m
//  爱理不离
//
//  Created by Steven on 2016/12/1.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTHomeCell.h"
@implementation YTHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 540)];
        self.backImg.userInteractionEnabled = YES;
        self.backImg.image = [UIImage imageNamed:@"三个@2x-1"];
        [self.contentView addSubview:self.backImg];
        [self getProductID];
        
        for (int i = 0; i<3; i++) {
            UIButton *btn = [[UIButton alloc]init];
            [self.contentView addSubview:btn];
            [self.buttonArr addObject:btn];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setBackImg:(UIImageView *)backImg{
    _backImg = backImg;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    for (int i = 0; i<3; i++) {
        UIButton *btn = self.buttonArr[i];
        btn.frame = CGRectMake(0, i * self.frame.size.height / 3.0f, self.frame.size.width, self.frame.size.height / 3.0f);
    }
}


#pragma mark - custom
- (void)getProductID{
    //发送网络请求拿到产品ID；
    [YTHttpTool get:[kDominURL URLStringWithStr:@"/product/get_all_categories"] parameters:nil withCallBack:^(id obj) {
        
        NSString *jsonStr = obj[@"data"];
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        //反序列化
        NSArray *productArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"------获取产品Arr%@",productArr);
        for (int i = 0; i<3; i++) {
            UIButton *btn = self.buttonArr[i];
            btn.tag = [[productArr[i] objectForKey:@"id"] intValue];
        }
    }];
}

#pragma mark - lazy
- (NSMutableArray *)buttonArr{
    if (_buttonArr == nil) {
        _buttonArr = [NSMutableArray array];
    }
    return _buttonArr;
}


@end
