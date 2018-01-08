//
//  TBBusinessServiceTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/25.
//  Copyright © 2017年 王小腊. All rights reserved.
//

extern NSString *const TBBusinessServiceTableViewCellID;

#import <UIKit/UIKit.h>
#import "HXTagsView.h"

@class TBBasicServicetypeRange;

@interface TBBusinessServiceTableViewCell : UITableViewCell

@property (copy, nonatomic) void(^updataTableView)(void);

@property (weak, nonatomic) IBOutlet HXTagsView *tagsView;

- (void)updataCellLabels:(NSArray <TBBasicServicetypeRange*> *)list selectKey:(NSString *)key;
@end
