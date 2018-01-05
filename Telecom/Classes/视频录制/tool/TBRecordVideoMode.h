//
//  TBRecordVideoMode.h
//  Telecom
//
//  Created by 王小腊 on 2017/12/29.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 录制视频模型
 */
@interface TBRecordVideoMode : NSObject

/** videoPath*/
@property (nonatomic, strong) NSString *videoPath;
/**
 录制时间
 */
@property (nonatomic, strong) NSString *videoTime;
/**
 封面背景
 */
@property (nonatomic, strong) UIImage *coverImage;

@property (nonatomic, strong) NSString *coverUrl;

@end
