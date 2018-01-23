//
//  LZNewPromotionVC.m
//  laziz_Merchant
//
//  Created by biyuhuaping on 2017/3/31.
//  Copyright © 2017年 XBN. All rights reserved.
//  视频录制页面
/*
 ==========================================视频相关=================================================
 */

#define MIN_VIDEO_DUR   3.0f //最小时间
#define MAX_VIDEO_DUR   10.0f //最大时间

#import "TBVideoShootingController.h"
#import "TBVideoEditingViewController.h"//视频详情

#import "LZGridView.h"
#import "LZLevelView.h"
#import "ProgressBar.h"
#import "LZButton.h"
#import "TBCaptureUtilities.h"

#import "SCRecorder.h"
#import "SCRecordSessionManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

#import "ClearCacheTool.h"

@interface TBVideoShootingController ()<SCRecorderDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIView *previewView;         //试映view
@property (strong, nonatomic) IBOutlet LZGridView *girdView;        //网格view
@property (strong, nonatomic) IBOutlet LZLevelView *levelView;      //水平仪view
@property (strong, nonatomic) IBOutlet ProgressBar *progressBar;    //进度条
@property (strong, nonatomic) IBOutlet SCRecorderToolsView *focusView;
@property (weak, nonatomic) IBOutlet UIImageView *recordingBackimageView;// 录制背景图片

@property (strong, nonatomic) IBOutlet UIButton *cancelButton;      //删除按钮
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;     //确认按钮
@property (weak, nonatomic) IBOutlet UIButton *flashButton;         // 闪光按钮
@property (weak, nonatomic) IBOutlet UIControl *recordingButton;    // 录制按钮
@property (strong, nonatomic) IBOutlet LZButton *gridOrlineButton;  //网格按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoViewHeight;

//recorder
@property (nonatomic, strong) SCRecorder *recorder;


@end

@implementation TBVideoShootingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"视频录制";
    [_gridOrlineButton setLoopImages:@[[UIImage imageNamed:@"lz_recorder_grid"], [UIImage imageNamed:@"lz_recorder_grid_hd"], [UIImage imageNamed:@"lz_recorder_line_hd"]] ];
    
    [self initSCRecorder];
    [self.progressBar startShining];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateProgressBar];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_recorder previewViewFrameChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_recorder startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_recorder stopRunning];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    //清除缓存
//    [ClearCacheTool clearAction];
    // 视频录制销毁
    [_recorder unprepare];
}

#pragma mark - configViews

//初始化录制
- (void)initSCRecorder {
    // 设置窗口大小
    self.videoViewHeight.constant = _SCREEN_WIDTH*9/16+1;
    
    _recorder = [SCRecorder recorder];
    _recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
    _recorder.maxRecordDuration = CMTimeMake(10.0, 1); //设置记录的最大持续时间
    _recorder.videoConfiguration.size = CGSizeMake(960, 540);
    _recorder.delegate = self;
    _recorder.autoSetVideoOrientation = NO;
    _recorder.previewView = self.previewView;
    
    //初始Session
    SCRecordSession *session = [SCRecordSession recordSession];
    session.fileType = AVFileTypeMPEG4;
    _recorder.session = session;
    
    self.focusView.recorder = _recorder;
    self.focusView.outsideFocusTargetImage = [UIImage imageNamed:@"lz_recorder_change_hd"];
    self.recordingButton.enabled = NO;
}


//更新进度条
- (void)updateProgressBar {
    if (self.recorder.session.segments.count == 0) {
        return;
    }
    
    self.cancelButton.enabled = YES;
    if (CMTimeGetSeconds(self.recorder.session.duration) >= 3) {
        self.confirmButton.enabled = YES;
    } else {
        self.confirmButton.enabled = NO;
    }
    
    [self.progressBar removeAllSubViews];
    for (int i = 0; i < self.recorder.session.segments.count; i++) {
        SCRecordSessionSegment * segment = self.recorder.session.segments[i];
        
        NSAssert(segment != nil, @"segment must be non-nil");
        CMTime currentTime = kCMTimeZero;
        if (segment) {
            currentTime = segment.duration;
            CGFloat width = CMTimeGetSeconds(currentTime) / MAX_VIDEO_DUR * _SCREEN_WIDTH;
            [self.progressBar setCurrentProgressToWidth:width];
        }
    }
}

