//
//  TBScrecordTool.h
//  Telecom
//
//  Created by 王小腊 on 2018/1/25.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <AVFoundation/AVFoundation.h>

@interface TBScrecordTool : NSObject


//////////////////
// GENERAL SETTINGS
////

/**
在创建这个记录会话时生成一个惟一的标识符。
 */
@property (readonly, nonatomic) NSString *__nonnull identifier;

/**
当这个记录会话创建日期。
 */
@property (readonly, nonatomic) NSDate *__nonnull date;

/**
的目录记录片段将被保存。可以是SCRecordSessionTemporaryDirectory或arbritary目录。默认是SCRecordSessionTemporaryDirectory。
 */
@property (copy, nonatomic) NSString *__nonnull segmentsDirectory;

/**
用于AVAssetWriter输出文件类型。如果是null,AVFileTypeMPEG4将用于一个视频文件,AVFileTypeAppleM4A音频文件
 */
@property (copy, nonatomic) NSString *__nullable fileType;

/**
每个记录的扩展部分。如果空,SCRecordSession会算出一个根据文件类型。
 */
@property (copy, nonatomic) NSString *__nullable fileExtension;

/**
输出基于url标识符,recordSegmentsDirectory fileExtension
 */
@property (readonly, nonatomic) NSURL *__nonnull outputUrl;

/**
包含每个记录SCRecordSessionSegment段。
 */
@property (readonly, nonatomic) NSArray *__nonnull segments;

/**
整个recordSession包括当前记录的持续时间段和前面添加记录。
 */
//@property (readonly, nonatomic) CMTime duration;

/**
段的时间记录记录。
 */
//@property (readonly, atomic) CMTime segmentsDuration;

/**
当前记录的持续时间。
 */
//@property (readonly, atomic) CMTime currentSegmentDuration;

/**
真正的如果recordSegment开始
 */
@property (readonly, nonatomic) BOOL recordSegmentBegan;

/**
管理这个SCRecordSession的记录器
 */
//@property (readonly, nonatomic, weak) SCRecorder *__nullable recorder;

//////////////////
// PUBLIC METHODS
////

//- (nonnull instancetype)init;

//- (nonnull instancetype)initWithDictionaryRepresentation:(nonnull NSDictionary *)dictionaryRepresentation;

/**
 Create a SCRecordSession
 */
//+ (nonnull instancetype)recordSession;

/**
创建一个SCRecordSession基于字典的表示
 */
//+ (nonnull instancetype)recordSession:(nonnull NSDictionary *)dictionaryRepresentation;

/**
SCRecordSession调用任何方法是线程安全的。然而,如果里面的记录会话SCRecorder实例,它的状态两个调用之间可能会改变你。做任何修改在这一块将确保你是唯一一个在这SCRecordSession访问任何修改。
 */
//- (void)dispatchSyncOnSessionQueue:(void(^__nonnull)())block;

//////////////////////
/////// SEGMENTS
////

/**
删除记录。不会删除相关文件。
 */
//- (void)removeSegment:(SCRecordSessionSegment *__nonnull)segment;

/**
删除记录段在给定的索引。
 */
//- (void)removeSegmentAtIndex:(NSInteger)segmentIndex deleteFile:(BOOL)deleteFile;

/**
添加一个记录。
 */
//- (void)addSegment:(SCRecordSessionSegment *__nonnull)segment;

/**
插入一个记录。
 */
//- (void)insertSegment:(SCRecordSessionSegment *__nonnull)segment atIndex:(NSInteger)segmentIndex;

/**
删除所有的记录片段及其相关文件。
 */
//- (void)removeAllSegments;

/**
删除所有的记录片段及其相关文件如果deleteFiles是真的。
 */
//- (void)removeAllSegments:(BOOL)deleteFiles;

/**
安全删除最后一段。没有如果没有段记录。
 */
//- (void)removeLastSegment;

/**
取消会议。结束当前recordSegment(如果有的话)和调用removeAllSegments如果你不想一段自动添加调用该方法时,你应该删除SCRecordSession SCRecorder
 */
//- (void)cancelSession:(void(^ __nullable)())completionHandler;

/**
使用给定的AVAssetExportSessionPreset合并记录记录部分。返回AVAssetExportSession用于出口。返回nil和同步调用完成处理器块如果一个错误发生在准备出口的会话。
 */
//- (AVAssetExportSession *__nullable)mergeSegmentsUsingPreset:(NSString *__nonnull)exportSessionPreset completionHandler:(void(^__nonnull)(NSURL *__nullable outputUrl, NSError *__nullable error))completionHandler;

/**
返回一个资产代表所有片段的记录从这个记录会话。这可以随时调用。
 */
//- (AVAsset *__nonnull)assetRepresentingSegments;

/**
返回一个球员项代表所有片段的记录从这个记录包含音频混合会话和光滑之间的过渡段。
 */
//- (AVPlayerItem *__nonnull)playerItemRepresentingSegments;

/**
给定AVMutableComposition添加所有的记录片段。
 */
//- (void)appendSegmentsToComposition:(AVMutableComposition *__nonnull)composition;

/**
附加的所有记录段给定AVMutableComposition并添加音频混合指令如果audioMix提供
 */
//- (void)appendSegmentsToComposition:(AVMutableComposition *__nonnull)composition audioMix:(AVMutableAudioMix *__nullable)audioMix;

/**
返回此SCRecordSession字典表示这将只包含字符串,因此可以安全地序列化在任何文本格式
 */
//- (NSDictionary *__nonnull)dictionaryRepresentation;

/**
停止当前段和deinitialize视频和音频。这可以有用如果输入视频或音频文件发生了变化。
 */
//- (void)deinitialize;

/**
开始一个新的记录。该方法自动由SCRecorder调用。
 */
//- (void)beginSegment:(NSError*__nullable*__nullable)error;

/**
结束当前记录。该方法自动由SCRecorder调用当调用(SCRecorder暂停)如果有必要。segmentIndex包含段记录的索引访问在recordSegments数组。如果错误不是null,将1如果你不删除的SCRecordSession SCRecorder调用该方法时,SCRecorder可能会创建一个新的recordSegment后自动如果不是停了下来。
 */
//- (BOOL)endSegmentWithInfo:(NSDictionary *__nullable)info completionHandler:(void(^__nullable)(SCRecordSessionSegment *__nullable segment, NSError *__nullable error))completionHandler;

@end
