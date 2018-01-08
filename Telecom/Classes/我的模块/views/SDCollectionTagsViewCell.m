//
//  SDCollectionTagsViewCell.m
//  SDTagsView
//
//  Created by slowdony on 2017/9/9.
//  Copyright © 2017年 slowdony. All rights reserved.
//

#import "SDCollectionTagsViewCell.h"
#import "TagsModel.h"
@implementation SDCollectionTagsViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    
    UILabel *title = [[UILabel alloc] init];
    
    title.font = [UIFont systemFontOfSize:14];
    title.layer.cornerRadius = 10.0;
    title.textAlignment = NSTextAlignmentCenter;
    title.layer.masksToBounds = YES;
    self.title = title;
    [self.contentView addSubview:title];
}

/**
 cell赋值
 
 @param model 模型
 @param row 第几个
 */
-(void)setValueWithModel:(TagsModel *)model indexRow:(NSInteger)row
{
    self.title.text = model.userName;
    self.title.frame = CGRectMake(0, 0, ([ZKUtil widthForLabel:model.userName fontSize:14] + 20), 24);
    self.title.textColor = model.type == 1?[UIColor whiteColor]:[UIColor whiteColor]
    ;
    self.title.backgroundColor = model.type == 1?[UIColor orangeColor]:NAVIGATION_COLOR;
}

@end
