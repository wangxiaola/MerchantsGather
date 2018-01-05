//
//  NBScrollViewController.m
//  UIPageViewController
//
//  Created by 汤亮 on 16/6/5.
//  Copyright © 2016年 tangliang. All rights reserved.
//

#import "NBScrollContainer.h"

static NSString *const NBViewControllerCollectionViewCellID = @"NBViewControllerCollectionViewCell";

@interface NBScrollContainer () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) UICollectionView *collectionView;
@end

@implementation NBScrollContainer
- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self.collectionView removeFromSuperview];
    self.collectionView = nil;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    collectionView.backgroundColor = UIColor.clearColor;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NBViewControllerCollectionViewCellID];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (void)showViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollContainer:didShowViewControllerAtIndex:)]) {
        CGFloat xRatio = scrollView.contentOffset.x / scrollView.bounds.size.width;
        NSInteger index = (NSInteger)(xRatio + 0.5);
        [self. delegate scrollContainer:self didShowViewControllerAtIndex:index];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging)]) {
        [self.delegate scrollViewWillBeginDragging];
    }

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollContainer:didScroll:)]) {
        [self.delegate scrollContainer:self didScroll:scrollView.contentOffset];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource numberOfViewControllersInScrollContainView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NBViewControllerCollectionViewCellID forIndexPath:indexPath];
    UIViewController *vc = [self.dataSource scrollContainer:self viewControllerForIndex:indexPath.item];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.contentView addSubview:vc.view];
    vc.view.frame = cell.contentView.bounds;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(scrollContainerItemSize:)]) {
        return [self.delegate scrollContainerItemSize:self];
    }
    return self.bounds.size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

@end
