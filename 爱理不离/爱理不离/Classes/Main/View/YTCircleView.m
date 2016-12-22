//
//  TYCircleView.m
//  TYCircleMenu
//
//  Created by Yeekyo on 16/3/24.
//  Copyright © 2016年 Yeekyo. All rights reserved.
//

#import "YTCircleView.h"

@implementation YTCircleView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    //1.获取上下文- 当前绘图的设备
        CGContextRef context = UIGraphicsGetCurrentContext();
    //设置路径
    /*
     CGContextRef c:上下文
     CGFloat x ：x，y圆弧所在圆的中心点坐标
     CGFloat y ：x，y圆弧所在圆的中心点坐标
     CGFloat radius ：所在圆的半径
     CGFloat startAngle ： 圆弧的开始的角度  单位是弧度  0对应的是最右侧的点；
     CGFloat endAngle  ： 圆弧的结束角度
     int clockwise ： 顺时针（0） 或者 逆时针(1)
     */
    CGContextAddArc(context, 250, 250, 160, - M_PI_4 * 2, M_PI, 1);
    CGContextSetStrokeColorWithColor(context, YTColor(123, 122, 176).CGColor);
    
    CGContextSetLineWidth(context, 80);
    
    //绘制圆弧
    CGContextDrawPath(context, kCGPathStroke);

}

    
@end
