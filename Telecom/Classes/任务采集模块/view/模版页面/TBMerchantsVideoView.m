//
//  TBMerchantsVideoView.m
//  Telecom
//
//  Created by 王小腊 on 2017/12/20.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBMerchantsVideoView.h"
#import "TBVideoShootingController.h"
#import "TBRecordVideoMode.h"
#import "TBMoreReminderView.h"
#import "ZKNavigationController.h"
#import "TBVideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface TBMerchantsVideoView ()
{
    CGFloat _videoHeigth;
}
@property (nonatomic, strong) UIView      *videoBackView;
@property (nonatomic, strong) UIImageView *videoBackImageView;
@property (nonatomic, strong) UIButton    *playStateButton;
@property (nonatomic, strong) UILabel     *timeLabel;

@property (nonatomic, strong) TBRecordVideoMode *videoMode;
@end

@implementation TBMerchantsVideoView
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)init
{
    
    self = [super init];
    
    if (self)
    {
        [self setPlayerView];
        [self addVideoNotificationCenter];
    }
    return self;
}
#pragma mark  ----设置视频播放器----
- (void)setPlayerView
{
    
    UIView *promptBackView = [[UIView alloc] init];
    promptBackView.backgroundColor = [UIColor whiteColor];
    [self addSubview:promptBackView];
    
    UIButton *promptTagView = [UIButton buttonWithType:UIButtonTypeCustom];
    [promptTagView setTitle:@" 提示" forState:UIControlStateNormal];
    [promptTagView setImage:[UIImage imageNamed:@"task_bt"] forState:UIControlStateNormal];
    [promptTagView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    promptTagView.titleLabel.font = [UIFont systemFontOfSize:15];
    [promptBackView addSubview:promptTagView];
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.text = @"  拍摄小视频能更好的展示您的店铺，这样就会有更多的网友积极主动的帮您分享传播哦！";
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.textColor = [UIColor blackColor];
    promptLabel.numberOfLines = 0;
    [promptBackView addSubview:promptLabel];
    
    CGFloat videoWidth = _SCREEN_WIDTH - 20;
    CGFloat videoHeigth = videoWidth*9/16;
    _videoHeigth = videoHeigth;
    
    UIView *videoBackView = [[UIView alloc] init];
    videoBackView.backgroundColor = [UIColor whiteColor];
    videoBackView.layer.masksToBounds = YES;
    videoBackView.clipsToBounds       = YES;
    videoBackView.layer.cornerRadius  = 4;
    [self addSubview:videoBackView];
    self.videoBackView = videoBackView;
    
    self.videoBackImageView = [[UIImageView alloc] init];
    self.videoBackImageView.backgroundColor = RGB(213, 213, 213);
    self.videoBackImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.videoBackImageView.userInteractionEnabled = YES;
    [videoBackView addSubview:self.videoBackImageView];
    
    
    self.playStateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playStateButton setImage:[UIImage imageNamed:@"video_xj"] forState:UIControlStateNormal];
    [self.playStateButton addTarget:self action:@selector(playStateClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoBackImageView addSubview:self.playStateButton];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [videoBackView addSubview:self.timeLabel];
    
    UIButton *deleteButton = [self createButtonText:@"删除视频"];
    [deleteButton addTarget:self action:@selector(deleteVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.videoBackView addSubview:deleteButton];
    
    UIButton *shootingButton = [self createButtonText:@"重新拍摄"];
    [shootingButton addTarget:self action:@selector(shootingVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.videoBackView addSubview:shootingButton];
    
    UIButton *playButton = [self createButtonText:@"播放视频"];
    [playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.videoBackView addSubview:playButton];
    
    UIView *linview_one = [[UIView alloc] init];
    linview_one.backgroundColor = RGB(213, 213, 213);
    [self.videoBackView addSubview:linview_one];
    
    UIView *linview_two = [[UIView alloc] init];
    linview_two.backgroundColor = RGB(213, 213, 213);
    [self.videoBackView addSubview:linview_two];
    
    TBWeakSelf
    
    [promptBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf).offset(10);
        make.right.equalTo(weakSelf.mas_right).offset(-10);
    }];
    [promptTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(promptBackView).offset(10);
        make.height.equalTo(@16);
    }];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.videoBackImageView.mas_left).offset(10);
        make.right.equalTo(weakSelf.videoBackImageView.mas_right).offset(-10);
        make.width.mas_equalTo(_SCREEN_WIDTH-20);
        make.top.equalTo(promptTagView.mas_bottom).offset(6);
        make.bottom.equalTo(promptBackView.mas_bottom).offset(-8);
    }];
    
    [videoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(10);
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.top.equalTo(promptBackView.mas_bottom).offset(10);
        make.height.mas_equalTo(videoHeigth);
    }];
    [self.videoBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(videoBackView);
        make.height.mas_equalTo(videoHeigth);
    }];
    [self.playStateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.videoBackImageView);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf.videoBackImageView);
        make.height.equalTo(@30);
    }];
    
    [linview_one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.videoBackView.mas_left).offset(videoWidth/3);
        make.width.equalTo(@1.5);
        make.top.equalTo(weakSelf.videoBackImageView.mas_bottom).offset(15);
        make.height.equalTo(@20);
        
    }];
    
    [linview_two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.videoBackView.mas_right).offset(-videoWidth/3);
        make.width.equalTo(@1.5);
        make.top.equalTo(weakSelf.videoBackImageView.mas_bottom).offset(15);
        make.height.equalTo(@20);
        
    }];
    
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.videoBackView);
        make.top.equalTo(weakSelf.videoBackImageView.mas_bottom);
        make.right.equalTo(linview_one.mas_left);
        make.height.equalTo(@50);
    }];
    
    [shootingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.videoBackImageView.mas_bottom);
        make.left.equalTo(linview_one.mas_right);
        make.right.equalTo(linview_two.mas_left);
        make.height.equalTo(@50);
    }];
    
    [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.videoBackView);
        make.top.equalTo(weakSelf.videoBackImageView.mas_bottom);
        make.left.equalTo(linview_two.mas_right);
        make.height.equalTo(@50);
    }];
}

