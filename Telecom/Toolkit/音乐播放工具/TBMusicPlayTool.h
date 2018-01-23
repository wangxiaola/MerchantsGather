//
//  TBMusicPlayTool.h
//  Telecom
//
//  Created by 王小腊 on 2018/1/22.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBMusicPlayTool : NSObject

+ (instancetype)sharedAVAudioPlayer;
// 通过传递的歌曲名称进行播放
- (void)playMusicWithMusicUrl:(NSURL *)url;
// 开始或暂停
- (void)playOrStopMusic;
// 销毁
- (void)destruction;

@end
