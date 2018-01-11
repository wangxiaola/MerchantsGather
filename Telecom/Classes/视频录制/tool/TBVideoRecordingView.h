//
//  TBVideoRecordingView.h
//  Telecom
//
//  Created by 王小腊 on 2018/1/10.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^RecordSuccess)(NSString *recordPath);//录音成功的回调block

/**
 视频录音视图
 */
@interface TBVideoRecordingView : UIView

@property (nonatomic, copy) RecordSuccess recordSuccess;


/**
  弹出录音视图

 @param time 时间
 @param success 成功的返回
 */
- (void)showRecordingTime:(double)time success:(RecordSuccess)success;
@end
