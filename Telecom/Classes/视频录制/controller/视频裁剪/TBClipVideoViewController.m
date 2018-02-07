//
//  TBClipVideoViewController.m
//  Telecom
//
//  Created by 王小腊 on 2018/1/30.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBClipVideoViewController.h"
#import "UIView+Extension.h"
#import "AVAsset+FMLVideo.h"
#import "UIImage+FMLClipRect.h"
#import "FMLVideoCommand.h"
#import "FMLClipFrameView.h"
#import "Telecom-Swift.h"
#import "TBVideoCropView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface TBClipVideoViewController () <FMLClipFrameViewDelegate>

@property (nonatomic, strong) AVAsset *avAsset;
@property (nonatomic, assign) CGSize outputSize;

@property (nonatomic, strong) TBVideoCropView *cropView;
@property (nonatomic, strong) FMLClipFrameView *clipFrameView;
@property (nonatomic, assign) Float64 startSecond;  ///< leftDragView对应的秒
@property (nonatomic, assign) Float64 endSecond;   ///< rightDragView对应的秒

@property (nonatomic, strong) id observer;
@property (nonatomic, strong) AVPlayer *player;     ///< 播放器

@property (nonatomic, strong) TBVideoClipTailor *clipTailor;
@property (nonatomic, strong) NSURL *compositionURL;

@property (nonatomic, strong) UIButton *sendButton;
@end

static void *HJClipVideoStatusContext = &HJClipVideoStatusContext;

@implementation TBClipVideoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.player) {
        [self.player play];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.outputSize = CGSizeMake(960, 540);
    [self setUpView];
    [self setUpData];
    MMLog(@"采取时间 = %f",self.recordTime);
}

#pragma mark - 初始化view
- (void)setUpView
{
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setUpNavBar];
    [self setUpPlayerView];
    
}

/** 添加自定义navigationbar */
- (void)setUpNavBar
{
    self.navigationItem.title = @"剪裁";
}

- (void)setUpPlayerView
{
    CGFloat viewH = _SCREEN_WIDTH*9/16;
    CGFloat lenght = self.view.size.width;
    CGFloat cropRatio = self.outputSize.width/self.outputSize.height;
    CGFloat y = 0;
    
    if (cropRatio > 1) {
        
       y = (1-1/cropRatio)*0.5*lenght;
    }
    
    self.cropView = [[TBVideoCropView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, viewH+y*2)];
    self.cropView.backgroundColor = RGB(19, 21, 17);
    [self.view addSubview:self.cropView];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomView];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setImage:[UIImage imageNamed:@"video_ confirm"] forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(senderClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.sendButton];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@80);
        
    }];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bottomView);
        make.width.height.equalTo(@60);
    }];
}

#pragma mark - 初始化数据
- (void)setUpData
{
    AVAsset  *avAsset =  self.selectSegment.asset;
    
    NSArray *assetKeysToLoadAndTest = @[@"playable", @"composable", @"tracks", @"duration"];
    
    [avAsset loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setUpPlaybackOfAsset:avAsset withKeys:assetKeysToLoadAndTest];
        });
    }];
    
    NSArray *info = [self.pathQZ componentsSeparatedByString:@"&"];
    NSString *pathName = [NSString stringWithFormat:@"/%@Output.mp4",info.lastObject];
    
    NSString *outputURL = [ZKUtil createRecordingSuperiorName:info.firstObject childName:pathName];

    self.compositionURL = [NSURL fileURLWithPath:outputURL];
    
    self.avAsset = avAsset;
    
    self.clipTailor = [[TBVideoClipTailor alloc] init];
    
    TBWeakSelf
    [self.clipTailor setExportFailedHandler:^(NSError * _Nullable error) {
        [weakSelf exportFailed:error];
    }];
    [self.clipTailor setExportProgressHandler:^(CGFloat progress) {
        [weakSelf exportProgress:progress];
    }];
    [self.clipTailor setExportSuccessHandler:^(NSURL * _Nonnull url) {
        [weakSelf exportSuccess:url];
    }];
    
    [self addObserver:self forKeyPath:@"player.currentItem.status" options:NSKeyValueObservingOptionNew context:HJClipVideoStatusContext];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
}

- (void)setUpPlaybackOfAsset:(AVAsset *)asset withKeys:(NSArray *)keys
{
    // 检查我们需要的key是否被正常加载
    for (NSString *key in keys) {
        NSError *error = nil;
        
        if ([asset statusOfValueForKey:key error:&error] == AVKeyValueStatusFailed) {
            [self stopLoadingAnimationAndHandleError:error];
            return;
        }
    }
    
    // 视频不可播放
    if (!asset.isPlayable) {
        return;
    }
    
    // 视频通道不可用
    if (!asset.isComposable) {
        return;
    }
    
    // 代表视频的每个通道长度是否为0
    if ([asset tracksWithMediaType:AVMediaTypeVideo].count == 0) {
        
        [self stopLoadingAnimationAndHandleError:nil];
        return;
    } else {
    }
    
    [self setUpDataWithAVAsset:asset];
}

