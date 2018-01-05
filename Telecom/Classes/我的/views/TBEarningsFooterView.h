//
//  TBEarningsFooterView.h
//  Telecom
//
//  Created by 王小腊 on 2017/8/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//

extern NSString *const TBEarningsFooterViewID;
#import <UIKit/UIKit.h>

@interface TBEarningsFooterView : UITableViewHeaderFooterView

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, copy) void (^selectFooterView)(NSInteger section);
@end
