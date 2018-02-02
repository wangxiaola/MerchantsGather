//
//  TBClipVideoViewController.h
//  Telecom
//
//  Created by 王小腊 on 2018/1/30.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBBaseViewController.h"
#import "SCRecordSessionSegment+LZAdd.h"

/**
 视频裁剪
 */
@interface TBClipVideoViewController : TBBaseViewController
@property (nonatomic, strong) SCRecordSessionSegment * selectSegment;
@property (nonatomic, assign) Float64 recordTime;

@end
