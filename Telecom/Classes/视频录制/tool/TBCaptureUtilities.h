//
//  TBCaptureUtilities.h
//  Telecom
//
//  Created by 王小腊 on 2018/1/2.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBCaptureUtilities : NSObject


/**
 视频合成

 @param asset 视频文件
 @param audioPath 音频路径
 @param name 水印名称
 @param results 成功返回
 */
+ (void)mergeVideo:(id )asset andAudioPath:(NSURL *)audioPath videoName:(NSString *)name results:(void(^)(NSString *path, NSError *error))results;

@end
