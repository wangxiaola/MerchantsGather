//
//  TBTagsLabelView.m
//  Telecom
//
//  Created by 王小腊 on 2017/11/30.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBTagsLabelView.h"
#import "SDCollectionTagsViewCell.h"

static NSString *const tagsIdentifier = @"tagsIdentifier";

@interface TBTagsLabelView () <
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
// 普通
@property (nonatomic, strong) NSMutableArray<TagsModel *> *ordinaryArray;
// 贫困
@property (nonatomic, strong) NSMutableArray<TagsModel *> *povertyArray;

@property (nonatomic, strong)UICollectionView *collectionView;

@end

@implementation TBTagsLabelView

- (NSMutableArray<TagsModel *> *)ordinaryArray
{
    if (!_ordinaryArray)
    {
        _ordinaryArray = [NSMutableArray array];
    }
    return _ordinaryArray;
}
- (NSMutableArray<TagsModel *> *)povertyArray
{
    if (!_povertyArray)
    {
        _povertyArray = [NSMutableArray array];
    }
    return _povertyArray;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 6;
        flowLayout.minimumInteritemSpacing = 6;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        //注册
        [_collectionView registerClass:[SDCollectionTagsViewCell class] forCellWithReuseIdentifier:tagsIdentifier];
        
    }
    return _collectionView;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setUP];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUP];
    }
    return self;
}
- (void)setViewWithTagsArr:(NSArray<TagsModel *>*)tagsArr;
{
    [self.ordinaryArray removeAllObjects];
    [self.povertyArray removeAllObjects];
    TBWeakSelf
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        
        for (int i = 0; i< tagsArr.count; i++)
        {
            TagsModel *mode = tagsArr[i];
            mode.row = i;

            // 区分员工
            if (mode.type == 1) {
                
                [weakSelf.povertyArray addObject:mode];
                mode.userName = [NSString stringWithFormat:@"%ld.%@",weakSelf.povertyArray.count,mode.nameText];
            }
            else
            {
                [weakSelf.ordinaryArray addObject:mode];
                mode.userName = [NSString stringWithFormat:@"%ld.%@",weakSelf.ordinaryArray.count,mode.nameText];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [weakSelf.collectionView reloadData];
        });
    });
    
    
    
}
-(void)setUP{
    
    [self addSubview:self.collectionView];
    TBWeakSelf
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
}
#pragma mark  ------  UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return section == 0? self.povertyArray.count:self.ordinaryArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *data = indexPath.section == 0? self.povertyArray:self.ordinaryArray;
    
    TagsModel *model = data[indexPath.row];
    CGFloat width = [ZKUtil widthForLabel:[NSString stringWithFormat:@"%@",model.userName] fontSize:14];
    return CGSizeMake(width + 20,24);
}
/**
 定义每个Section的四边间距
 
 @param collectionView collectionView description
 @param collectionViewLayout collectionViewLayout description
 @param section section description
 @return return value description
 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);//分别为上、左、下、右
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SDCollectionTagsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:tagsIdentifier forIndexPath:indexPath];
    
    NSArray *data = indexPath.section == 0? self.povertyArray:self.ordinaryArray;
    TagsModel *model = data[indexPath.row];
    [cell setValueWithModel:model indexRow:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *data = indexPath.section == 0? self.povertyArray:self.ordinaryArray;
    
    TagsModel *model = data[indexPath.row];
    
    if (self.cellClick)
    {
        self.cellClick(model.row);
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

