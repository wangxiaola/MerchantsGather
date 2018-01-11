//
//  TBVideoEditingViewController.m
//  laziz_Merchant
//
//  Created by biyuhuaping on 2017/4/19.
//  Copyright © 2017年 XBN. All rights reserved.
//  视频详情

#import "TBVideoEditingViewController.h"
#import "AWCollectionViewDialLayout.h"
#import "JXVideoImagePickerViewController.h"
#import "LZVideoTools.h"
#import "TBMoreReminderView.h"
#import "TBCaptureUtilities.h"
#import "TBFilterCollectionViewCell.h"
#import "TBVideoRecordingView.h"
#import "TBWatermarkOverlayView.h"
#import <AssetsLibrary/AssetsLibrary.h>
static NSString * const cellID = @"cellID";

@interface TBVideoEditingViewController ()<SCPlayerDelegate,UICollectionViewDataSource, UICollectionViewDelegate>
{
    CGFloat cell_height;
    NSString *_videoPath;
    NSString *_recordingPath;
}

@property (weak, nonatomic) IBOutlet UIView *collectionBackView;
@property (strong, nonatomic) IBOutlet SCSwipeableFilterView *filterSwitcherView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SCSwipeableFilterViewHeight;
@property (weak, nonatomic) IBOutlet UIView *confirmView;
@property (strong, nonatomic) SCPlayer *player;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) AWCollectionViewDialLayout *dialLayout;
@property (weak, nonatomic) IBOutlet UIButton *recordingButton;

@property (nonatomic, strong) NSArray *filtrtNames;
@end

@implementation TBVideoEditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"视频编辑";
    self.edgesForExtendedLayout = UIRectEdgeNone;// 推荐使用
    
    self.SCSwipeableFilterViewHeight.constant = _SCREEN_WIDTH*9/16;
    self.confirmView.layer.cornerRadius = CGRectGetWidth(self.confirmView.frame)/2;
    self.confirmView.layer.masksToBounds = YES;
    _videoPath = @"";
    
    [self maskColors];
    [self createMaskViews];
}
#pragma mark  ----蒙版创建区域----
/**
 蒙版图层颜色创建
 */
- (void)maskColors
{
    
    _player = [SCPlayer player];
    [self.player setLoopEnabled:YES];
    
    self.filterSwitcherView.selectFilterScrollView.userInteractionEnabled = NO;
    self.filterSwitcherView.selectFilterScrollView.backgroundColor = [UIColor clearColor];
    SCFilter *emptyFilter = [SCFilter emptyFilter];
    emptyFilter.name = @"#nofilter";
    
    SCFilter *CIPhotoEffectNoir =   [SCFilter filterWithCIFilterName:@"CIPhotoEffectNoir"];
    
    SCFilter *CIPhotoEffectChrome =   [SCFilter filterWithCIFilterName:@"CIPhotoEffectChrome"];
    
    SCFilter *CIPhotoEffectInstant =   [SCFilter filterWithCIFilterName:@"CIPhotoEffectInstant"];
    
    SCFilter *CIPhotoEffectTonal =   [SCFilter filterWithCIFilterName:@"CIPhotoEffectTonal"];
    
    SCFilter *CIPhotoEffectFade =  [SCFilter filterWithCIFilterName:@"CIPhotoEffectFade"];
    
    SCFilter *cisf =  [SCFilter filterWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"a_filter" withExtension:@"cisf"]];
    
    SCFilter *dtFilter =  [self createAnimatedFilter];
    
    self.filterSwitcherView.filters = @[
                                        emptyFilter,// 默认
                                        CIPhotoEffectNoir,//黑色
                                        CIPhotoEffectChrome,
                                        CIPhotoEffectInstant,
                                        CIPhotoEffectTonal,
                                        CIPhotoEffectFade,
                                        // Adding a filter created using CoreImageShop
                                        cisf,
                                        dtFilter
                                        ];
    self.filtrtNames = @[@"默认",@"黑白",@"铬黄",@"怀旧",@"色调",@"淡化",@"清新",@"渐变"];
    self.player.SCImageView = self.filterSwitcherView;
}
/**
 更新视频蒙版
 
 @param row 第几个蒙版
 */
- (void)updateVideoMakeIndex:(NSInteger)row
{
    _videoPath = @"";
    [self.filterSwitcherView.selectFilterScrollView setContentOffset:CGPointMake(_SCREEN_WIDTH * row, 0) animated:YES];
    
    if (self.filterSwitcherView.filters.count > row)
    {
        SCFilter *filtel = self.filterSwitcherView.filters[row];
        
        [self.filterSwitcherView scrollToFilter:filtel animated:YES];
        
    }
}
#pragma mark  ----蒙版选择器创建----
/**
 蒙版选择器视图创建
 */
