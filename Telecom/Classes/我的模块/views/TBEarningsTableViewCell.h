//
//  TBEarningsTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2017/8/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//

extern NSString *const TBEarningsTableViewCellID;

#import <UIKit/UIKit.h>
@class TBEarningsDetails;

@interface TBEarningsTableViewCell : UITableViewCell

- (void)updataCellData:(TBEarningsDetails *)list;

@end
