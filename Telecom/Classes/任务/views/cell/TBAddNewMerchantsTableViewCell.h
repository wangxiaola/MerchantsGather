//
//  TBAddNewMerchantsTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/9.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TBAddMerchantsMode;
extern NSString *const reuseIdentifier;
@interface TBAddNewMerchantsTableViewCell : UITableViewCell

@property (nonatomic, strong) TBAddMerchantsMode *mode;

@end
