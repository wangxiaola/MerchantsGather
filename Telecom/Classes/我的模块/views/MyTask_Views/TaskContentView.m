
//
//  TaskContentView.m
//  Telecom
//
//  Created by zhangxingdong 张兴栋 on 16/12/6.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TaskContentView.h"


static NSString *const CollectionViewCell_ID = @"CollectionViewCell_ID";

@interface TaskContentView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layOut;
@property (nonatomic, strong) NSMutableDictionary * ViewDictionary;
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, assign) CGFloat offset;

@end

@implementation TaskContentView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
         self.backgroundColor = RGB(245, 245, 245);
        [self addSubview:self.collectionView];
        self.offset = 0;
    }
    return self;
}

- (NSMutableDictionary *)ViewDictionary
{
    if (!_ViewDictionary) {
         _ViewDictionary = [NSMutableDictionary dictionary];
    }
    return _ViewDictionary;
}

- (UICollectionViewFlowLayout *)layOut
{
   if (!_layOut) {
        _layOut = [[UICollectionViewFlowLayout alloc] init];
        _layOut.itemSize = CGSizeMake(self.bounds.size.width,self.bounds.size.height);
        _layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layOut.minimumLineSpacing = 0;
        _layOut.minimumInteritemSpacing = 0;
        _layOut.sectionInset = UIEdgeInsetsZero;
    }
    return _layOut;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
         _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,self.bounds.size.width, self.bounds.size.height) collectionViewLayout:self.layOut];
         _collectionView.delegate = self;
         _collectionView.dataSource = self;
         _collectionView.backgroundColor = [UIColor blueColor];
         _collectionView.bounces = NO;
         _collectionView.pagingEnabled = YES;
         _collectionView.showsVerticalScrollIndicator = NO;
         _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCell_ID];
    }
    return _collectionView;
}


#pragma mark --- UICollectionViewDelegate


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    UICollectionViewCell * collecCell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCell_ID forIndexPath:indexPath];
    [collecCell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    // 添加控制器视图
     _viewController = [self.ViewDictionary valueForKey:[NSString stringWithFormat:@"controller_%ld",(long)indexPath.row]];
    
    if (self.delegate) {
        if (!_viewController) {
            if ([self.delegate respondsToSelector:@selector(selectViewController_And_For_indexpath:)]) {
                 _viewController = [self.delegate selectViewController_And_For_indexpath:indexPath.row];
                 [self.ViewDictionary setValue:_viewController forKey:[NSString stringWithFormat:@"controller_%ld",(long)indexPath.row]];
            }
        }
        [self AddChildViewParentView:collecCell];
    }
    
    return collecCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
// UICollectionView视图开始滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _offset = scrollView.contentOffset.x;
}
// UICollectionView视图滑动结束
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat newOffset = scrollView.contentOffset.x;
    NSInteger index = newOffset / scrollView.frame.size.width;
    NSInteger total = scrollView.contentSize.width / scrollView.frame.size.width;

    if (_offset == scrollView.contentOffset.x) {
         _viewController = [self.ViewDictionary valueForKey:[NSString stringWithFormat:@"controller_%ld",(long)index]];
    }
    
    CGFloat progress = newOffset / scrollView.frame.size.width;
    // 控制滑动进程
    if ( index < total && index >= 0) {
        
        if (newOffset > _offset) { // 向右滑动
            self.progressBLK(progress,index);
        } else if (newOffset < _offset){
            CGFloat LeftProgress = 1 - progress;
            if (LeftProgress <0) {
                LeftProgress = 0;
            }
            self.progressBLK(-LeftProgress,index);
        }
    }
    
}

// UICollectionView减速完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 判断滑动方向
    
    CGFloat newOffset = scrollView.contentOffset.x;
    NSInteger index = newOffset / scrollView.frame.size.width;
    NSInteger total = scrollView.contentSize.width / scrollView.frame.size.width;
    
     if (index > 0 && index < total) {
         _viewController = [self.ViewDictionary valueForKey:[NSString stringWithFormat:@"controller_%ld",(long)index]];
   }
}

// 手动设置的偏移距离
- (void)setTheOffsetDistance:(CGPoint)pointOffset animationd:(BOOL)animated
{
    [self.collectionView setContentOffset:pointOffset animated:animated];
}


#pragma mark -- AddChildViewParentView


- (void)AddChildViewParentView:(UICollectionViewCell *)cell
{
    [cell.contentView addSubview:_viewController.view];
    [_viewController didMoveToParentViewController:self.delegate];
}



@end
