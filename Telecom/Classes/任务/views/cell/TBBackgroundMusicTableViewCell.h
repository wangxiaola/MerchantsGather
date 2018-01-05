//
//  TBBackgroundMusicTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/14.
//  Copyright © 2016年 王小腊. All rights reserved.
//
extern NSString *const TBBackgroundMusicTableViewCellID;

#import <UIKit/UIKit.h>
#import "TBTemplateBackgroundData.h"

@interface TBBackgroundMusicTableViewCell : UITableViewCell

@property (nonatomic, strong) TBTemplateBackgroundData *data;

@end