- (void)createMaskViews
{
    CGFloat radius = 0.38 * 1000;
    CGFloat angularSpacing = 0.16 * 90;
    CGFloat xOffset = 0.23 * 320;
    CGFloat cell_width = 240;
    cell_height = 100;
    
    
    self.dialLayout = [[AWCollectionViewDialLayout alloc] initWithRadius:radius andAngularSpacing:angularSpacing andCellSize:CGSizeMake(cell_width, cell_height) andAlignment:WHEELALIGNMENTCENTER andItemHeight:cell_height andXOffset:xOffset];
    self.dialLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.dialLayout setShouldSnap:YES];
    
    // 创建图层选择器
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.collectionBackView.frame.size.height, _SCREEN_WIDTH) collectionViewLayout:self.dialLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.bounces = YES;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = YES;
    
    [self.collectionView registerClass:[TBFilterCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    
    [self.collectionBackView addSubview:self.collectionView];
    
    [self layoutExample];
    
}
//frame配置
- (void)layoutExample
{
    CGFloat radius = 0 ,angularSpacing  = 0, xOffset = 0;
    
    [self.dialLayout setCellSize:CGSizeMake(80, 110)];
    [self.dialLayout setWheelType:WHEELALIGNMENTLEFT];
    [self.dialLayout setShouldFlip:NO];
    
    radius = 300;
    angularSpacing = 18;
    xOffset = 70;
    
    [self.dialLayout setDialRadius:radius];
    [self.dialLayout setAngularSpacing:angularSpacing];
    [self.dialLayout setXOffset:xOffset];
    [self.collectionView reloadData];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI/2);
    [self.collectionView setTransform:transform];
    self.collectionView.frame = CGRectMake(0, 0, _SCREEN_WIDTH, self.collectionBackView.frame.size.height);
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.player setItemByAsset:self.recordSession.assetRepresentingSegments];
    [self.player play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event
// 保存
- (IBAction)saveVideo:(UIButton *)sender
{
    [self saveToCameraRoll];
}
// 重置视频
- (IBAction)resetClick:(UIButton *)sender
{
    TBWeakSelf
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"确定还原视频操作？"];
    [more showHandler:^{
        _recordingPath = @"";
        [weakSelf updateVideoMakeIndex:0];
        [weakSelf.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
}
// 录音
- (IBAction)recordingClick:(UIButton *)sender
{
    if (_recordingPath.length > 0) {
        TBWeakSelf
        TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"亲！您已经录了一段声音，需要重新录制吗？"];
        
        [more showHandler:^{
            _recordingPath = @"";
            [weakSelf startRecording];
        }];
    }else
    {
       [self startRecording];
    }
}

/**
 开始录音
 */
- (void)startRecording{
    [_player pause];
    TBVideoRecordingView *recordingView = [[TBVideoRecordingView alloc] init];
    [recordingView showRecordingTime:self.videoTime.doubleValue success:^(NSString *recordPath) {
        
        [_player play];
        if (recordPath.length > 0) {
            
            _recordingPath = recordPath;
        }
    }];
}
#pragma mark  ----tool fun----
//创建动态滤镜
- (SCFilter *)createAnimatedFilter {
    SCFilter *animatedFilter = [SCFilter emptyFilter];
    animatedFilter.name = @"Animated Filter";
    
    SCFilter *gaussian = [SCFilter filterWithCIFilterName:@"CIGaussianBlur"];
    SCFilter *blackAndWhite = [SCFilter filterWithCIFilterName:@"CIColorControls"];
    
    [animatedFilter addSubFilter:gaussian];
    [animatedFilter addSubFilter:blackAndWhite];
    
    double duration = 0.5;
    double currentTime = 0;
    BOOL isAscending = YES;
    
    Float64 assetDuration = CMTimeGetSeconds(_recordSession.assetRepresentingSegments.duration);
    
    while (currentTime < assetDuration) {
        if (isAscending) {
            [blackAndWhite addAnimationForParameterKey:kCIInputSaturationKey startValue:@1 endValue:@0 startTime:currentTime duration:duration];
            [gaussian addAnimationForParameterKey:kCIInputRadiusKey startValue:@0 endValue:@10 startTime:currentTime duration:duration];
        } else {
            [blackAndWhite addAnimationForParameterKey:kCIInputSaturationKey startValue:@0 endValue:@1 startTime:currentTime duration:duration];
            [gaussian addAnimationForParameterKey:kCIInputRadiusKey startValue:@10 endValue:@0 startTime:currentTime duration:duration];
        }
        
        currentTime += duration;
        isAscending = !isAscending;
    }
    
    return animatedFilter;
}


/**
 保存到相机卷
 */
- (void)saveToCameraRoll
{
    if (_videoPath.length > 0)
    {
        [self pushCoverChooseControllerVideoPath:_videoPath];
        return;
    }
    hudShowLoading(@"视频正在处理");
    [_player pause];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    if (_recordingPath.length > 0) {
        
        NSURL *audioInputUrl = [NSURL fileURLWithPath:_recordingPath];
        TBWeakSelf
        // 合成音频
        [TBCaptureUtilities mergeVideo:self.recordSession.assetRepresentingSegments
                              andAudio:audioInputUrl
                               results:^(NSString *path, NSError *error)
         {
             
             [weakSelf mergedidFinish:path WithError:nil];
         }];
    }
    else
    {
        [self mergedidFinish:self.recordSession.assetRepresentingSegments WithError:nil];
        
    }
    
}
#pragma mark  ----视频合成----

/**
 最终合成视频保存
 
 @param video 视频 路径或AVAsset
 @param error 错误信息
 */
- (void)mergedidFinish:(id )video WithError:(NSError *)error
{
    SCFilter *currentFilter = [self.filterSwitcherView.selectedFilter copy];
    AVAsset *set;
    if ([video isKindOfClass:[NSString class]])
    {
        NSURL *url = [NSURL fileURLWithPath:video];
        if (!url) {
            [self promptExceptionInformation:@"视频合成异常！"];
            return;
        }
        set = [AVAsset assetWithURL:url];
    }
    else
    {
        set = video;
    }
    
    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:set];
    exportSession.videoConfiguration.filter = currentFilter;
    exportSession.videoConfiguration.preset = SCPresetHighestQuality;
    exportSession.audioConfiguration.preset = SCPresetHighestQuality;
    exportSession.videoConfiguration.maxFrameRate = 35;
    exportSession.outputUrl = self.recordSession.outputUrl;
    exportSession.audioConfiguration.enabled = YES;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.contextType = SCContextTypeAuto;
    
    TBWatermarkOverlayView *overlay = [TBWatermarkOverlayView new];
    overlay.date = self.recordSession.date;
    exportSession.videoConfiguration.overlay = overlay;
    
    CFTimeInterval time = CACurrentMediaTime();
    __weak typeof(self) wSelf = self;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        __strong typeof(self) strongSelf = wSelf;
        
        if (!exportSession.cancelled) {
            NSLog(@"Completed compression in %fs", CACurrentMediaTime() - time);
        }
        
        if (strongSelf != nil) {
            [strongSelf.player play];
        }
        
        NSError *error = exportSession.error;
        if (exportSession.cancelled) {
            NSLog(@"Export was cancelled");
        } else if (error == nil) {
            [exportSession.outputUrl saveToCameraRollWithCompletion:^(NSString * _Nullable path,
                                                                      NSError * _Nullable error) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                if (error == nil) {
                    
                    hudShowSuccess(@"已保存到相机卷");
                    _videoPath = path;
                    [self pushCoverChooseControllerVideoPath:path];
                } else {
                    [self promptExceptionInformation:@"保存失败！"];
                }
            }];
        } else {
            if (!exportSession.cancelled) {
                [self promptExceptionInformation:@"保存失败！"];
            }
        }
    }];
    
    
}
- (void)video:(NSString *)videoPath didFinishSavingWithUError:(NSError *)error contextInfo: (void *)contextInfo{
    if (error) {
        [self promptExceptionInformation:@"视频合成异常！"];
    }
}

