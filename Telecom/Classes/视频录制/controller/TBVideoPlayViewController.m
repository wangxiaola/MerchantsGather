//
//  TBVideoPlayViewController.m
//  Telecom
//
//  Created by 王小腊 on 2018/1/19.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBVideoPlayViewController.h"
#import "WMPlayer.h"

@interface TBVideoPlayViewController ()<WMPlayerDelegate>{
    WMPlayer  *wmPlayer;
    CGRect     playerFrame;
    BOOL isHiddenStatusBar;//记录状态的隐藏显示
    NSString  *_path;
    
}
@property(nonatomic,assign) BOOL isRotateEable;//记录支不支持旋转
@end

@implementation TBVideoPlayViewController
- (id)initWithUrl:(NSString *)path; {
    self = [super init];
    if (self) {
        _path = path;
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden{
    if (isHiddenStatusBar) {//隐藏
        return YES;
    }
    return NO;
}
//视图控制器实现的方法
- (BOOL)shouldAutorotate{
    if (self.isRotateEable==NO) {
        return NO;
    }
    //是否允许转屏
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    
    UIInterfaceOrientationMask result = [super supportedInterfaceOrientations];
    //viewController所支持的全部旋转方向
    return result;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //对于present出来的控制器，要主动的更新一个约束，让wmPlayer全屏，更安全
    if (wmPlayer.isFullscreen == NO) {
        [wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([UIScreen mainScreen].bounds.size.height));
            make.height.equalTo(@([UIScreen mainScreen].bounds.size.width));
            make.center.equalTo(wmPlayer.superview);
        }];
        wmPlayer.isFullscreen = YES;
    }
    return UIInterfaceOrientationLandscapeRight;
}

/**
 消失
 */
- (void)dismissViewController
{
    [self releaseWMPlayer];
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark  ----WMPlayerDelegate----
///播放器事件
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn{
    
    [self dismissViewController];
}

///播放暂停
-(void)wmplayer:(WMPlayer *)wmplayer clickedPlayOrPauseButton:(UIButton *)playOrPauseBtn{
    NSLog(@"clickedPlayOrPauseButton");
}

///单击播放器
-(void)wmplayer:(WMPlayer *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap{
    
}
///双击播放器
-(void)wmplayer:(WMPlayer *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap{
    NSLog(@"didDoubleTaped");
}
//操作栏隐藏或者显示都会调用此方法
-(void)wmplayer:(WMPlayer *)wmplayer isHiddenTopAndBottomView:(BOOL)isHidden{
    isHiddenStatusBar = isHidden;
    [self setNeedsStatusBarAppearanceUpdate];
}
///播放状态
//播放失败的代理方法
-(void)wmplayerFailedPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state;
{
    hudShowError(@"视频播放失败！");
    [self dismissViewController];
}
//准备播放的代理方法
-(void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state;
{

}
//播放完毕的代理方法
-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer;
{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [super viewDidAppear:animated];
}
#pragma mark
#pragma mark viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.isRotateEable = NO;
    playerFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width)* 9 / 16);
    
    wmPlayer = [[WMPlayer alloc]init];
    wmPlayer.enableVolumeGesture = YES;
    wmPlayer.delegate = self;
    wmPlayer.fullScreenBtn.hidden = YES;
    if ([_path containsString:is_IMAGE_URL])
    {
        wmPlayer.URLString = [NSString stringWithFormat:@"%@%@",IMAGE_URL,_path];
    }
    else
    {
        NSString *path = NSTemporaryDirectory();
        wmPlayer.URLString = [NSString stringWithFormat:@"file:///%@%@",path,_path];
    }
    
    wmPlayer.titleLabel.text = self.title;
    wmPlayer.closeBtn.hidden = NO;
    wmPlayer.loadingView.backgroundColor = [UIColor whiteColor];
    wmPlayer.loadingView.color = [UIColor whiteColor];
    [wmPlayer.loadingView startAnimating];
    
    [self.view addSubview:wmPlayer];
    [wmPlayer play];
    
    [wmPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.height.equalTo(@(playerFrame.size.height));
    }];
    
   
}

- (void)releaseWMPlayer
{
    [wmPlayer pause];
    [wmPlayer removeFromSuperview];
    [wmPlayer.playerLayer removeFromSuperlayer];
    [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    wmPlayer.player = nil;
    wmPlayer.currentItem = nil;
    //释放定时器，否侧不会调用WMPlayer中的dealloc方法
    [wmPlayer.autoDismissTimer invalidate];
    wmPlayer.autoDismissTimer = nil;
    wmPlayer.playOrPauseBtn = nil;
    wmPlayer.playerLayer = nil;
    wmPlayer = nil;
}
- (void)dealloc
{
    [self releaseWMPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"DetailViewController deallco");
}
@end
