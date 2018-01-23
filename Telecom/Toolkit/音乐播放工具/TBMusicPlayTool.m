//
//  TBMusicPlayTool.m
//  Telecom
//
//  Created by 王小腊 on 2018/1/22.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBMusicPlayTool.h"
#import <AVFoundation/AVFoundation.h>

static NSMutableDictionary *_players;

@interface TBMusicPlayTool ()

@property(nonatomic,strong) AVAudioPlayer *player;

@end

@implementation TBMusicPlayTool


-(instancetype)init{
    if (self == [super init]) {
        
    }
    return self;
}
#pragma mark 单例模式(避免同时播放多首歌)
+(instancetype)sharedAVAudioPlayer{
    static TBMusicPlayTool *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
#pragma mark 通过音乐名称播放音乐
- (void)playMusicWithMusicUrl:(NSURL *)url{
    
    _player = nil;
    // 2.1.获取对应音乐资源
    NSURL *fileUrl = url;
    
    if (fileUrl == nil) return;
    
    // 2.2.创建对应的播放器
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
    // 设置播放属性
    _player.numberOfLoops = -1; // 不循环
    // 2.4.准备播放
    [_player prepareToPlay];
    
    // 3.播放音乐
    [_player play];
}
-(void)playOrStopMusic{
    if ([_player isPlaying]) {
        [_player pause];
        return;
    }
    [_player play];
}
// 销毁
- (void)destruction
{
    [_player stop];
    _player = nil;
}

@end
