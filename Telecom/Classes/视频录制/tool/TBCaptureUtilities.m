//
//  TBCaptureUtilities.m
//  Telecom
//
//  Created by 王小腊 on 2018/1/2.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBCaptureUtilities.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>

@implementation TBCaptureUtilities


+ (void)mergeVideo:(id )asset andAudioPath:(NSURL *)audioPath videoName:(NSString *)name results:(void(^)(NSString *path, NSError *error))results;
{
    // 初始化视频媒体文件
    AVURLAsset *videoAsset = asset;
    
    CMTime startTime = CMTimeMakeWithSeconds(0.0, videoAsset.duration.timescale);
    CMTime endTime = CMTimeMakeWithSeconds(videoAsset.duration.value/videoAsset.duration.timescale, videoAsset.duration.timescale);
    // 声音采集
    AVURLAsset * audioAsset;
    if (audioPath) {
        audioAsset = [[AVURLAsset alloc] initWithURL:audioPath options:[NSDictionary dictionaryWithObject:@(YES) forKey:AVURLAssetPreferPreciseDurationAndTimingKey]];
    }
    else
    {
         audioAsset = asset;
    }
    
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    //3 视频通道  工程文件中的轨道，有音频轨、视频轨等，里面可以插入各种对应的素材
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    //把视频轨道数据加入到可变轨道中 这部分可以做视频裁剪TimeRange
    [videoTrack insertTimeRange:CMTimeRangeFromTimeToTime(startTime, endTime)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    //音频通道
    AVMutableCompositionTrack * audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //音频采集通道
    AVAssetTrack * audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    [audioTrack insertTimeRange:CMTimeRangeFromTimeToTime(startTime, endTime) ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    
    //3.1 AVMutableVideoCompositionInstruction 视频轨道中的一个视频，可以缩放、旋转等
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeFromTimeToTime(kCMTimeZero, videoTrack.timeRange.duration);
    
    // 3.2 AVMutableVideoCompositionLayerInstruction 一个视频轨道，包含了这个轨道上的所有视频素材
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    CGSize naturalSize = videoAssetTrack.naturalSize;
    
    naturalSize = videoAssetTrack.naturalSize;
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    // 视频旋转
    //   [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    
    [videolayerInstruction setOpacity:0.0 atTime:endTime];
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    //AVMutableVideoComposition：管理所有视频轨道，可以决定最终视频的尺寸，裁剪需要在这里进行
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:videoAsset];
    
    
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 25);
    
    if (name.length > 0) {
        
        [TBCaptureUtilities applyVideoEffectsToComposition:mainCompositionInst shopName:name size:CGSizeMake(renderWidth, renderHeight)];
    }
    // 4 - 输出路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"waterVideo.mp4"];
    unlink([myPathDocs UTF8String]);
    NSURL* videoUrl = [NSURL fileURLWithPath:myPathDocs];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
    {
        [[NSFileManager defaultManager] removeItemAtPath:myPathDocs error:nil];
    }
    
    //转码配置
    AVAssetExportSession * exportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                       presetName:AVAssetExportPresetHighestQuality];
    
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputURL = videoUrl;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.videoComposition = mainCompositionInst;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        int exportStatus = exportSession.status;
    
        switch (exportStatus)
        {
            case AVAssetExportSessionStatusFailed:
            {

                break;
            }
            case AVAssetExportSessionStatusCompleted:
            {
                if (results) {
                    results(myPathDocs, nil);
                }

            }
        }
    }];
    
//    AVAssetExportSession * exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
//                                                                       presetName:AVAssetExportPresetHighestQuality];
//    exporter.outputURL= videoUrl;
//    exporter.outputFileType = AVFileTypeQuickTimeMovie;
//    exporter.shouldOptimizeForNetworkUse = YES;
//    exporter.videoComposition = mainCompositionInst;
//    [exporter exportAsynchronouslyWithCompletionHandler:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //这里是输出视频之后的操作，做你想做的
//            if (results) {
//                results(myPathDocs, nil);
//            }
//        });
//    }];
}

+ (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition shopName:(NSString*)name size:(CGSize)size;
{
    UIFont *font = [UIFont systemFontOfSize:40 weight:0.3];
    
    CATextLayer *subtitleText = [[CATextLayer alloc] init];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    subtitleText.font = fontRef;
    subtitleText.fontSize = font.pointSize;
    [subtitleText setString:name];
    [subtitleText setAlignmentMode:kCAAlignmentCenter];
    [subtitleText setForegroundColor:[[UIColor whiteColor] CGColor]];
    [subtitleText setBackgroundColor:[UIColor clearColor].CGColor];
    //解决文字模糊 以Retina方式来渲染，防止画出来的文本像素化
    subtitleText.contentsScale = [UIScreen mainScreen].scale;
    CGSize textSize = [name sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    
    [subtitleText setFrame:CGRectMake(0, 0, textSize.width+30, textSize.height+10)];
    subtitleText.position = CGPointMake(size.width/2.0, size.height/2.0);
    
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:subtitleText];
    
    overlayLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    //设置封面
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima.fromValue = [NSNumber numberWithFloat:1.0f];
    anima.toValue = [NSNumber numberWithFloat:0.0f];
    anima.repeatCount = 0;
    anima.duration = 2.0f;  //2s之后消失
    [anima setRemovedOnCompletion:NO];
    [anima setFillMode:kCAFillModeForwards];
    anima.beginTime = AVCoreAnimationBeginTimeAtZero;
    
    [overlayLayer addAnimation:anima forKey:@"opacityAniamtion"];
    
    
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
}

@end
