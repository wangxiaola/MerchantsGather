//
//  TBVideoPlayerViewController.m
//  Telecom
//
//  Created by 王小腊 on 2018/1/23.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBVideoPlayerViewController.h"
#import "UIView+WebVideoCache.h"

@interface TBVideoPlayerViewController ()<JPVideoPlayerDelegate>

@property (nonatomic, strong) UIView *videoContainer;
@end

@implementation TBVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    _videoContainer = ({
        UIView *videoView = [UIView new];
        videoView.backgroundColor = RGB(19, 21, 17);
        CGFloat screenWid = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = screenWid * 9.0 / 16.0;
        videoView.frame = CGRectMake(0, (_SCREEN_HEIGHT - screenHeight)/2, screenWid, screenHeight);
        [self.view addSubview:videoView];
        
        videoView;
    });
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.videoContainer addGestureRecognizer:tapGestureRecognizer];
    
    self.videoContainer.jp_videoPlayerDelegate = self;
    
    UIImage *image = [UIImage imageNamed:@"video_back"];
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton setImage:image forState:UIControlStateNormal];
    dismissButton.frame = CGRectMake((_SCREEN_WIDTH-image.size.width)/2, _SCREEN_HEIGHT-80, image.size.width, image.size.height);
    dismissButton.backgroundColor = [UIColor clearColor];
    [dismissButton addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissButton];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.videoContainer jp_playVideoWithURL:[NSURL URLWithString:_videoPath]];
    
    [self.videoContainer jp_perfersPlayingProgressViewColor:NAVIGATION_COLOR];
    [self.videoContainer jp_perfersDownloadProgressViewColor:[UIColor blackColor]];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.videoContainer jp_stopPlay];
}

- (void)dealloc{
    NSLog(@"JPVideoPlayerDemoVC_push 释放了");
}
- (void)dismissClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - Tap Event

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.videoContainer.viewStatus == JPVideoPlayerVideoViewStatusPortrait) {
            [self.videoContainer jp_gotoLandscapeAnimated:YES completion:nil];
        }
        else if (self.videoContainer.viewStatus == JPVideoPlayerVideoViewStatusLandscape) {
            [self.videoContainer jp_gotoPortraitAnimated:YES completion:nil];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
