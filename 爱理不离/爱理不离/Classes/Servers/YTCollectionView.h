//
//  YTCollectionView.h

//
//  Created by ios on 16/10/11.
//  Copyright © 2016年 YiHui. All rights reserved.
//

#import <UIKit/UIKit.h>

// item图片的点击协议

@protocol YTCollectionViewDelegate <NSObject>
- (void)ZYCollectionViewClick:(NSInteger)index;
@end

@interface YTCollectionView : UIView
@property (nonatomic, strong) NSArray  * imagesArr;
@property (nonatomic, copy)   NSString * placeHolderImageName;
@property (nonatomic, weak)   id<YTCollectionViewDelegate>delegate;
@end
