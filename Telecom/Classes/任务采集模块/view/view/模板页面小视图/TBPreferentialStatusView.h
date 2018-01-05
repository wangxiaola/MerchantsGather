//
//  TBPreferentialStatusView.h
//  Telecom
//
//  Created by 王小腊 on 2017/9/1.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 优惠确认发布按钮
 */
@interface TBPreferentialStatusView : UIView

- (instancetype)initPromptString:(NSString *)prompt;
/**
 点击回调
 */
@property (nonatomic, copy) void (^preferentialStatus)(BOOL state);

- (void)setSelectButtonState:(BOOL)state;

@end