- (void)setUpDataWithAVAsset:(AVAsset *)asset
{
    // 创建一个AVPlayerItem资源 并将AVPlayer替换成创建的资源
    [self.cropView load:asset cropSize:self.outputSize];
    self.player = self.cropView.player;
    self.endSecond = CMTimeGetSeconds(asset.duration); // 默认是总秒数
    if (self.endSecond > self.recordTime) {
        self.endSecond = self.recordTime;
    }
    
    // 监听时间
    TBWeakSelf
    self.observer = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, self.avAsset.fml_getFPS) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        Float64 seconds = CMTimeGetSeconds(time);
        
        if (seconds >= weakSelf.endSecond) {
            [weakSelf playerItemDidReachEnd];
        }else if (weakSelf.player.rate > 0) {
            [weakSelf.clipFrameView setProgressBarPoisionWithSecond:seconds];
        } else if (weakSelf.player.rate ==0) {
        }
    }];
    
    [self setUpClipFrameView:asset];
}

- (void)setUpClipFrameView:(AVAsset *)asset
{
    FMLClipFrameView *clipFrameView = [[FMLClipFrameView alloc] initWithAsset:asset recordTime:self.recordTime];
    clipFrameView.delegate = self;
    [self.view insertSubview:clipFrameView aboveSubview:self.cropView];
    self.clipFrameView = clipFrameView;
    
    [clipFrameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.cropView.mas_bottom);
        make.height.mas_equalTo(150);
    }];
    [self.player play];
}

- (void)stopLoadingAnimationAndHandleError:(NSError *)error
{
    self.sendButton.enabled = YES;
    self.view.userInteractionEnabled = YES;
    // 去除加载动画
    // 有错误提示的时候，显示错误提示
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                            message:[error localizedFailureReason]
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}
#pragma mark  ----TBVideoClipTailorDelegate----
- (void)exportFailed:(NSError *_Nonnull)error;
{
    dispatch_async( dispatch_get_main_queue(), ^{
        self.sendButton.enabled = YES;
        self.view.userInteractionEnabled = YES;
        hudShowError(@"导出视频失败");
    });
}
- (void)exportSuccess:(NSURL *_Nonnull)outputUrl;
{
    self.sendButton.enabled = YES;
    hudDismiss();
    self.view.userInteractionEnabled = YES;
    [self videoExportSuccessUrl:outputUrl];
    
}
- (void)exportProgress:(CGFloat)progress;
{
    [SVProgressHUD showProgress:progress];
}
#pragma mark - FMLClipFrameView代理
- (void)didStartDragView
{
    self.sendButton.enabled = NO;
    if (self.player.rate > 0) { // 正在播放的时候
        [self.player pause];
    }
}

- (void)clipFrameView:(FMLClipFrameView *)clipFrameView didDragView:(Float64)second
{
    [self.player seekToTime:CMTimeMakeWithSeconds(second, self.avAsset.fml_getFPS) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)clipFrameView:(FMLClipFrameView *)clipFrameView didEndDragLeftView:(Float64)second
{
    self.startSecond = second;
    [self.player seekToTime:CMTimeMakeWithSeconds(second, self.avAsset.fml_getFPS) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)clipFrameView:(FMLClipFrameView *)clipFrameView didEndDragRightView:(Float64)second
{
    self.endSecond = second;
    
    [self.player seekToTime:CMTimeMakeWithSeconds(self.startSecond, self.avAsset.fml_getFPS) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player play];
    self.sendButton.enabled = YES;
}

- (void)clipFrameView:(FMLClipFrameView *)clipFrameView isScrolling:(BOOL)scrolling
{
    self.view.userInteractionEnabled = !scrolling;
}

#pragma mark - 事件

- (void)playerItemDidReachEnd
{
    [self.clipFrameView resetProgressBarMode];
    
    [self.player seekToTime:CMTimeMakeWithSeconds(self.startSecond, self.avAsset.fml_getFPS) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        [self.player pause];
    }];
}
// 完成
- (void)senderClick
{
    [self finishClip];
    self.sendButton.enabled = NO;
    hudShowLoading(@"开始剪裁视频");
    [self.player pause];
    
    self.view.userInteractionEnabled = NO;

    CMTime start = CMTimeMakeWithSeconds(self.startSecond, self.avAsset.duration.timescale);
    CMTime duration = CMTimeMakeWithSeconds(self.recordTime, self.avAsset.duration.timescale);
    CMTimeRange range = CMTimeRangeMake(start, duration);
    
    [self.clipTailor export:self.avAsset :[self.cropView cropRect] :range :self.outputSize :self.compositionURL];
    
}
#pragma mark - 导出成功

/**
 视频导出成功
 
 @param url 地址
 */
- (void)videoExportSuccessUrl:(NSURL *)url
{
    //发送消息
    [[NSNotificationCenter defaultCenter] postNotificationName:Verification_clip object:url];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (context == HJClipVideoStatusContext) {
        
        AVPlayerStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        BOOL enable = NO;
        switch (status) {
            case AVPlayerItemStatusUnknown:
                break;
            case AVPlayerItemStatusReadyToPlay:
                enable = YES;
                
                break;
            case AVPlayerItemStatusFailed:
                [self stopLoadingAnimationAndHandleError:[[[self player] currentItem] error]];
                break;
        }
        
        // 无法播放的时候操作
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)finishClip
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:self.compositionURL.path]) {
        [fileManager removeItemAtURL:self.compositionURL error:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.player pause];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"player.currentItem.status" context:HJClipVideoStatusContext];
    
    self.player.rate =0;
    [self.player removeTimeObserver:self.observer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

