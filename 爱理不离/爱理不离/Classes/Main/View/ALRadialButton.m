//
//  ALRadialButton.m
//  ALRadial
//
//  Created by andrew lattis on 12/10/14.
//  Copyright (c) 2012 andrew lattis. All rights reserved.
//  http://andrewlattis.com
//

#import "ALRadialButton.h"

@implementation ALRadialButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setBackgroundColor:[UIColor yellowColor]];
        
        // 1.图片居中
        self.imageView.contentMode = UIViewContentModeCenter;
        
        // 2.文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
    }
    return self;
}



#pragma mark 设置按钮标题的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleY = contentRect.size.height * 0.5;
    CGFloat titleH = contentRect.size.height - titleY;
    CGFloat titleW = contentRect.size.width;
    return CGRectMake(0, titleY, titleW,  titleH);
}

#pragma mark 设置按钮图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageH = contentRect.size.height * 0.5;
    CGFloat imageW = contentRect.size.width;
    return CGRectMake(0, 0, imageW,  imageH);
}


- (void)willAppear {
	//rotate the button upsidedown so its right side up after the 180 degree rotation while its moving out
	[self.imageView setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, 180/180*M_PI)];
	
    if (self.shouldFade) {
        self.alpha = 0.0;
    }
	
	[UIView animateWithDuration:.25f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
		
		//this animation rotates the button 180 degree's, and moves the center point to the end of the "string"
		[self setCenter:self.bouncePoint];
		[self.imageView setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, 180/180*M_PI)];
        if (self.shouldFade) {
            self.alpha = 1.0;
        }
		
	} completion:^(BOOL finished) {
		
		[UIView animateWithDuration:.15f animations:^{
			//a little bounce back at the end
			[self setCenter:self.centerPoint];
		}];
		
	}];
    
    
    //circleView显示
    [[NSNotificationCenter defaultCenter]postNotificationName:@"circleViewShow" object:nil];
    
    
}


- (void)willDisappear {
    if (self.shouldFade) {
        self.alpha = 1.0;
    }
    
	[UIView animateWithDuration:.15f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
		
		//first do the rotate in place animation
		[self.imageView setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, -(180/180*M_PI))];
	
	} completion:^(BOOL finished) {
		
		[UIView animateWithDuration:.25f animations:^{
			//now move it back to the origin button
			[self setCenter:self.originPoint];
            if (self.shouldFade) {
                self.alpha = 0.0;
            }
			
		} completion:^(BOOL finished) {
			//finally tell the delegate we are done so it can cleanup memory
			[self.delegate buttonDidFinishAnimation:self];
		}];
		
	}];
}

@end
