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

#define MAX_VIDEO_DUR   10.0f //最大时间

#import "TBVideoShootingController.h"
#import "TBVideoEditingViewController.h"//视频详情
#import "TBPhotoChooseCollectionViewController.h"// 相册浏览

#import "YBPopupMenu.h"
#import "LZGridView.h"
#import "LZLevelView.h"
#import "ProgressBar.h"
#import "LZButton.h"
#import "TBCaptureUtilities.h"
#import "TBVideoRecordButtonView.h"
#import "SCRecorder.h"
#import "SCRecordSessionManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

#import "ClearCacheTool.h"

@interface TBVideoShootingController ()<SCRecorderDelegate,ProgressBarDelegate,YBPopupMenuDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIView *previewView;         //试映view
@property (strong, nonatomic) IBOutlet LZGridView *girdView;        //网格view
@property (strong, nonatomic) IBOutlet LZLevelView *levelView;      //水平仪view
@property (strong, nonatomic) IBOutlet ProgressBar *progressBar;    //进度条
@property (strong, nonatomic) IBOutlet SCRecorderToolsView *focusView;


@property (strong, nonatomic) IBOutlet UIButton *cancelButton;      //删除按钮
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;     //确认按钮
@property (weak, nonatomic) IBOutlet UIButton *flashButton;         // 闪光按钮
@property (weak, nonatomic) IBOutlet TBVideoRecordButtonView *recordingView;

@property (strong, nonatomic) IBOutlet LZButton *gridOrlineButton;  //网格按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoViewHeight;

@property (nonatomic, assign) NSInteger nodesFolat;// 几段
//recorder
@property (nonatomic, strong) SCRecorder *recorder;
@property (nonatomic, assign) CGFloat  nodesAllWidth;// 进度全长
@property (nonatomic, assign) CGFloat progressWidth;// 进度宽
/**
 更新第几个
 */
@property (nonatomic, assign) NSInteger updateIndex;

@end

@implementation TBVideoShootingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    hudShowLoading(@"正在初始化");
    self.navigationItem.title = @"视频录制";
    [_gridOrlineButton setLoopImages:@[[UIImage imageNamed:@"lz_recorder_grid"], [UIImage imageNamed:@"lz_recorder_grid_hd"], [UIImage imageNamed:@"lz_recorder_line_hd"]] ];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"userPhotos"] style:(UIBarButtonItemStylePlain) target:self action:@selector(photoChoose)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"recorder_nodes"] style:(UIBarButtonItemStylePlain) target:self action:@selector(recorderNodes:)];
    
    self.progressBar.delegate = self;
    self.nodesFolat  = 4;
    self.updateIndex = -1;
    [self initSCRecorder];
    [self updateProgress];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self addVideoNotificationCenter];
}
/**
 添加视频录制通知
 */
- (void)addVideoNotificationCenter
{
    //获取通知中心单例对象
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoInfoNotificationAction:) name:Verification_clip object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateViewState];
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
    // 视频录制销毁
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    JXWeakSelf(self)
    [self.recordingView setStartRecord:^{
        JXStrongSelf(self)
        [self recordVideo];
    }];
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

/**
 更新视图状态
 */
