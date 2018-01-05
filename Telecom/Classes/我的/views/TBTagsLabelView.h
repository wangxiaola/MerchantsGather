//
//  TBTagsLabelView.h
//  Telecom
//
//  Created by 王小腊 on 2017/11/30.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagsModel.h"

@interface TBTagsLabelView : UIView
// 数据更新
- (void)setViewWithTagsArr:(NSArray<TagsModel *>*)tagsArr;
//cell点击
@property (nonatomic, copy) void (^cellClick)(NSInteger index);

@end


