//
//  TBReleasePreviewInfoTableViewCell.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBReleasePreviewInfoTableViewCell.h"

@implementation TBReleasePreviewInfoTableViewCell
{
    UIView *_backView;
    NSMutableArray *_labelArray;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _backView = [[UIView alloc] init];
        _backView .backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_backView];
        _labelArray = [NSMutableArray array];
        _backView.clipsToBounds = YES;
        TBWeakSelf
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(weakSelf).offset(6);
            make.right.bottom.equalTo(weakSelf).offset(-6);
            make.height.mas_greaterThanOrEqualTo(0).priorityLow();
        }];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = [UIColor whiteColor];
}

/**
 更新显示
 
 @param array 数据
 */
- (void)updataArray:(NSArray *)array;
{
  [_labelArray removeAllObjects];
  [_backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i<array.count; i++)
    {
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = [NSString stringWithFormat:@"%d、%@",i+1,array[i]];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textColor = [UIColor grayColor];
        nameLabel.numberOfLines = 0;
        [_backView addSubview:nameLabel];
        [_labelArray addObject:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_backView.mas_left).offset(4);
            make.right.equalTo(_backView.mas_right).offset(-4);
            if (i == 0)
            {
                make.top.equalTo(_backView);
            }
            if (array.count>i&&i>0)
            {
                UILabel *label = _labelArray[i-1];
                make.top.equalTo(label.mas_bottom).offset(4);
            }
            
        }];
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
