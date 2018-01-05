//
//  TBNoticePromptBoxView.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//

typedef void(^SearchKey)(NSString *key);

#import <UIKit/UIKit.h>


/**
 通知提示
 */
@interface TBNoticePromptBoxView : UIView

@property (nonatomic, copy) SearchKey searchKey;

/**
 弹出提示框

 @param messge 提示消息
 */
- (instancetype)initShowPromptString:(NSString *)messge;


/**
 弹出
 */
- (void)showSearchKey:(SearchKey)key;

@end
