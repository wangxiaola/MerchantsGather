//
//  TBIdentityInformationTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2017/5/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

extern NSString *const TBIdentityInformationTableViewCellID;

static NSString *yg_name = @"name";
static NSString *yg_positive = @"img1";//正面
static NSString *yg_reverse = @"img2";//反面

#import <UIKit/UIKit.h>

@protocol IdentityInformationTableViewCelldDelegate <NSObject>
@optional
/**
 修改后的字典

 @param dictionary 字典
 @param row 第几个
 */
- (void)modifiedData:(NSDictionary *)dictionary indexRow:(NSInteger)row;

/**
 删除员工信息

 @param row 第几个
 */
- (void)deleteEmployeeInformationIndex:(NSInteger)row;

@end

@interface TBIdentityInformationTableViewCell : UITableViewCell

/**
 第几个单元
 */
@property (nonatomic, assign) NSInteger indexRow;

@property (nonatomic, assign)id<IdentityInformationTableViewCelldDelegate>delegate;

- (void)assignmentPhotos:(NSDictionary *)dictionary;

@end
