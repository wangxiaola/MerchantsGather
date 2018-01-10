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
 视频合成方法

 @param asset 视频文件
 @param audioPath 音频路径
 @param results 结果
 */
+ (void)mergeVideo:(id )asset andAudio:(NSURL *)audioPath results:(void(^)(NSString *path, NSError *error))results;
@end
