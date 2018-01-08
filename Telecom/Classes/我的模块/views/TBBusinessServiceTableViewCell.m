//
//  TBBusinessServiceTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/25.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBusinessServiceTableViewCell.h"
#import "TBBasicServicetypeMode.h"
#import "HXTagAttribute.h"

NSString *const TBBusinessServiceTableViewCellID = @"TBBusinessServiceTableViewCellID";

@interface TBBusinessServiceTableViewCell()


@property (nonatomic, strong) NSMutableArray *labelNameArray;
@property (nonatomic, strong) NSMutableArray *labelIDArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsViewHeight;

@end
@implementation TBBusinessServiceTableViewCell
- (NSMutableArray *)labelIDArray
{
    if (!_labelIDArray) {
        _labelIDArray = [NSMutableArray array];
    }
    return _labelIDArray;
}
- (NSMutableArray *)labelNameArray
{
    if (!_labelNameArray)
    {
        _labelNameArray = [NSMutableArray array];
    }
    return _labelNameArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tagsView.backgroundColor = [UIColor whiteColor];
    self.tagsView.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.tagsView.tagAttribute.cornerRadius = 20;
    self.tagsView.tagAttribute.selectedBackgroundColor = RGB(250, 131, 8);
    self.tagsView.tagAttribute.selectedLabelBackgroundColor = [UIColor whiteColor];
    self.tagsView.tagAttribute.normalBackgroundColor = [UIColor whiteColor];
    self.tagsView.tagAttribute.textColor = [UIColor grayColor];
    self.tagsView.tagAttribute.titleSize = 14;
    self.tagsView.tagAttribute.tagSpace = 20;

}
- (void)updataCellLabels:(NSArray <TBBasicServicetypeRange*> *)list selectKey:(NSString *)key;
{
    [self.labelNameArray removeAllObjects];
    [self.labelIDArray removeAllObjects];
    [self.tagsView.selectedTags removeAllObjects];
    [self.tagsView.originalTags removeAllObjects];
    
    if (key.length == 0||key == nil)
    {
        key = @"";
    }
   __block NSString *keyName = @"";
    [list enumerateObjectsUsingBlock:^(TBBasicServicetypeRange * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.labelNameArray addObject:obj.name];
        [self.labelIDArray addObject:[NSString stringWithFormat:@"%ld",(long)obj.ID]];
        if (key)
        {
            if (obj.ID == key.integerValue)
            {
                keyName = obj.name;
            }
        }
    }];
    
    if (key.length>0&&keyName.length>0)
    {
        self.tagsView.selectedTags = @[keyName].mutableCopy;
        self.tagsView.originalTags = @[key].mutableCopy;
    }
    self.tagsView.tags = self.labelNameArray;
    self.tagsView.originalData = self.labelIDArray;
    CGFloat height = [HXTagsView  getHeightWithTags:self.labelNameArray layout:self.tagsView.layout tagAttribute:self.tagsView.tagAttribute width:_SCREEN_WIDTH];
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
