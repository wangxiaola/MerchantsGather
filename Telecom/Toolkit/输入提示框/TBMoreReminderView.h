//
//  TBMoreReminderView.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/24.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^determine)(void);
typedef void (^cancel)(void);

@interface TBMoreReminderView : UIView

@property (nonatomic) determine determine;
@property (nonatomic) cancel cancel;
/**
 弹出提示框
 
 @param prompt 提示信息
 */
- (instancetype)initShowPrompt:(NSString *)prompt;

-(void)showHandler:(determine)change;

- (void)cancelClick:(cancel)cancel;

@end
