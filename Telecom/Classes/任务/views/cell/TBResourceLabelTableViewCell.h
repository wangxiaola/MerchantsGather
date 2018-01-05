//
//  TBResourceLabelTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/18.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXTagsView.h"
#import "TBBasicDataTool.h"
/**
 图片标签选择
 */
@interface TBResourceLabelTableViewCell : UITableViewCell

@property (nonatomic, strong) HXTagsView *tagsView;


/**
 标签展示

 @param tags 选中的
 @param array 内容标签
 */
- (void)updataTags:(NSArray *)tags allArray:(NSArray <TBDescriDicData *>*)array;
/**
 更新TableView
 */
@property (nonatomic, copy) void(^updataTableView)(void);

@end
