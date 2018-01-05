//
//  TBAppearanceTemplateTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2017/11/27.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBAppearanceTemplateTableViewCell : UITableViewCell
/**
 模板选择更新
 */
@property (nonatomic, copy) void(^templateChooseUpdate)(NSInteger templateIndex);

/**
 更新图片

 @param index 第几个模板
 */
- (void)updateTemplateImageIndex:(NSInteger)index;
@end
