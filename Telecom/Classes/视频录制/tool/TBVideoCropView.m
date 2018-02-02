//
//  TBVideoCropView.m
//  Telecom
//
//  Created by 王小腊 on 2018/2/1.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBVideoCropView.h"
#import <AVFoundation/AVFoundation.h>
@implementation TBVideoCropView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
            [self setupUI];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self adjustLayout];
}
- (void)setupUI
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
}
- (void)adjustLayout
{
    if (self.videoSize.width == 0 || self.cropSize.width == 0) {
        
        return;
    }
    
    CGFloat lenght = self.bounds.size.width;
    CGFloat videoRatio = _videoSize.width/_videoSize.height;
    CGFloat cropRatio = _cropSize.width/_cropSize.height;
    
    CGSize scrollSize = CGSizeZero;
    CGPoint scrollOrigin = CGPointZero;
    
    if (cropRatio > 1) {
        
        scrollSize = CGSizeMake(lenght, lenght/cropRatio);
        CGFloat y = (1-1/cropRatio)*0.5*lenght;
        scrollOrigin = CGPointMake(0,y);
    }
    else
    {
        CGFloat x = (1-cropRatio)*0.5*lenght;
        scrollSize = CGSizeMake(lenght*cropRatio, lenght);
        scrollOrigin = CGPointMake(x, 0);
    }
    
    CGSize contentSize = CGSizeZero;
    if (videoRatio > cropRatio) {
       
        contentSize = CGSizeMake(scrollSize.height*videoRatio, scrollSize.height);
    }
    else
    {
        contentSize = CGSizeMake(scrollSize.width, scrollSize.width/videoRatio);
    }
    self.scrollView.frame = CGRectMake(scrollOrigin.x, scrollOrigin.y, scrollSize.width, scrollSize.height);
    self.scrollView.contentSize = contentSize;
    self.playerLayer.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    
}
#pragma mark  ----Public----
- (void)load:(AVAsset *)asset cropSize:(CGSize)cropSize
{
    self.videoSize = [self transformedSize:asset];
    self.cropSize = cropSize;
    
    self.player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithAsset:asset]];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.scrollView.layer addSublayer:self.playerLayer];
    [self adjustLayout];
    
}
- (void)play
{
    [self.player play];
}
- (void)pause{
    [self.player pause];
}
- (CGRect)cropRect
{
    CGPoint contentOffset = self.scrollView.contentOffset;
    CGSize contentSize = self.scrollView.contentSize;
    CGSize scrollViewSize = self.scrollView.frame.size;
    
    CGPoint origin = CGPointMake(contentOffset.x/contentSize.width, contentOffset.y/contentSize.height);
    CGSize size = CGSizeMake(scrollViewSize.width/contentSize.width, scrollViewSize.height/contentSize.height);
    return CGRectMake(origin.x,origin.y, size.width, size.height);
}
- (CGSize)transformedSize:(AVAsset *)asset
{
  AVAssetTrack *videoTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    if (videoTrack) {
        CGSize naturalSize = videoTrack.naturalSize;
        CGSize sourceSize = naturalSize;
        CGAffineTransform trackTrans = videoTrack.preferredTransform;
        
        if ((trackTrans.b == 1 && trackTrans.c == -1)||(trackTrans.b == -1 && trackTrans.c == 1)) {
            
            sourceSize = CGSizeMake(naturalSize.height, naturalSize.width);
        }
        return sourceSize;
    }
    return CGSizeMake(0, 0);
}
@end
