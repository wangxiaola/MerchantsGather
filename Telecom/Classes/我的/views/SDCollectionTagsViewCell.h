//
//  SDCollectionTagsViewCell.h
//  SDTagsView
//
//  Created by slowdony on 2017/9/9.
//  Copyright © 2017年 slowdony. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TagsModel;
@interface SDCollectionTagsViewCell : UICollectionViewCell
//标签
@property (nonatomic,strong)UILabel *title;

/**
 cell赋值

 @param model 模型
 @param row 第几个
 */
-(void)setValueWithModel:(TagsModel *)model indexRow:(NSInteger)row;
@end
