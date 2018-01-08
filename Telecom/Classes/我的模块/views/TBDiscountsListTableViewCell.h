//
//  TBDiscountsListTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2017/4/27.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBDiscountsMode.h"

@protocol TBDiscountsTableViewCellDelegate <NSObject>
@optional

/**
 查看详情
 
 @param list 数据
 */
- (void)checkTheDetailsData:(TBDiscountsMode *)list;
/**
 领取记录
 
 @param list 数据
 */
- (void)getTheRecordData:(TBDiscountsMode *)list;
/**
 编辑修改
 
 @param list 数据
 */
- (void)editData:(TBDiscountsMode *)list;
/**
 删除
 
 @param list 数据
 */
- (void)deleteData:(TBDiscountsMode *)list;

@end


@interface TBDiscountsListTableViewCell : UITableViewCell
{
    
    struct{
        
        unsigned int checkTheDetailsData   :1;
        unsigned int getTheRecordData      :1;
        unsigned int editData              :1;
        unsigned int deleteData            :1;
    }_delegateFlags;
}

@property (nonatomic, assign) id<TBDiscountsTableViewCellDelegate>deleaget;


/**
 更新内容
 
 @param data 数据
 @param height 图片高度
 @param type yes是打折卡
 */
- (void)updataDiscountsCellInfo:(TBDiscountsMode *)data backImageHeight:(CGFloat)height cellType:(BOOL)type;

@end