- (void)updateViewState
{
    self.timeLabel.text = [NSString stringWithFormat:@"%.1f秒",self.recorder.session.segments.count *(MAX_VIDEO_DUR/self.nodesFolat)];
    
    if (self.recorder.session.segments.count == self.nodesFolat) {
        
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.cancelButton.enabled = YES;
        self.confirmButton.enabled = YES;
        self.cancelButton.selected = NO;
    }
    else if (self.recorder.session.segments.count == 0)
    {
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        self.cancelButton.enabled = NO;
        self.confirmButton.enabled = NO;
        self.cancelButton.selected = NO;
    }
    else
    {
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.cancelButton.enabled = YES;
        self.cancelButton.selected = NO;
        self.confirmButton.enabled = YES;
        
    }
}
- (void)updateProgress
{
    [self.progressBar updateViewNodesNumber:self.nodesFolat];
    self.nodesAllWidth = _SCREEN_WIDTH - 2*(self.nodesFolat-1);
    self.progressWidth = self.nodesAllWidth/self.nodesFolat;
}
#pragma mark - Event
- (void)photoChoose
{
    TBPhotoChooseCollectionViewController *photoVc = [[TBPhotoChooseCollectionViewController alloc] init];
    photoVc.miniTime = MAX_VIDEO_DUR/self.nodesFolat;
    [self.navigationController pushViewController:photoVc animated:YES];
    
}
- (void)recorderNodes:(UIBarButtonItem *)sender
{
    // 状态栏(statusbar)
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    // 导航栏（navigationbar）
    CGRect rectNav = self.navigationController.navigationBar.frame;
    
    YBPopupMenu *popupMenu = [YBPopupMenu showAtPoint:CGPointMake(_SCREEN_WIDTH - 30, rectStatus.size.height + rectNav.size.height)
                                               titles:@[@"一个录制节点",@"二个录制节点",@"三个录制节点",@"四个录制节点",@"五个录制节点"]
                                                icons:@[@"service-selected",@"service-selected",@"service-selected",@"service-selected",@"service-selected"]
                                            menuWidth:140
                                             delegate:self];
    popupMenu.offset = -60;
    popupMenu.fontSize = 12;
    popupMenu.type = YBPopupMenuTypeDefault;
}
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
        self.navigationItem.leftBarButtonItem.enabled = YES;
        if (self.recorder.session.segments.count > 0) {
            sender.selected = NO;
            sender.enabled = YES;
            if (self.recorder.session.segments.count > 0) {
                self.confirmButton.enabled = YES;
            } else {
                self.confirmButton.enabled = NO;
            }
        } else {
            sender.selected = NO;
            sender.enabled = NO;
            self.confirmButton.enabled = NO;
        }
        [self updateViewState];
    }
}

/**
 开始录制视频
 */
- (void)recordVideo
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if (self.recorder.session.segments.count == self.nodesFolat) {
        
        [UIView addMJNotifierWithText:@"不能再录制了！" dismissAutomatically:YES];
    }
    else
    {
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.cancelButton.enabled = NO;
        self.confirmButton.enabled = NO;
        self.cancelButton.selected = NO;
        self.progressBar.userInteractionEnabled = NO;
        [self.progressBar progressViewResetAll];
        [self.recorder record];
        
    }
}

