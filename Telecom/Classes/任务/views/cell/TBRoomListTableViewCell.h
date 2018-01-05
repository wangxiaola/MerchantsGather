//
//  TBRoomListTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2017/11/28.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const TBRoomListTableViewCellID;

@interface TBRoomListTableViewCell : UITableViewCell

/**
 更新cell值

 @param data 数据
 */
- (void)updataCellTextData:(NSDictionary *)data;

@end
