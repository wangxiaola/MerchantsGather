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

/**
 视频合成方法
 
 @param asset 视频文件
 @param audioPath 音频路径
 @param results 结果
 */
+ (void)mergeVideo:(id )asset andAudio:(NSURL *)audioPath results:(void(^)(NSString *path, NSError *error))results;
{
    NSURL *audioUrl = audioPath;
	
	AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audioUrl options:nil];
   
	AVURLAsset* videoAsset = asset;
	
    NSLog(@"%f",CMTimeGetSeconds(videoAsset.duration));
    
	//混合音乐
	AVMutableComposition* mixComposition = [AVMutableComposition composition];
	AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio 
																						preferredTrackID:kCMPersistentTrackID_Invalid];
    CMTime t1 = videoAsset.duration;
    NSArray *ay = [audioAsset tracksWithMediaType:AVMediaTypeAudio];
    
    AVAssetTrack *track = [ay objectAtIndex:0];
    
	[compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,t1 )
										ofTrack:track
										 atTime:kCMTimeZero error:nil];
	
	
	//混合视频
	AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo 
																				   preferredTrackID:kCMPersistentTrackID_Invalid];
	[compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) 
								   ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] 
									atTime:kCMTimeZero error:nil];
	AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition 
																		  presetName:AVAssetExportPresetPassthrough];
    
	//保存混合后的文件的过程
	NSString* videoName = @"export.mp4";
	NSString *exportPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:videoName];
    
	NSURL    *exportUrl = [NSURL fileURLWithPath:exportPath];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath]) 
	{
		[[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
	}
	
	_assetExport.outputFileType = @"com.apple.quicktime-movie";
	_assetExport.outputURL = exportUrl;
	_assetExport.shouldOptimizeForNetworkUse = YES;
	
	[_assetExport exportAsynchronouslyWithCompletionHandler:
	 ^(void ) 
    {    
        if (results) {
            
            results(exportPath,nil);
        }
     }];
    
}

@end
