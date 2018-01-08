//
//  ZKBusinessIntelligencePhotoTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/1.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBusinessIntelligencePhotoTableViewCell.h"
#import "TBTemplateResourceCollectionViewCell.h"
#import "TBMoreReminderView.h"
#import "TBChoosePhotosTool.h"

@interface TBBusinessIntelligencePhotoTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,TBChoosePhotosToolDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (assign, nonatomic) CGFloat  cellWidth;

@end

@implementation TBBusinessIntelligencePhotoTableViewCell
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
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    tool = [[TBChoosePhotosTool alloc] init];
    tool.delegate = self;
    self.defaultRow = 1;
    self.cellWidth = (_SCREEN_WIDTH-(10*4)-1)/3;
    [self updataCollectionViewHeight];
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    [flowlayout setItemSize:CGSizeMake(self.cellWidth, self.cellWidth)];
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowlayout.minimumInteritemSpacing = 9;
    flowlayout.minimumLineSpacing = 9;
    flowlayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.bounces = NO;
    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerClass:[TBTemplateResourceCollectionViewCell class] forCellWithReuseIdentifier:TBTemplateResourceCollectionViewCellID];
    self.collectionView.collectionViewLayout = flowlayout;
    self.defaultName = @"task-shangchuan-small";
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
        NSInteger tatol = self.imageArray.count+self.defaultRow;
        NSInteger validationRow = self.maxRow - tatol;
        return validationRow <0?self.maxRow:tatol;
    }
}
- (TBTemplateResourceCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TBTemplateResourceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TBTemplateResourceCollectionViewCellID forIndexPath:indexPath];
    
    if (indexPath.row < self.imageArray.count)
    {
        [cell valueCellImage:self.imageArray[indexPath.row] showDelete:YES index:indexPath.row];
    }
    else
    {
        NSString *imageName = self.imageArray.count == 0?self.defaultName:@"task-shangchuan-small";
        [cell valueCellImage:[UIImage imageNamed:imageName] showDelete:NO index:indexPath.row];
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
    TBWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [weakSelf.imageArray addObjectsFromArray:images];
        [weakSelf updataCollectionViewHeight];
        [weakSelf.collectionView reloadData];
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
    
    self.collectionViewHeight.constant = constant;
    
    if (self.updataTableView)
    {
        self.updataTableView();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
