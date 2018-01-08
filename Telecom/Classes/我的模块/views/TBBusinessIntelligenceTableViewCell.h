//
//  TBBusinessIntelligenceTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/25.
//  Copyright © 2017年 王小腊. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HXTagsView.h"

@class TBBasicServicetypeServicelables;

extern NSString *const TBBusinessIntelligenceTableViewCellID;

@interface TBBusinessIntelligenceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet HXTagsView *tagsView;

@property (copy, nonatomic) void(^updataTableView)(void);

- (void)updataCellLabels:(NSArray<TBBasicServicetypeServicelables *> *)list selectKey:(NSString *)key;

@end
