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
#import "FMLPlayLayerView.h"
#import "FMLClipFrameView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>


@interface TBClipVideoViewController () <FMLClipFrameViewDelegate>

@property (nonatomic, strong) NSURL *assetUrl;
@property (nonatomic, strong) AVAsset *avAsset;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) FMLClipFrameView *clipFrameView;
@property (nonatomic, assign) Float64 startSecond;  ///< leftDragView对应的秒
@property (nonatomic, assign) Float64 endSecond;   ///< rightDragView对应的秒

@property (nonatomic, strong) FMLPlayLayerView *playerView;
@property (nonatomic, strong) id observer;
@property (nonatomic, strong) AVPlayer *player;                     ///< 播放器

@property (nonatomic, strong) AVMutableComposition *composition;
@property (nonatomic, strong) NSURL *compositionURL;

@property (nonatomic, strong) UIButton *sendButton ;
@end

static void *HJClipVideoStatusContext = &HJClipVideoStatusContext;
static void *HJClipVideoLayerReadyForDisplay = &HJClipVideoLayerReadyForDisplay;

@implementation TBClipVideoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    [self setUpData];
    [self.player play];
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

    FMLPlayLayerView *playerView = [FMLPlayLayerView new];
    playerView.player = self.player;
    [self.view addSubview:playerView];
    self.playerView = playerView;

    CGFloat viewH = _SCREEN_HEIGHT*(_SCREEN_WIDTH - 60)/_SCREEN_WIDTH;
    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.view).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(viewH);
    }];
    
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
    self.assetUrl = self.selectSegment.url;
    
    AVAsset  *avAsset =  self.selectSegment.asset;
    
    NSArray *assetKeysToLoadAndTest = @[@"playable", @"composable", @"tracks", @"duration"];
    
    [avAsset loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest completionHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setUpPlaybackOfAsset:avAsset withKeys:assetKeysToLoadAndTest];
        });
    }];
    
    self.avAsset = avAsset;
    
    [self addObserver:self forKeyPath:@"player.currentItem.status" options:NSKeyValueObservingOptionNew context:HJClipVideoStatusContext];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editCommandCompletionNotificationReceiver:) name:FMLEditCommandCompletionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exportCommandCompletionNotificationReceiver:) name:FMLExportCommandCompletionNotification object:nil];
    
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
    if ([asset tracksWithMediaType:AVMediaTypeVideo].count != 0) {
        
        [self addObserver:self forKeyPath:@"playerView.playerLayer.readyForDisplay" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:HJClipVideoLayerReadyForDisplay];
    } else {
    }
    
    [self setUpDataWithAVAsset:asset];
}

- (void)setUpDataWithAVAsset:(AVAsset *)asset
{
    // 创建一个AVPlayerItem资源 并将AVPlayer替换成创建的资源
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    
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
    [self.view insertSubview:clipFrameView aboveSubview:self.playerView];
    self.clipFrameView = clipFrameView;
    
    [clipFrameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-80);
        make.height.mas_equalTo(150);
    }];
}

- (void)stopLoadingAnimationAndHandleError:(NSError *)error
{
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
    self.sendButton.enabled = NO;
    [self.indicatorView startAnimating];
    [self.player pause];
    
    self.view.userInteractionEnabled = NO;
    
    FMLVideoCommand *videoCommand = [[FMLVideoCommand alloc] init];
    [videoCommand trimAsset:self.avAsset WithStartSecond:self.startSecond andEndSecond:self.endSecond];
}
#pragma mark - 监听状态
- (void)editCommandCompletionNotificationReceiver:(NSNotification*) notification
{
    if ([[notification name] isEqualToString:FMLEditCommandCompletionNotification]) {
        self.composition = [[notification object] mutableComposition];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            FMLVideoCommand *videoCommand = [[FMLVideoCommand alloc] initVideoCommendWithComposition:self.composition];
            [videoCommand exportAsset];
        });
    }
}

- (void)exportCommandCompletionNotificationReceiver:(NSNotification*) notification
{
    if ([[notification name] isEqualToString:FMLExportCommandCompletionNotification]) {
        NSURL *url = [[notification object] assetURL];
        
        self.compositionURL = url;
        
        dispatch_async( dispatch_get_main_queue(), ^{
            self.sendButton.enabled = YES;
            [self.indicatorView stopAnimating];
            self.view.userInteractionEnabled = YES;
            
            if (!url) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"导出视频失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            } else {
                
                [self videoExportSuccessUrl:url];
            }
        });
    }
}

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
            [self resetDisplayRect];
                break;
            case AVPlayerItemStatusFailed:
                [self stopLoadingAnimationAndHandleError:[[[self player] currentItem] error]];
                break;
        }
        
        // 无法播放的时候操作
    } else if (context == HJClipVideoLayerReadyForDisplay) {
        if ([change[NSKeyValueChangeNewKey] boolValue] == YES) {
            // 装备开始播放
            [self stopLoadingAnimationAndHandleError:nil];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)resetDisplayRect
{
    CGRect displayRect = self.playerView.playerLayer.videoRect;
    
    if (displayRect.size.height > displayRect.size.width) {
        return;
    }
    
    CGFloat clipFrameViewH =_SCREEN_WIDTH*9/16+1;
    [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.centerY.equalTo(self.view.mas_centerY).offset(-80);
        make.width.mas_equalTo(_SCREEN_WIDTH);
        make.height.mas_equalTo(clipFrameViewH);
    }];
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
    [self removeObserver:self forKeyPath:@"playerView.playerLayer.readyForDisplay" context:HJClipVideoLayerReadyForDisplay];
    
    self.player.rate =0;
    [self.player removeTimeObserver:self.observer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 懒加载
- (AVPlayer *)player
{
    if (!_player) {
        _player = [AVPlayer new];
    }
    return _player;
}


- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        _indicatorView.hidesWhenStopped = YES;
    }
    
    return _indicatorView;
}

@end
