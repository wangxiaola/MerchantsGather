//
//  TBVideoCropView.h
//  Telecom
//
//  Created by 王小腊 on 2018/2/1.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVPlayer,AVPlayerLayer,AVAsset;

@interface TBVideoCropView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, assign) CGSize videoSize;

@property (nonatomic, assign) CGSize cropSize;

- (void)load:(AVAsset *)asset cropSize:(CGSize)cropSize;
- (void)play;
- (void)pause;
- (CGRect)cropRect;
    
@end
