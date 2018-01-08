//
//  TBWaitingTaskDataTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/20.
//  Copyright © 2017年 王小腊. All rights reserved.
//

extern NSString *const TBWaitingTaskDataTableViewCellID;

#import <UIKit/UIKit.h>
@class TBMakingListMode,TBPackageData;

@interface TBWaitingTaskDataTableViewCell : UITableViewCell

- (void)updataCell:(TBMakingListMode *)list packageArray:(NSArray <TBPackageData *>*)types;  


@end
