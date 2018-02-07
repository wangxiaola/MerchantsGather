//
//  TBVideoEditingViewController.h
//  laziz_Merchant
//
//  Created by biyuhuaping on 2017/4/19.
//  Copyright © 2017年 XBN. All rights reserved.
//  视频详情

#import <UIKit/UIKit.h>
#import "SCRecorder.h"

@interface TBVideoEditingViewController : UIViewController

@property (nonatomic, strong) SCRecordSession * recordSession;
/**
 录制时间
 */
@property (nonatomic, strong) NSString *videoTime;

/**
 视频水印名称
 */
@property (nonatomic, strong) NSString *videoName;

@property (nonatomic, strong) NSString *videoID;
@end
