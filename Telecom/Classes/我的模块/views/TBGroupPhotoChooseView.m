//
//  TBGroupPhotoChooseView.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/13.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBGroupPhotoChooseView.h"
#import "TBTemplateResourceCollectionViewCell.h"
#import "TBMoreReminderView.h"
#import "TBChoosePhotosTool.h"


@interface TBGroupPhotoChooseView()<UICollectionViewDataSource,UICollectionViewDelegate,TBChoosePhotosToolDelegate>

@property (assign, nonatomic) CGFloat  cellWidth;
@property (strong, nonatomic) NSString *defaultName;
// 最大选择数
@property (assign, nonatomic) NSInteger maxRow;
@end
@implementation TBGroupPhotoChooseView
{
    TBChoosePhotosTool * tool;
}
- (NSMutableArray *)imageArray
{
    
    if (!_imageArray)
    {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        tool = [[TBChoosePhotosTool alloc] init];
        tool.delegate = self;
        self.maxRow = 9;
        self.cellWidth = (_SCREEN_WIDTH-(10*4)-20)/3;
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        [flowlayout setItemSize:CGSizeMake(self.cellWidth, self.cellWidth)];
        [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowlayout.minimumInteritemSpacing = 9;
        flowlayout.minimumLineSpacing = 9;
        flowlayout.sectionInset = UIEdgeInsetsMake(10,10,10, 10);
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH-20, 50) collectionViewLayout:flowlayout];
        self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.bounces = NO;
        [self.collectionView registerClass:[TBTemplateResourceCollectionViewCell class] forCellWithReuseIdentifier:TBTemplateResourceCollectionViewCellID];
         [self addSubview:self.collectionView];
        self.defaultName = @"Group_upload";
        TBWeakSelf
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
    }
    return self;
}
#pragma mark <UICollectionViewDataSource>
- (void)updataCollectionView;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self updataCollectionViewHeight];
        [self.collectionView reloadData];
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.imageArray.count == self.maxRow)
    {
        return self.imageArray.count;
    }
    else
    {
        return  self.imageArray.count+1 ;
    }
}

- (TBTemplateResourceCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TBTemplateResourceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TBTemplateResourceCollectionViewCellID forIndexPath:indexPath];
    
    if (indexPath.row<self.imageArray.count)
    {
        [cell valueCellImage:self.imageArray[indexPath.row] showDelete:YES index:indexPath.row];
    }
    else
    {
        [cell valueCellImage:[UIImage imageNamed:self.defaultName] showDelete:NO index:indexPath.row];
    }
    TBWeakSelf
    [cell setDeleteCell:^(NSInteger row)
     {
         [weakSelf friendlyPromptIndex:row];
         
     }];
    return cell;
}
// 提示
- (void)friendlyPromptIndex:(NSInteger)dex
{
    [self endEditing:YES];
    
    TBWeakSelf
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"亲，是否删除当前图片?"];
    [more showHandler:^{
        [weakSelf.imageArray removeObjectAtIndex:dex];
        [weakSelf.collectionView reloadData];
        [self updataCollectionViewHeight];
    }];
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self endEditing:YES];
    if (indexPath.row<self.imageArray.count)
    {
        TBTemplateResourceCollectionViewCell *cell = (TBTemplateResourceCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        
        [tool showPreviewPhotosArray:self.imageArray baseView:cell.backImageView selected:indexPath.row];
    }
    else
    {
        [tool showPhotosIndex:self.maxRow-self.imageArray.count];
    }
}

#pragma mark ---- TBChoosePhotosToolDelegate --

- (void)choosePhotosArray:(NSArray<UIImage*>*)images;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.imageArray addObjectsFromArray:images];
        [self updataCollectionViewHeight];
        [self.collectionView reloadData];
    });
}

/**
 计算cell高度
 */
- (void)updataCollectionViewHeight
{
    NSInteger number = self.imageArray.count/3;
    
    if (number<self.maxRow/3)
    {
        number++;
    }
    if (number == 0) {
        number++;
    }
    CGFloat  constant  = 10+self.cellWidth*number+10*number;

    if (self.updataPhotoViewHeight)
    {
        self.updataPhotoViewHeight(constant);
    }
}

@end