//暂停录制
- (void)recordPause{
    
    [self.recorder pause];
    self.cancelButton.enabled = YES;
    self.confirmButton.enabled = YES;
    self.progressBar.userInteractionEnabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

//确认按钮
- (IBAction)confirmButton:(UIButton *)sender {
    [self saveAndShowSession:self.recorder.session];
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
#pragma mark  ----通知----
- (void)videoInfoNotificationAction:(NSNotification *)notification{
    
    NSURL *url = notification.object;
    if (self.updateIndex > -1)
    {
        [self insertVideoUrl:url atIndex:self.updateIndex isRecorder:NO];
    }
    else
    {
        [self insertVideoUrl:url atIndex:self.recorder.session.segments.count isRecorder:NO];
    }
    
}
#pragma mark  ----ProgressBarDelegate----
/**
 选中
 
 @param index 第几个
 */
- (void)progressViewSelected:(NSInteger)index;
{
    self.cancelButton.enabled = YES;
    self.cancelButton.selected = NO;
}
/**
 重新录制
 
 @param segment 第几段
 */
- (void)reRecordingInsertTheSegment:(NSInteger)segment;
{
    self.updateIndex = segment;
    [self recordVideo];
}
/**
 导入相册视频
 
 @param segment 第几段
 */
- (void)replacePhotoVideoInsertTheSegment:(NSInteger)segment;
{
    self.updateIndex = segment;
    [self photoChoose];
}
/**
 删除第几段
 
 @param segment 第几段
 */
- (void)deleteTheSegment:(NSInteger)segment;
{
    [self.progressBar deleteTheSegmentProgress:segment];
    [self.recorder.session removeSegmentAtIndex:segment deleteFile:YES];
    [self updateViewState];
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
    
    hudDismiss();
    if (videoInputError) {
        [UIView addMJNotifierWithText:@"视频录制异常!" dismissAutomatically:YES];
    }
    
}

//启动录制
- (void)recorder:(SCRecorder *__nonnull)recorder didBeginSegmentInSession:(SCRecordSession *__nonnull)session error:(NSError *__nullable)error {
    
    if (self.updateIndex < 0) {
        
        [self.progressBar addProgressView];
    }
    
}

//更新进度条
- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *)recordSession
{
    CMTime recorderTime = kCMTimeZero;
    CMTime currentTime = kCMTimeZero;
    if (recordSession != nil) {
        currentTime = recordSession.currentSegmentDuration;
        recorderTime = recordSession.duration;
    }
    CGFloat time = CMTimeGetSeconds(recorderTime);
    CGFloat width = CMTimeGetSeconds(currentTime) / MAX_VIDEO_DUR *     self.nodesAllWidth;
    CGFloat progress  = width/self.progressWidth;
    
    if (width >= self.progressWidth) {
        
        progress = 1;
        [self recordPause];
    }
    
    if (self.updateIndex < 0) {
        [self.progressBar setLastProgressToWidth:width-0.5];
        self.timeLabel.text = [NSString stringWithFormat:@"%.1f秒",time];
    }
    [self.recordingView updateLabelText:progress * MAX_VIDEO_DUR/self.nodesFolat];
    [self.recordingView setValue:progress];
}
/**
 录制一段视频后的结果
 */
- (void)recorder:(SCRecorder *__nonnull)recorder didCompleteSegment:(SCRecordSessionSegment *__nullable)segment inSession:(SCRecordSession *__nonnull)session error:(NSError *__nullable)error;
{
    if (self.updateIndex > -1) {
        [self insertVideoUrl:segment.url atIndex:self.updateIndex isRecorder:YES];
    }
}

//录制完成
- (void)recorder:(SCRecorder *)recorder didCompleteSession:(SCRecordSession *)recordSession {
    MMLog(@"didCompleteSession:");
    
    [self saveAndShowSession:recordSession];
    [self updateViewState];
    
}
#pragma mark  ----YBPopupMenuDelegate----
/**
 点击事件回调
 */
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu;
{
    self.nodesFolat = index + 1;
    [self updateProgress];
}
/**
 添加视频
 
 @param url 视频链接
 @param segmentIndex 插入序列
 @param recorder 是否是录制的
 */
- (void)insertVideoUrl:(NSURL *)url atIndex:(NSInteger)segmentIndex isRecorder:(BOOL)recorder;
{
    SCRecordSessionSegment *seg;
    if (recorder == YES) {
        NSLog(@" --- %ld",self.recorder.session.segments.count);
        seg = [self.recorder.session.segments.lastObject copy];
        [self.recorder.session removeLastSegment];
        NSLog(@" +++ %ld",self.recorder.session.segments.count);
    }
    else
    {
       seg = [SCRecordSessionSegment segmentWithURL:url info:nil];
    }
    [self.recorder.session insertSegment:seg atIndex:segmentIndex];
    NSInteger segments = self.recorder.session.segments.count-1;
    
    if (segmentIndex < segments) {
        
        [self.recorder.session removeSegmentAtIndex:segmentIndex+1 deleteFile:YES];
    }
    else
    {
        [self.progressBar addProgressView];
        [self.progressBar setLastProgressToWidth:self.progressWidth];
    }
    
    [self updateViewState];
    self.updateIndex = -1;
}
@end
