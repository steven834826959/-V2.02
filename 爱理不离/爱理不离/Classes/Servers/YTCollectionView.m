
//
//  YTCollectionView.m

//
//  Created by ios on 16/10/11.
//  Copyright © 2016年 YiHui. All rights reserved.
//

#import "YTCollectionView.h"
#import "YTCollectionViewCell.h"
#define ZYCycleID @"ZYCycleID"

@interface YTCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout * layout;
@property (nonatomic, strong) UIPageControl    * pageControl;
@property (nonatomic, strong) UICollectionView * cycleCollectionView;
@property (nonatomic, strong) NSTimer          * timer;
@property (nonatomic, assign) NSInteger index;

@end


@implementation YTCollectionView


- (void)setImagesArr:(NSArray *)imagesArr {
    _imagesArr = imagesArr;
    if (self.pageControl){
        self.pageControl.numberOfPages = imagesArr.count;
    }
    
    // 如果图片数量小于二 将pageControl隐藏
    if (imagesArr.count < 2) {
        self.pageControl.hidden = YES;
    }
    
    if (self.cycleCollectionView){
        [_cycleCollectionView reloadData];
        [self startAutoCarousel];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createCycleView];
        [self createPageControl];
    }
    return self;
}


-(void)createPageControl{
    if (_pageControl) {
        return;
    }
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_cycleCollectionView.frame) - 30, self.frame.size.width, 30)];
    _pageControl.userInteractionEnabled = YES;
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:_pageControl];
}


- (void)createCycleView {
    if (_layout) {
        return;
    }
    _layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing      = 0;
    _layout.scrollDirection         = UICollectionViewScrollDirectionHorizontal;
    
    _cycleCollectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:_layout];
    _cycleCollectionView.backgroundColor = [UIColor whiteColor];
    

    //停靠模式，宽高都自由
    _cycleCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _cycleCollectionView.delegate = self;
    _cycleCollectionView.dataSource = self;
    _cycleCollectionView.pagingEnabled = YES;
    _cycleCollectionView.showsHorizontalScrollIndicator= NO;
    [self addSubview:_cycleCollectionView];
    
    [_cycleCollectionView registerClass:[YTCollectionViewCell class] forCellWithReuseIdentifier:ZYCycleID];
}




- (void)roll {
    if (_cycleCollectionView) {
        //取出当前显示的cell
        NSIndexPath * indexPath = [_cycleCollectionView indexPathsForVisibleItems].lastObject;
        if (indexPath) {
            //显示下一张
            [_cycleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item + 1 inSection:0] atScrollPosition:0 animated:YES];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),dispatch_get_main_queue(),^{
            [self scrollViewDidEndDecelerating:_cycleCollectionView];
        });
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControl.currentPage = self.index;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.imagesArr.count >= 2) {
        return INT16_MAX;
    } else {
        return self.imagesArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YTCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZYCycleID forIndexPath:indexPath];
    cell.placeHolderImageName  = self.placeHolderImageName;
    self.index = [self indexWithOffset:indexPath.item];
    NSInteger imageIndex       = self.index;
    cell.imagesUrl             = self.imagesArr[imageIndex];
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(ZYCollectionViewClick:)]) {
        [self.delegate ZYCollectionViewClick:[self indexWithOffset:indexPath.item]];
    }
}

- (NSInteger)indexWithOffset:(NSInteger)offset {
    return offset % self.imagesArr.count;
}


#pragma mark - 将要开始拖拽，停止自动轮播
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopAutoCarousel];
}

#pragma mark - 已经结束拖拽，启动自动轮播
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startAutoCarousel];
}

- (void)stopAutoCarousel {
    if (_timer == nil) {
        return;
    }
    [_timer invalidate];
    _timer = nil;
}

- (void)startAutoCarousel {
    if (self.imagesArr.count >= 2){
        if (_timer) {
            return;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(roll) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

@end