/**
 添加视频录制通知
 */
- (void)addVideoNotificationCenter
{
    //获取通知中心单例对象
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoInfoNotificationAction:) name:Verification_video object:nil];
}

#pragma mark  ----点击事件----
// 视频中心按钮点击事件
- (void)playStateClick:(UIButton *)sender
{
    if (self.videoMode.videoPath.length == 0)
    {
        [self shootingVideo];
    }
    else
    {
        [self playVideo];
    }
}
/**
 拍摄视频
 */
- (void)shootingVideo
{
    TBVideoShootingController *vc = [[TBVideoShootingController alloc] init];
    vc.videoName = [self.makingList.infoDic valueForKey:@"name"];
    vc.videoID = self.makingList.modelsID + self.makingList.merchantsID;
    ZKNavigationController *nav = [[ZKNavigationController alloc] initWithRootViewController:vc];
    [[ZKUtil getPresentedViewController] presentViewController:nav animated:YES completion:nil];
}
/**
 删除视频
 */
- (void)deleteVideo
{
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"确定要删除此视频吗？"];
    TBWeakSelf
    [more showHandler:^{
        weakSelf.videoMode = [[TBRecordVideoMode alloc] init];
        [weakSelf updateVideoViewMode:weakSelf.videoMode];
    }];
    
}
/**
 播放视频
 */
