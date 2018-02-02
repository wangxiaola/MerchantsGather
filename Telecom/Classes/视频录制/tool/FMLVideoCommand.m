//
//  FMLVideoCommand.m
//  VideoClip
//
//  Created by Collion on 16/8/7.
//  Copyright © 2016年 Collion. All rights reserved.
//

#import "FMLVideoCommand.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AVAsset+FMLVideo.h"

@implementation FMLVideoCommand

- (instancetype)initVideoCommendWithComposition:(AVMutableComposition *)composition
{
    if (self = [super init]) {
        _mutableComposition = composition;
    }
    
    return self;
}
- (void)trimAsset:(AVAsset *)asset WithStartTime:(Float64)startTime andEndTime:(Float64)endTime exportVideoURL:(void(^)(NSURL *url))videoURL;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *outputURL = paths[0];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
    outputURL = [outputURL stringByAppendingPathComponent:@"output.mp4"];
    // Remove Existing File
    [manager removeItemAtPath:outputURL error:nil];
    

    AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    // Here we are setting its render size to its height x height (Square)
    
    //    CGFloat width=MIN(cropRect.size.width, clipVideoTrack.naturalSize.width);
    
    //    CGFloat height=MIN( cropRect.size.height, clipVideoTrack.naturalSize.height);
    
    CGFloat renderSizeWidth = clipVideoTrack.naturalSize.height;
    
    videoComposition.renderSize =CGSizeMake(renderSizeWidth, renderSizeWidth*9/16.0);
    
    CALayer *parentLayer = [CALayer layer];
    
    CALayer *videoLayer = [CALayer layer];
    
    videoLayer.frame = CGRectMake(0,0, 320, 320*9/16.0);
    
    parentLayer.frame = CGRectMake(0,0, 320, 320*9/16.0);
    
    [parentLayer addSublayer:videoLayer];
    
    
    videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    
    
    
    AVMutableVideoCompositionLayerInstruction *avMutableVideoCompositionLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];
    
    
    
    CGAffineTransform t1 = clipVideoTrack.preferredTransform;
    
//    t1 = CGAffineTransformTranslate(t1, transY,0);
    
    [avMutableVideoCompositionLayerInstruction setTransform:t1 atTime:kCMTimeZero];
    
    
    
    instruction.layerInstructions = [NSArray arrayWithObject:avMutableVideoCompositionLayerInstruction];
    
    
    
    videoComposition.instructions = [NSArray arrayWithObject:instruction];
    
    AVAssetExportSession * exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];

    //长度
    
    CMTime start = CMTimeMakeWithSeconds(startTime, asset.duration.timescale);
    
    CMTime duration = CMTimeMakeWithSeconds(endTime, asset.duration.timescale);
    
    CMTimeRange range = CMTimeRangeMake(start, duration);
    
    exportSession.timeRange = range;

    //范围
    [exportSession setVideoComposition:videoComposition];
    
    exportSession.outputURL = [NSURL fileURLWithPath:outputURL];
    
    exportSession.outputFileType = AVFileTypeMPEG4;
    
    __block BOOL copyOK = NO;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     
     {
         
         dispatch_async(dispatch_get_main_queue(), ^{
             
//             [[WJTCtoolgetInstance] hideAnimation_seq_animation];
             
         });
         
         switch (exportSession.status)
         
         {
                 
             caseAVAssetExportSessionStatusUnknown:
                 
                 break;
                 
             caseAVAssetExportSessionStatusWaiting:
                 
//                 MyLog(@"------视频ok-----waiting");
                 
                 break;
                 
             caseAVAssetExportSessionStatusExporting:
                 
//                 MyLog(@"------视频ok-----expotring");
                 
                 
                 
                 break;
                 
             caseAVAssetExportSessionStatusCompleted:
                 
//                 MyLog(@"------视频ok");
                 
                 copyOK=YES;
                 
                 break;
                 
             caseAVAssetExportSessionStatusFailed:
                 
//                 MyLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                 
                 break;
                 
             caseAVAssetExportSessionStatusCancelled:
                 
                 break;
                 
             default:
                 
                 break;
                 
         }
         
         if (copyOK) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 if (videoURL) {
                     videoURL(exportSession.outputURL);
                 }
                 
             });
             
         }else
             
         {
             
//             [[WJTCtoolgetInstance] showAlertWithTitile:@"保存失败"];
             
         }
         
     }];
    
}

- (void)trimAsset:(AVAsset *)asset WithStartSecond:(Float64)startSecond andEndSecond:(Float64)endSecond
{
    AVAssetTrack *assetVideoTrack = nil;
    AVAssetTrack *assetAudioTrack = nil;
    
    // Check if the asset contains video and audio tracks
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        assetVideoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
        assetAudioTrack = [asset tracksWithMediaType:AVMediaTypeAudio][0];
    }
    
    CMTime insertionPoint = kCMTimeZero;
    CMTime startDuration = CMTimeMakeWithSeconds(startSecond, asset.fml_getFPS);
    CMTime duration = CMTimeMakeWithSeconds(endSecond - startSecond, asset.fml_getFPS);
    NSError *error = nil;
    
    _mutableComposition = [AVMutableComposition composition];
    
    if(assetVideoTrack != nil) {
        AVMutableCompositionTrack *compositionVideoTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(startDuration, duration) ofTrack:assetVideoTrack atTime:insertionPoint error:&error];
        compositionVideoTrack.preferredTransform = assetVideoTrack.preferredTransform;
    }
    if(assetAudioTrack != nil) {
        AVMutableCompositionTrack *compositionAudioTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(startDuration, duration) ofTrack:assetAudioTrack atTime:insertionPoint error:&error];
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:FMLEditCommandCompletionNotification object:self];
}

- (void)exportAsset
{
    // Step 1
    // Create an outputURL to which the exported movie will be saved
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *outputURL = paths[0];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
    outputURL = [outputURL stringByAppendingPathComponent:@"output.mp4"];
    // Remove Existing File
    [manager removeItemAtPath:outputURL error:nil];
    
    // Step 2
    // Create an export session with the composition and write the exported movie to the photo library
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:[self.mutableComposition copy] presetName:AVAssetExportPreset640x480];
    
    exportSession.outputURL = [NSURL fileURLWithPath:outputURL];
    exportSession.outputFileType=AVFileTypeMPEG4;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
        switch (exportSession.status) {
            case AVAssetExportSessionStatusCompleted:
                //                [self writeVideoToPhotoLibrary:[NSURL fileURLWithPath:outputURL]];
                // Step 3
                _assetURL = exportSession.outputURL;
                
//                [[NSNotificationCenter defaultCenter] postNotificationName:FMLExportCommandCompletionNotification
//                                                                    object:self];
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog(@"Failed:%@", exportSession.error);
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Canceled:%@", exportSession.error);
                break;
            default:
                break;
        }
    }];
}

@end
