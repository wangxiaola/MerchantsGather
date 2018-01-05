//
//  TBEarningsHeaderFooterView.h
//  Telecom
//
//  Created by 王小腊 on 2017/8/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//

extern NSString *const TBEarningsHeaderViewID;

#import <UIKit/UIKit.h>
@class TBEarningsRoot;

@interface TBEarningsHeaderView : UITableViewHeaderFooterView

- (void)updataHeaderViewData:(TBEarningsRoot *)root;


@end
