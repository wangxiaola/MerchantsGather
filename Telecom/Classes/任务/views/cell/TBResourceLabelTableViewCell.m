//
//  TBResourceLabelTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/18.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBResourceLabelTableViewCell.h"
#import "HXTagAttribute.h"
#import "UIButton+ImageTitleStyle.h"

@interface TBResourceLabelTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelViewHeghit;
@property (weak, nonatomic) IBOutlet UIView *labelBackView;
@property (assign, nonatomic) NSInteger maxRow;
@property (strong, nonatomic) NSMutableArray *labelArray;
@property (strong, nonatomic) NSMutableArray *keyArray;
@property (strong, nonatomic) NSMutableArray *labelIDArray;
@end
@implementation TBResourceLabelTableViewCell
- (NSMutableArray *)keyArray
{
    if (!_keyArray)
    {
        _keyArray = [NSMutableArray array];
    }
    return _keyArray;
}
- (NSMutableArray *)labelIDArray
{
    if (!_labelIDArray)
    {
        _labelIDArray = [NSMutableArray array];
    }
    return _labelIDArray;
}
- (NSMutableArray *)labelArray
{
    if (!_labelArray)
    {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clipsToBounds = YES;
    self.labelViewHeghit.priority = UILayoutPriorityDefaultLow;
    self.tagsView = [[HXTagsView alloc] init];
    [self.labelBackView addSubview:_tagsView];
    self.tagsView.selectMax = 3;
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.sendButton setBackgroundColor:[UIColor whiteColor]];
    self.sendButton.hidden = YES;
    
    _tagsView.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _tagsView.backgroundColor = [UIColor whiteColor];
    _tagsView.tagAttribute.cornerRadius = 20;
    _tagsView.tagAttribute.selectedBackgroundColor = RGB(250, 131, 8);
    _tagsView.tagAttribute.selectedLabelBackgroundColor = [UIColor whiteColor];
    _tagsView.tagAttribute.normalBackgroundColor = [UIColor whiteColor];
    _tagsView.tagAttribute.textColor = [UIColor grayColor];
    _tagsView.tagAttribute.titleSize = 14;
    _tagsView.tagAttribute.tagSpace = 20;
    _tagsView.isMultiSelect = YES;
    [_tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.top.mas_equalTo(self.labelBackView);
        
    }];
    
    [self.tagsView setSelectMaxNumber:^{
        
        hudShowInfo(@"最多只能选择3个标签");
    }];
    self.labelViewHeghit.constant = 0.0f;
    
}
/**
 标签展示
 
 @param tags 选中的
 @param array 内容标签
 */
- (void)updataTags:(NSArray *)tags allArray:(NSArray <TBDescriDicData *>*)array;
{
    [self.labelArray removeAllObjects];
    [self.labelIDArray removeAllObjects];
    [self.keyArray removeAllObjects];
    
    [array enumerateObjectsUsingBlock:^(TBDescriDicData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self.labelArray addObject:obj.name];
        [self.labelIDArray addObject:[NSString stringWithFormat:@"%ld",(long)obj.ID]];
        
        [tags enumerateObjectsUsingBlock:^(id  _Nonnull objTg, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *str = objTg;
            NSInteger tg = str.integerValue;
            
            if (tg == obj.ID)
            {
                [self.keyArray addObject:obj.name];
            }
        }];
        
    }];
    
    _tagsView.tags = self.labelArray.copy;
    _tagsView.originalData = self.labelIDArray.copy;
    [_tagsView.originalTags removeAllObjects];
    [_tagsView.originalTags addObjectsFromArray:tags];
    [self.tagsView.selectedTags removeAllObjects];
    [self.tagsView.selectedTags addObjectsFromArray:self.keyArray];
    [self.tagsView reloadData];
    
    self.maxRow = self.labelArray.count>9?9:self.labelArray.count;
    [self changeButtonStyle];
    
}

- (IBAction)sendClick:(UIButton *)sender
{
    self.maxRow = self.maxRow == 9?self.labelArray.count:9;
    [self changeButtonStyle];
    if (self.updataTableView)
    {
        self.updataTableView();
    }
}
- (void)changeButtonStyle;
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        if (self.maxRow >9)
        {
            _tagsView.tags = self.labelArray;
            [self.sendButton setTitle:@"收起" forState:UIControlStateNormal];
            [self.sendButton setImage:[UIImage imageNamed:@"task-top"] forState:UIControlStateNormal];
        }
        else if (self.labelArray.count>0)
        {
            
            _tagsView.tags = [self.labelArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.maxRow)]];
            [self.sendButton setTitle:@"更多" forState:UIControlStateNormal];
            [self.sendButton setImage:[UIImage imageNamed:@"task-botton"] forState:UIControlStateNormal];
        }
        
        self.labelViewHeghit.constant =  [HXTagsView getHeightWithTags:_tagsView.tags layout:self.tagsView.layout tagAttribute:nil width:_SCREEN_WIDTH];
        
        self.sendButton.hidden = !(self.labelArray.count>9);
        [_tagsView reloadData];
        [self.sendButton setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:4];
    });
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
