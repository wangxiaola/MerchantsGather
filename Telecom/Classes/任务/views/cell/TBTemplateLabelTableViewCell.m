//
//  TBTemplateLabelTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/6.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBTemplateLabelTableViewCell.h"
#import "TBBasicDataTool.h"
#import "HXTagAttribute.h"

@implementation TBTemplateLabelTableViewCell
{
    
    NSMutableArray *dataArray;
    
    NSMutableArray *idArray;
    
    NSArray *_titisArray;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    dataArray = [NSMutableArray arrayWithCapacity:0];
    idArray = [NSMutableArray arrayWithCapacity:0];
    self.clipsToBounds = YES;
    
    self.labelViewHeghit.priority = UILayoutPriorityDefaultLow;
    self.tagsView = [[HXTagsView alloc] init];
    [self.labelBackView addSubview:_tagsView];
    
    _tagsView.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _tagsView.backgroundColor = [UIColor whiteColor];
    _tagsView.tagAttribute.cornerRadius = 20;
    _tagsView.tagAttribute.selectedBackgroundColor = RGB(250, 131, 8);
    _tagsView.tagAttribute.selectedLabelBackgroundColor = [UIColor whiteColor];
    _tagsView.tagAttribute.normalBackgroundColor = [UIColor whiteColor];
    _tagsView.tagAttribute.textColor = [UIColor grayColor];
    _tagsView.tagAttribute.titleSize = 14;
    _tagsView.tagAttribute.tagSpace = 20;
    _tagsView.selectMax = 3;
     
    [_tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.top.mas_equalTo(self.labelBackView);
        
    }];
    [self.tagsView setSelectMaxNumber:^{
        
        hudShowInfo(@"最多只能选择3个标签");
    }];
    
}
- (void)updataTags:(NSArray *)tags TitisArray:(NSArray *)titisArray;
{    
    [dataArray removeAllObjects];
    [idArray removeAllObjects];
    _titisArray = titisArray;
    [_tagsView.originalTags removeAllObjects];
    
    [titisArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[TBBasicDataLabels class]])
        {    _tagsView.isMultiSelect = YES;
            self.tagLabel.text = @"标签";
            TBBasicDataLabels *ls = obj;
            [dataArray addObject:ls.name];
            [idArray addObject:[NSString stringWithFormat:@"%ld",(long)ls.ID]];
        }
        else if ([obj isKindOfClass:[TBBasicDataLevels class]])
        {    _tagsView.isMultiSelect = NO;
            self.tagLabel.text = @"等级";
            TBBasicDataLevels *level = obj;
            [dataArray addObject:level.name];
            [idArray addObject:[NSString stringWithFormat:@"%ld",(long)level.ID]];
        }
        else if ([obj isKindOfClass:[TBBasicDataSuitables class]])
        {    _tagsView.isMultiSelect = YES;
            self.tagLabel.text = @"合适";
            TBBasicDataSuitables *su = obj;
            [dataArray addObject:su.name];
            [idArray addObject:[NSString stringWithFormat:@"%ld",(long)su.ID]];
        }
        else if ([obj isKindOfClass:[TBBasicDataRange class]])
        {
            _tagsView.isMultiSelect = YES;
            self.tagLabel.text = @"经营范围";
            TBBasicDataRange *range = obj;
            [dataArray addObject:range.name];
            [idArray addObject:[NSString stringWithFormat:@"%ld",(long)range.ID]];
            
        }

    }];
    
    _tagsView.tags = dataArray;
    _tagsView.originalData = idArray;
    [_tagsView.originalTags addObjectsFromArray:tags];
    
    self.labelViewHeghit.constant =  [HXTagsView getHeightWithTags:dataArray layout:self.tagsView.layout tagAttribute:nil width:_SCREEN_WIDTH];
    
    [self updataTags:tags];
    
}
- (void)updataTags:(NSArray *)tags;
{
    NSMutableArray  *keyArray = [NSMutableArray array];
    
    [tags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *str = obj;
        NSInteger tg = str.integerValue;
        
        [_titisArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            if ([obj isKindOfClass:[TBBasicDataLabels class]])
            {
                TBBasicDataLabels *la = obj;
                if (la.ID == tg ) {
                    
                    [keyArray addObject:la.name];
                }
            }
            else if ([obj isKindOfClass:[TBBasicDataSuitables class]])
            {
                TBBasicDataSuitables *su = obj;
                if (su.ID == tg ) {
                    
                    [keyArray addObject:su.name];
                }
            }
            else if ([obj isKindOfClass:[TBBasicDataLevels class]])
            {
                TBBasicDataLevels *su = obj;
                if (su.ID == tg ) {
                    
                    [keyArray addObject:su.name];
                }
            }
            else if ([obj isKindOfClass:[TBBasicDataRange class]])
            {
                TBBasicDataRange *su = obj;
                if (su.ID == tg ) {
                    
                    [keyArray addObject:su.name];
                }
            }

        }];
        
        
    }];
    [self.tagsView.selectedTags addObjectsFromArray:keyArray];
    [self.tagsView reloadData];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
