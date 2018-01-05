//
//  TBUpdateTooltipView.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/24.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBUpdateTooltipView : UIView
/**
 弹出提示框

 @param prompt 提示信息
 */
- (instancetype)initShowPrompt:(NSString *)prompt;

-(void)show;
@end
