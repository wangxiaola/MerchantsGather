//
//  ProcessBar.h
//  SBVideoCaptureDemo
//
//  Created by Pandara on 14-8-13.
//  Copyright (c) 2014年 Pandara. All rights reserved.
//


#import <UIKit/UIKit.h>
//#import "SBCaptureDefine.h"

@protocol ProgressBarDelegate <NSObject>
@optional


/**
 重新录制

 @param segment 第几段
 */
- (void)reRecordingInsertTheSegment:(NSInteger)segment;

/**
 导入相册视频

 @param segment 第几段
 */
- (void)replacePhotoVideoInsertTheSegment:(NSInteger)segment;

/**
 删除第几段

 @param segment 第几段
 */
- (void)deleteTheSegment:(NSInteger)segment;

/**
 选中

 @param index 第几个
 */
- (void)progressViewSelected:(NSInteger)index;
@end;

typedef enum {
    ProgressBarProgressStyleNormal,
    ProgressBarProgressStyleDelete,
    ProgressBarProgressStyleSelect
} ProgressBarProgressStyle;


@interface ProgressBar : UIView

@property (strong, nonatomic) NSMutableArray *progressViewArray;

+ (ProgressBar *)getInstance;

- (void)setLastProgressToStyle:(ProgressBarProgressStyle)style;
- (void)setLastProgressToWidth:(CGFloat)width;
- (void)setCurrentProgressToWidth:(CGFloat)width;
- (void)setCurrentProgressToStyle:(ProgressBarProgressStyle)style andIndex:(NSInteger)idx;
- (void)refreshCurrentView:(NSInteger)idx andWidth:(CGFloat)width;

- (void)deleteLastProgress;
- (void)deleteTheSegmentProgress:(NSInteger)index;
- (void)addProgressView;


/**
 更新节点数量

 @param number 数量
 */
- (void)updateViewNodesNumber:(NSInteger)number;

- (void)removeAllSubViews;
- (void)progressViewResetAll;
@property (nonatomic, weak) id<ProgressBarDelegate>delegate;

@end