/**
 异常提示
 
 @param msg 消息
 */
- (void)promptExceptionInformation:(NSString *)msg
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    hudShowError(msg);
}
/**
 push到封面图片选择VC
 
 @param path 视频路径
 */
- (void)pushCoverChooseControllerVideoPath:(NSString *)path
{
    hudDismiss();
    JXVideoImagePickerViewController *vc = [[JXVideoImagePickerViewController alloc]init];
    vc.videoPath = path;
    vc.videoTime = self.videoTime;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark  ----UICollectionViewDelete----
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.filterSwitcherView.filters.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TBFilterCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if (self.filterSwitcherView.filters.count > 0) {
        SCFilter *sc = self.filterSwitcherView.filters[indexPath.row];
        
        [cell setCellViewsFilter:sc.CIFilter filtrtName:self.filtrtNames[indexPath.row]];
    }
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    [self updateVideoMakeIndex:indexPath.row];
}
#pragma mark - UIScrollDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //    1、快速滚动，自然停止；2、快速滚动，手指按压突然停止；
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging &&    !scrollView.decelerating;
    if (scrollToScrollStop) {
        [self scrollViewDidEndScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        // 3、慢速上下滑动停止。
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {
            [self scrollViewDidEndScroll];
        }
    }
}

#pragma mark - scrollView 停止滚动监测
- (void)scrollViewDidEndScroll {
    
    // 将collectionView在控制器view的中心点转化成collectionView上的坐标
    CGPoint pInView = [self.collectionBackView convertPoint:self.collectionView.center toView:self.collectionView];
    // 获取这一点的indexPath
    NSIndexPath *indexPathNow = [self.collectionView indexPathForItemAtPoint:pInView];
    [self updateVideoMakeIndex:indexPathNow.row];
    
}

@end
