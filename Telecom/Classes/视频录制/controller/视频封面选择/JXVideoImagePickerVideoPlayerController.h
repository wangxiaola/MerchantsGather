//
//  JXVideoImagePickerVideoPlayerController.h
//  JXVideoImagePicker
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface JXVideoImagePickerVideoPlayerController : UIViewController

//创建视频显示的图层
@property(nonatomic, strong) AVPlayerLayer *playerLayer;

@property(nonatomic, strong)AVAsset *asset;

//  想要定格的时间
- (void)seekToTime:(CMTime)time;
// 回调图片
- (void)getCurrentImage:(void(^)(UIImage *image))image;

@end