- (void)playVideo
{
    NSString *url = @"";
    if ([self.videoMode.videoPath containsString:is_IMAGE_URL])
    {
        url = [NSString stringWithFormat:@"%@%@",IMAGE_URL,self.videoMode.videoPath];
    }
    else
    {
        NSString *path = NSTemporaryDirectory();
        url = [NSString stringWithFormat:@"file:///%@%@",path,self.videoMode.videoPath];
    }
    
    TBVideoPlayerViewController *vc = [[TBVideoPlayerViewController alloc] init];
    vc.videoPath = url;
    [[ZKUtil getPresentedViewController] presentViewController:vc animated:YES completion:nil];
}
- (void)videoInfoNotificationAction:(NSNotification *)notification{
    
    TBRecordVideoMode *mode = notification.object;
    self.videoMode = mode;
    [self updateVideoViewMode:mode];
}
#pragma mark  ----fun tool----
- (UIButton *)createButtonText:(NSString *)text
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    return button;
}

/**
 更新视频视图
 
 @param mode 数据模型
 */
- (void)updateVideoViewMode:(TBRecordVideoMode *)mode
{
    CGFloat videoHeight;
    NSString *playImageName;
    
    if (mode.videoPath.length > 0) {
        
        videoHeight = _videoHeigth + 50;
        playImageName = @"ship.icon";
        self.timeLabel.text = [NSString stringWithFormat:@"  %@",mode.videoTime];
        self.timeLabel.hidden = NO;
        
        if (mode.coverImage) {
            self.videoBackImageView.image = mode.coverImage;
        }
        else
        {
            [ZKUtil downloadImage:self.videoBackImageView imageUrl:mode.coverUrl];
        }
    }
    else
    {
        videoHeight = _videoHeigth;
        playImageName = @"video_xj";
        self.timeLabel.hidden = YES;
        self.videoBackImageView.image = [UIImage imageNamed:@""];
    }
    
    
    [self.playStateButton setImage:[UIImage imageNamed:playImageName] forState:UIControlStateNormal];
    [self.videoBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(videoHeight);
    }];
    
}
#pragma mark  ----父类方法----
/**
 数据更新
 
 @param makingList 数据
 @return 标题字典
 */
- (NSDictionary *)updataData:(TBMakingListMode *)makingList;
{
    self.makingList = makingList;
    
    self.videoMode = [TBRecordVideoMode mj_objectWithKeyValues:makingList.videoDictionary];
    
    if (makingList.videoData)
    {
        self.videoMode.coverImage = [UIImage imageWithData:makingList.videoData];
        
    }
    
    if ([self.videoMode.videoPath containsString:is_IMAGE_URL]) {
        [self updateVideoViewMode:self.videoMode];
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *path = NSTemporaryDirectory();
            NSString * url = [NSString stringWithFormat:@"%@%@",path,self.videoMode.videoPath];
            NSData *data = [NSData dataWithContentsOfFile:url];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!data) {
                 self.videoMode = [[TBRecordVideoMode alloc] init];
                }
                [self updateVideoViewMode:self.videoMode];
            });
        });
        
        
        [self updateVideoViewMode:self.videoMode];
    }

    return @{@"name":@"商户视频",@"prompt":@""};
}
/**
 数据提交
 
 @param prompt 是否提示
 @return yes 可以进行下一步
 */
- (BOOL)updataMakingIsPrompt:(BOOL)prompt;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.videoMode.videoPath.length > 0)
    {
        [dic setValue:self.videoMode.videoPath forKey:@"videoPath"];
    }
    if (self.videoMode.videoTime.length > 0)
    {
        [dic setValue:self.videoMode.videoTime forKey:@"videoTime"];
    }
    if (self.videoMode.coverUrl.length > 0)
    {
        [dic setValue:self.videoMode.coverUrl forKey:@"coverUrl"];
    }
    self.makingList.videoDictionary = dic.copy;
    // 销毁
    [dic removeAllObjects];
    dic = nil;
    
    self.makingList.videoData = nil;
    if (self.videoMode.coverImage)
    {
        self.makingList.videoData = UIImagePNGRepresentation(self.videoMode.coverImage);
    }
    return YES;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
