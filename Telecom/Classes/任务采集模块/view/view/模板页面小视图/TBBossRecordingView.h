//
//  TBBossRecordingView.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/17.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TBBossRecordingViewDelegate <NSObject>

/**
 录制完后

 @param voiceData 音频文件
 */
- (void)recorderOverData:(NSData *)voiceData;

/**
 删除完成
 */
- (void)deleteTheAudio;

@end
/**
 老板录音工具
 */
@interface TBBossRecordingView : UIView

@property (nonatomic, assign) id<TBBossRecordingViewDelegate>delegate;

- (void)assignmentVoiceData:(id)data;

//停止播放销毁
- (void)stopAudio;
@end