- (void)saveAndShowSession:(SCRecordSession *)recordSession {
    [[SCRecordSessionManager sharedInstance] saveRecordSession:recordSession];
    self.recorder.session = recordSession;
    
    //视频详情
    TBVideoEditingViewController * vc = [[TBVideoEditingViewController alloc]initWithNibName:@"TBVideoEditingViewController" bundle:nil];
    vc.recordSession = self.recorder.session;
    vc.videoTime     = self.timeLabel.text;
    vc.videoName     = self.videoName;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Event

- (IBAction)dismmClick:(UIButton *)sender {
    
    [self.recorder.session removeAllSegments];
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}
//取消/删除视频按钮
- (IBAction)cancelButton:(UIButton *)sender {
    if (sender.selected == NO && sender.enabled == YES) {//第一次按下删除按钮
        sender.selected = YES;
        [self.progressBar setLastProgressToStyle:ProgressBarProgressStyleDelete];
    }
    else if (sender.selected == YES) {//第二次按下删除按钮
        [self.recorder.session removeLastSegment];
        [self.progressBar deleteLastProgress];
        
        if (self.recorder.session.segments.count > 0) {
            sender.selected = NO;
            sender.enabled = YES;
            if (CMTimeGetSeconds(self.recorder.session.duration) >= 3) {
                self.confirmButton.enabled = YES;
            } else {
                self.confirmButton.enabled = NO;
            }
        } else {
            sender.selected = NO;
            sender.enabled = NO;
            self.confirmButton.enabled = NO;
        }
        
        self.timeLabel.text = [NSString stringWithFormat:@"%.1f秒",CMTimeGetSeconds(self.recorder.session.duration)];
    }
}

//开始录制按钮
- (IBAction)recordButton:(UIControl *)sender {
    [self.recordingBackimageView setImage:[UIImage imageNamed:@"vide_ recording"]];
    [self.progressBar setLastProgressToStyle:ProgressBarProgressStyleNormal];
    [self.recorder record];
}

//暂停录制
- (IBAction)recordPauseButton:(id)sender {
    
    [self.recordingBackimageView setImage:[UIImage imageNamed:@"boss_voice_0"]];
    [self.recorder pause];
}

//确认按钮
- (IBAction)confirmButton:(UIButton *)sender {
    [self saveAndShowSession:self.recorder.session];
    [self.recordingBackimageView setImage:[UIImage imageNamed:@"boss_voice_0"]];
}

//切换摄像头按钮
- (IBAction)changeButton:(UIButton *)sender
{
    self.flashButton.enabled = (self.recorder.device != AVCaptureDevicePositionBack);
    
    [UIView animateWithDuration:0.5 animations:^{
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5f;
        animation.type = @"oglFlip";
        animation.subtype = kCATransitionFromLeft;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        [self.previewView.layer addAnimation:animation forKey:@"animation"];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.recorder switchCaptureDevices];
        }
    }];
    
}

//网格或线按钮
- (IBAction)gridOrlineButton:(LZButton *)sender {
    if (sender.currentIndex == 1) {
        self.girdView.hidden = NO;
    } else {
        self.girdView.hidden = YES;
    }
    
    if (sender.currentIndex == 2) {
        [self.levelView showLevelView];
    } else {
        [self.levelView hideLevelView];
    }
}

//闪光按钮
- (IBAction)flashButton:(UIButton *)sender {
    if (sender.selected == NO) {
        sender.selected = YES;
        self.recorder.flashMode = SCFlashModeLight;
    }
    else {
        sender.selected = NO;
        self.recorder.flashMode = SCFlashModeOff;
    }
}

#pragma mark - SCRecorderDelegate
- (void)recorder:(SCRecorder *)recorder didSkipVideoSampleBufferInSession:(SCRecordSession *)recordSession {
    MMLog(@"Skipped video buffer(跳过视频缓冲)");
}

- (void)recorder:(SCRecorder *)recorder didReconfigureAudioInput:(NSError *)audioInputError {

    if (audioInputError) {
        [UIView addMJNotifierWithText:@"音频录制异常!" dismissAutomatically:YES];
    }
}

- (void)recorder:(SCRecorder *)recorder didReconfigureVideoInput:(NSError *)videoInputError {

    if (videoInputError) {
        [UIView addMJNotifierWithText:@"视频录制异常!" dismissAutomatically:YES];
    }
    else
    {
      self.recordingButton.enabled = YES;
    }
}

//启动录制
- (void)recorder:(SCRecorder *__nonnull)recorder didBeginSegmentInSession:(SCRecordSession *__nonnull)session error:(NSError *__nullable)error {
    [self.progressBar addProgressView];
    [self.progressBar stopShining];
    self.cancelButton.enabled = YES;

}

//更新进度条
- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *)recordSession {
    CMTime recorderTime = kCMTimeZero;
    CMTime currentTime = kCMTimeZero;
    if (recordSession != nil) {
        currentTime = recordSession.currentSegmentDuration;
        recorderTime = recordSession.duration;
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%.1f秒",CMTimeGetSeconds(recorderTime)];
    
    CGFloat width = CMTimeGetSeconds(currentTime) / MAX_VIDEO_DUR * _SCREEN_WIDTH;
    [self.progressBar setLastProgressToWidth:width];
    
    if (CMTimeGetSeconds(recorderTime) >= 3) {
        self.confirmButton.enabled = YES;
    } else {
        self.confirmButton.enabled = NO;
    }
}

//录制完成
- (void)recorder:(SCRecorder *)recorder didCompleteSession:(SCRecordSession *)recordSession {
    MMLog(@"didCompleteSession:");
    [self.recordingBackimageView setImage:[UIImage imageNamed:@"boss_voice_0"]];
    [self saveAndShowSession:recordSession];

}

@end
