//
//  TBRecordingCorrugatedView.h
//  Telecom
//
//  Created by 王小腊 on 2018/1/11.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 录音波纹
 */
@interface TBRecordingCorrugatedView : UIView

/**
 录音状态跟新

 @param powerForChannel [recorder averagePowerForChannel:0]
 */
- (void)updateMeters:(CGFloat)powerForChannel;

@end
