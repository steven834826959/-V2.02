//
//  YTGudieViewController.m
//  爱理不离
//
//  Created by Steven on 2016/10/15.
//  Copyright © 2016年 cn.stevenyongtong. All rights reserved.
//

#import "YTGudieViewController.h"
#import "YTNewFeatureCell.h"

@interface YTGudieViewController()<UIScrollViewDelegate>
/**
 *  分页控件
 */
@property (weak,nonatomic) UIPageControl * pageControl;

@end




@implementation YTGudieViewController

static NSString * const reuseIdentifier = @"Cell";
#pragma mark - 生命周期方法
- (void)viewDidLoad{
    [super viewDidLoad];
    
    // 注册cell Class
    [self.collectionView registerClass:[YTNewFeatureCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //分页
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO; //当滚动到内容边缘是否发生反弹，default is YES.
    self.collectionView.showsHorizontalScrollIndicator = NO;//去掉滚动条
    [self setUpPageControl];
    
}
/**
 设置指示器控件
 */
- (void) setUpPageControl
{
    //创建一个分页控件
    UIPageControl *control = [[UIPageControl alloc] init];
    
    control.numberOfPages = 3;
    control.pageIndicatorTintColor = [UIColor blackColor];
    control.currentPageIndicatorTintColor = [UIColor redColor];
    
    //设置center
    control.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height - 40);
    
    _pageControl = control;
    [self.view addSubview:control];
}





/**
 设置流式布局
 */
- (instancetype)init
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    //设置cell的尺寸 = 屏幕size
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    
    //清空行距
    layout.minimumLineSpacing = 0;
    
    //设置滚动方向 水平方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//水平
    return [super initWithCollectionViewLayout:layout];
}

// self.collectionView != self.view
// 注意： self.collectionView 是 self.view的子控件

// 使用UICollectionViewController
// 1.初始化的时候设置布局参数
// 2.必须collectionView要注册cell
// 3.自定义cell


#pragma mark - UIScrollView代理
// 只要一滚动就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取当前的偏移量，计算当前第几页
    int currentPage =scrollView.contentOffset.x /scrollView.bounds.size.width + 0.5;
    self.pageControl.currentPage = currentPage;
}

#pragma mark UICollectionViewDataSource方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

// dequeueReusableCellWithReuseIdentifier
// 1.首先从缓存池里取cell
// 2.看下当前是否有注册Cell,如果注册了cell，就会帮你创建cell
// 3.没有注册，报错
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YTNewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    NSString *imageName = [NSString stringWithFormat:@"new_feature_%ld",indexPath.row + 1];
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    //大屏幕手机
//    if (screenH > 480) { // 5 , 6 , 6 plus
//        imageName = [NSString stringWithFormat:@"new_feature_%ld-568h",indexPath.row + 1];
//    }
    cell.image = [UIImage imageNamed:imageName];
    [cell setIndexPath:indexPath count:3];
    return cell;
    
}



@end
