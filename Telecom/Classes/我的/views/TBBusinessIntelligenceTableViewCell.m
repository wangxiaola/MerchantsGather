//
//  TBBusinessIntelligenceTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/25.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBusinessIntelligenceTableViewCell.h"
#import "TBBasicServicetypeMode.h"
#import "TBBarItemView.h"
#import "HXTagAttribute.h"

NSString *const TBBusinessIntelligenceTableViewCellID = @"TBBusinessIntelligenceTableViewCellID";

@interface TBBusinessIntelligenceTableViewCell()

@property (weak, nonatomic) IBOutlet TBBarItemView *barItemView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsViewHeight;

@property (nonatomic, strong) NSMutableArray *labelNameArray;
@property (nonatomic, strong) NSMutableArray *barTitleArray;
@property (nonatomic, strong) NSMutableArray *labelIdArray;

@end
@implementation TBBusinessIntelligenceTableViewCell
- (NSMutableArray *)labelNameArray
{
    if (!_labelNameArray)
    {
        _labelNameArray = [NSMutableArray array];
    }
    return _labelNameArray;
}
- (NSMutableArray *)barTitleArray
{
    if (!_barTitleArray)
    {
        _barTitleArray = [NSMutableArray array];
    }
    return _barTitleArray;
}

- (NSMutableArray *)labelIdArray
{
    if (!_labelIdArray)
    {
        _labelIdArray = [NSMutableArray array];
    }
    return _labelIdArray;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.tagsView.backgroundColor = [UIColor whiteColor];
    self.tagsView.tagAttribute.cornerRadius = 20;
    self.tagsView.tagAttribute.selectedBackgroundColor = RGB(250, 131, 8);
    self.tagsView.tagAttribute.selectedLabelBackgroundColor = [UIColor whiteColor];
    self.tagsView.tagAttribute.normalBackgroundColor = [UIColor whiteColor];
    self.tagsView.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.tagsView.tagAttribute.textColor = [UIColor grayColor];
    self.tagsView.tagAttribute.titleSize = 14;
    self.tagsView.tagAttribute.tagSpace = 20;
    
    TBWeakSelf
    [self.barItemView setBarSelect:^(NSInteger index) {
        
        [weakSelf updataTagViewIndex:index selectIdArray:nil selectNameArray:nil];
    }];
    
}

- (void)updataCellLabels:(NSArray<TBBasicServicetypeServicelables *> *)list selectKey:(NSString *)key;
{
    __block NSInteger selctRow = 0;
    [self.barTitleArray removeAllObjects];
    [self.labelNameArray removeAllObjects];
    [self.labelIdArray removeAllObjects];
    if (key.length == 0||key == nil)
    {
        key = @"";
    }
   __block NSString *keyName = @"";
    [list enumerateObjectsUsingBlock:^(TBBasicServicetypeServicelables * _Nonnull obj, NSUInteger idx_0, BOOL * _Nonnull stop) {
        [self.barTitleArray addObject:obj.name];
        
        NSMutableArray *nameArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *idArray = [NSMutableArray arrayWithCapacity:0];
        
        [nameArray removeAllObjects];
        [idArray removeAllObjects];
        
        [obj.labels enumerateObjectsUsingBlock:^(TBBasicServicetypeLabels * _Nonnull objLabel, NSUInteger idx_1, BOOL * _Nonnull stop) {
            
            [nameArray addObject:objLabel.name];
            [idArray addObject:[NSString stringWithFormat:@"%ld",(long)objLabel.ID]];
            if (key)
            {
                
                if (objLabel.ID == key.integerValue)
                {
                    selctRow = idx_0;
                    keyName = objLabel.name;
                }
            }
       
        }];

        [self.labelNameArray addObject:nameArray];
        [self.labelIdArray addObject:idArray];
    }];
    
    self.barItemView.titelArray = self.barTitleArray;
    [self.barItemView selectIndex:selctRow];
    
    if (self.labelNameArray.count >0)
    {
        [self updataTagViewIndex:selctRow selectIdArray:@[key] selectNameArray:@[keyName]];
    }

}
- (void)updataTagViewIndex:(NSInteger)row selectIdArray:(NSArray *)idaray selectNameArray:(NSArray *)nameArray;
{
    if (self.labelNameArray.count == 0)
    {
        return;
    }
    NSArray *dataArray = [self.labelNameArray objectAtIndex:row];
    self.tagsView.tags = dataArray;
    
    [self.tagsView.selectedTags removeAllObjects];
    [self.tagsView.originalTags removeAllObjects];
    if (nameArray.count>0)
    {
        [self.tagsView.selectedTags addObjectsFromArray:nameArray];
    }
    if (idaray)
    {
        [self.tagsView.originalTags addObjectsFromArray:idaray];
    }
    self.tagsView.originalData = [self.labelIdArray objectAtIndex:row];
    
    CGFloat height = [HXTagsView  getHeightWithTags:dataArray layout:self.tagsView.layout tagAttribute:self.tagsView.tagAttribute width:_SCREEN_WIDTH];
    [self.tagsView reloadData];
    self.tagsViewHeight.constant = height;
    
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
