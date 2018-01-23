//
//  TBMusicPageCell.h
//  Telecom
//
//  Created by 王小腊 on 2018/1/22.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBMusicPageCell : UIView

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, assign) BOOL isShoose;

/**
 修改边框
 */
- (void)modifyViewBezel;

/**
 删除边框
 */
- (void)deleteViewBezel;
@end
