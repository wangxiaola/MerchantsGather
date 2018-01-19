//
//  TBPhotoVideoViewController.m
//  Telecom
//
//  Created by 王小腊 on 2018/1/2.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBPhotoVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface TBPhotoVideoViewController ()<AVPlayerViewControllerDelegate>
{
    AVPlayerViewController      *_playerController;
    AVPlayer                    *_player;
    AVAudioSession              *_session;
    NSString                    *_path;
}
@end

@implementation TBPhotoVideoViewController
- (id)initWithUrl:(NSString *)path; {
    self = [super init];
    if (self) {
        _path = path;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([_path containsString:is_IMAGE_URL]) {
        [self playVideoUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL,_path]]];
    }
    else
    {
        NSString *path = NSTemporaryDirectory();
        [self playVideoUrl:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@",path,_path]]];
    }
    
}
- (void)playVideoError
{
    hudShowError(@"视频播放异常");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)playVideoUrl:(NSURL *)url
{
    
    hudDismiss();
    _session = [AVAudioSession sharedInstance];
    [_session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    
    _player = [AVPlayer playerWithPlayerItem:item];
    _playerController = [[AVPlayerViewController alloc] init];
    _playerController.player = _player;
    _playerController.videoGravity = AVLayerVideoGravityResizeAspect;
    _playerController.delegate = self;
    _playerController.allowsPictureInPicturePlayback = true;    //画中画，iPad可用
    _playerController.showsPlaybackControls = true;
    
    [self addChildViewController:_playerController];
    _playerController.view.translatesAutoresizingMaskIntoConstraints = true;    //AVPlayerViewController 内部可能是用约束写的，这句可以禁用自动约束，消除报错
    _playerController.view.frame = self.view.bounds;
    [self.view addSubview:_playerController.view];
    
    [_playerController.player play];    //自动播放
}

- (NSDictionary *)getVideoInfoWithSourcePath:(NSString *)path{
    
    path = [path stringByReplacingOccurrencesOfString:@"file:///" withString:@""];
    AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    CMTime   time = [asset duration];
    int seconds = ceil(time.value/time.timescale);
    
    NSInteger   fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    
    return @{@"size" : @(fileSize),
             @"duration" : @(seconds)};
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
