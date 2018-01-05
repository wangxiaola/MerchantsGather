//
//  TBBossRecordingView.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/17.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBossRecordingView.h"
#import "Mp3Recorder.h"
#import "SpectrumView.h"
#import "TBBossVoiceImageView.h"
#import "TBMoreReminderView.h"
#import "TBVoiceProgressView.h"
#import <AVFoundation/AVFoundation.h>

/**
 录制状态
 
 - RecordingVoiceStateOn: 没有任何东西
 - RecordingVoiceStateProcess: 录制中
 - RecordingVoiceStateEnd: 录制结束
 - RecordingVoiceStatePlay: 播放中
 */
typedef NS_ENUM(NSInteger ,RecordingVoiceState) {
    
    RecordingVoiceStateOn = 0,
    RecordingVoiceStateProcess,
    RecordingVoiceStateEnd,
    RecordingVoiceStatePlay
};

static NSString *no_Voice = @"boss_voice_0";
static NSString *state_Voice = @"boss_voice_1";
static NSString *play_Voice = @"boss_voice_2";

static NSString *recording_a = @" 点击上方按钮，录制语音 ";
static NSString *recording_b = @" 语音录制中，点击完成录制 ";
static NSString *recording_c = @" 点击试听语音 ";
static NSString *recording_d = @" 不满意，点击 ";

static double maxTimer = 60;

@interface TBBossRecordingView ()<Mp3RecorderDelegate,AVAudioPlayerDelegate>

{
    TBVoiceProgressView *_progressView;
    TBBossVoiceImageView *centerImageView;
    UILabel *voicePromptLabel;
    UIButton *deleteButton;
    Mp3Recorder *recorderTool;//录音工具
    SpectrumView *spectrumView;
    RecordingVoiceState recordingVoiceState;
}
//音频文件 data url
@property (nonatomic, strong) id voiceData;
@property (nonatomic, strong) AVAudioPlayer *play;
@property (nonatomic, strong) NSString *voiceTimer;

@end
@implementation TBBossRecordingView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        recorderTool = [[Mp3Recorder alloc] initWithDelegate:self];
        recorderTool.recorder.meteringEnabled = YES;
        //   画圆环
        float progressWidth = _SCREEN_WIDTH/3+8;
        _progressView = [[TBVoiceProgressView alloc] initWithFrame:CGRectMake(0, 0, progressWidth, progressWidth)];
        _progressView.arcColor = NAVIGATION_COLOR;
        _progressView.backColor = [UIColor clearColor];
        _progressView.dialColor = NAVIGATION_COLOR;
        _progressView.arcRadius = progressWidth/2;
        _progressView.minNum = 2;
        _progressView.arcThickness = 5;
        _progressView.maxNum = 5;
        _progressView.userInteractionEnabled = YES;
        _progressView.hidden = YES;
        
        centerImageView = [[TBBossVoiceImageView alloc] initWithImage:[UIImage imageNamed:no_Voice]];
        centerImageView.userInteractionEnabled = YES;
        centerImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:centerImageView];
        [self addSubview:_progressView];
        
        UITapGestureRecognizer *zer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerImageViewTuchClick)];
        [_progressView addGestureRecognizer:zer];
        
        UITapGestureRecognizer *zerImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerImageViewTuchClick)];
        [centerImageView addGestureRecognizer:zerImage];
        
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.userInteractionEnabled = YES;
        [self addSubview:bottomView];
        
        voicePromptLabel = [[UILabel alloc] init];
        voicePromptLabel.textColor = [UIColor grayColor];
        voicePromptLabel.text = recording_a;
        voicePromptLabel.font = [UIFont systemFontOfSize:16 weight:0.1];
        [bottomView addSubview:voicePromptLabel];
        
        deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setTitle:@"重新录制" forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        deleteButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [deleteButton addTarget:self action:@selector(delegateClick) forControlEvents:UIControlEventTouchUpInside];
        deleteButton.backgroundColor = [UIColor orangeColor];
        deleteButton.layer.cornerRadius = 4;
        [bottomView addSubview:deleteButton];
        
        spectrumView = [[SpectrumView alloc] initWithFrame:CGRectMake(0, 0, (_SCREEN_WIDTH/3)+40, 50)];
        spectrumView.itemColor = [UIColor orangeColor];
        spectrumView.timeLabel.font = [UIFont systemFontOfSize:15];
        spectrumView.timeLabel.textColor = [UIColor grayColor];
        spectrumView.text = [NSString stringWithFormat:@"%d",0];
        spectrumView.hidden = YES;
        __weak SpectrumView * weakSpectrum = spectrumView;
        __weak Mp3Recorder *mp3Recorder = recorderTool;
        TBWeakSelf
        spectrumView.itemLevelCallback = ^() {
            
            if (recordingVoiceState == RecordingVoiceStateProcess) {
                [mp3Recorder.recorder updateMeters];
                //取得第一个通道的音频，音频强度范围时-160到0
                float power = [mp3Recorder.recorder averagePowerForChannel:0];
                weakSpectrum.level = power;
            }
            else
            {
                if (recordingVoiceState == RecordingVoiceStatePlay)
                {
    
                float number = weakSelf.play.duration-weakSelf.play.currentTime;
                 weakSpectrum.text = [weakSelf getMMSSFromSS:number];
                }
                else
                {
                    if (weakSelf.voiceTimer)
                    {
                        [weakSpectrum setText:weakSelf.voiceTimer];
                    }
                }
                weakSpectrum.level = -40;
            }
        };
        
        [self addSubview:spectrumView];
        
        [spectrumView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(weakSelf.mas_centerX);
            make.width.equalTo(@(_SCREEN_WIDTH/3+40));
            make.height.equalTo(@40);
            make.top.equalTo(self.mas_top).offset(0);
            
        }];

        [centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.mas_centerX);
            make.top.mas_equalTo(spectrumView.mas_bottom).offset(6);
            make.width.height.equalTo(@(_SCREEN_WIDTH/3));
        }];
        
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.height.mas_equalTo(progressWidth);
            make.center.equalTo(centerImageView);
            
        }];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.mas_centerX);
            make.top.equalTo(centerImageView.mas_bottom).offset(12);
            make.height.equalTo(@30);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(0);
        }];
        [voicePromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(bottomView);
        }];
        [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(bottomView);
            make.left.equalTo(voicePromptLabel.mas_right);
            make.width.equalTo(@0);
        }];
        
        
    }
    
    return self;
}
#pragma mark --赋值--
- (void)assignmentVoiceData:(id)data;
{
    self.voiceData = data;
    if (self.voiceData)
    {
        if ([self.voiceData isKindOfClass:[NSData class]])
        {
            [self localMusic];
        }
        else
        {
            NSString *url = data;
            if (![url containsString:IMAGE_URL])
            {
                url = [NSString stringWithFormat:@"%@%@",IMAGE_URL,url];
            }
            NSURL *voiceURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:voiceURL options:nil];
            CMTime audioDuration = audioAsset.duration;
            float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
           // 判断 audioDurationSeconds 是不是 Nan
            if (isnan(audioDurationSeconds))
            {
                [self assignmentVoiceData:data];
            }
            else
            {
                [self updataSchedule:audioDurationSeconds];
            }

        }
        [self setViewStyle:RecordingVoiceStateEnd];
    }
}

#pragma mark ---click ---
- (void)delegateClick
{
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"亲，是否要重新录制声音？"];
    [more showHandler:^{
        [self startRecording];
    }];

}
// 开始录制
- (void)startRecording
{
    _play.delegate = nil;
    _play = nil;
    self.voiceData = nil;
    if ([self.delegate respondsToSelector:@selector(deleteTheAudio)]) {
        [self.delegate deleteTheAudio];
    }
    [self setViewStyle:RecordingVoiceStateProcess];
    [recorderTool startRecord];
}
- (void)centerImageViewTuchClick
{
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        //7.0第一次运行会提示，是否允许使用麦克风
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        //AVAudioSessionCategoryPlayAndRecord用于录音和播放
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(session == nil)
            [UIView addMJNotifierWithText:@"请打开麦克风权限！" dismissAutomatically:YES];
        else
            [session setActive:YES error:nil];
         [self voiceOperation:recordingVoiceState];
    }
    else
    {
        [self voiceOperation:recordingVoiceState];
        
    }
}
- (void)stopAudio;
{
    if (recordingVoiceState == RecordingVoiceStateOn)
    {//没有任何东西
        
    }
    else if (recordingVoiceState == RecordingVoiceStateProcess)
    {//录制中
    
        [self voiceOperation:recordingVoiceState];
    }
    else if (recordingVoiceState == RecordingVoiceStateEnd)
    {//录制结束
        
        
    }
    else if (recordingVoiceState == RecordingVoiceStatePlay)
    {//播放中
        [self voiceOperation:recordingVoiceState];
    }

}
#pragma mark ---Mp3RecorderDelegate--
//失败
- (void)failRecord;
{
    [self dataErr];
}
//开始转换
- (void)beginConvert;
{
    hudShowLoading(@"音频处理中");
}
- (void)recording:(float)recordTime volume:(float)volume;
{
    if (recordTime < maxTimer+1)
    {
        _voiceTimer =  [self getMMSSFromSS:recordTime];
        spectrumView.text = _voiceTimer;
        float value = recordTime/maxTimer;
        [_progressView moveCircleToAngle:value*360];
    }
}
- (void)endConvertWithData:(NSData *)voiceData;
{
    hudShowSuccess(@"录制结束");
    self.voiceData = voiceData;
    [self setViewStyle:RecordingVoiceStateEnd];
    if ([self.delegate respondsToSelector:@selector(recorderOverData:)])
    {
        [self.delegate  recorderOverData:voiceData];
    }
    
}
//传入 秒  得到  xx分钟xx秒
-(NSString *)getMMSSFromSS:(NSInteger )totalTime{
    
    if (totalTime>60)
    {
        totalTime = 60;
    }
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",(long)(totalTime/60)];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",(long)(totalTime%60)];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
    
}
#pragma mark ---RecordingVoiceState--
- (void)voiceOperation:(RecordingVoiceState)state
{
    
    switch (state) {
        case RecordingVoiceStateOn:
            
            [recorderTool startRecord];
            [self setViewStyle:RecordingVoiceStateProcess];
            
            break;
        case RecordingVoiceStateProcess:
            [recorderTool stopRecord];
            [self setViewStyle:RecordingVoiceStateEnd];
            break;
        case RecordingVoiceStateEnd:
            //播放
            if (self.voiceData)
            {
                [self voicePlay:self.voiceData];
            }
            else
            {
                [self dataErr];
            }
            
            break;
        case RecordingVoiceStatePlay:
            //停止播放
            [_play pause];
            [self setViewStyle:RecordingVoiceStateEnd];
            break;
            
        default:
            break;
    }
    
}
// 音频异常报错
- (void)dataErr
{
    hudShowError(@"音频时长太短了");
    self.voiceData = nil;
    [self setViewStyle:RecordingVoiceStateOn];
    
    if ([self.delegate respondsToSelector:@selector(deleteTheAudio)]) {
        [self.delegate deleteTheAudio];
    }
    
}
- (void)setViewStyle:(RecordingVoiceState)state
{
    recordingVoiceState = state;
    
    BOOL isHidden = YES;
    BOOL isSpeViewHidden = YES;
    BOOL isShowProgressView = YES;
    NSString *imageName = no_Voice;
    CGFloat buttonWidth = 0.0f;
    NSString *promptString = recording_a;
    
    switch (state) {
        case RecordingVoiceStateOn:
            self.voiceData = nil;
            isHidden = YES;
            isSpeViewHidden = YES;
            isShowProgressView = YES;
            imageName = no_Voice;
            buttonWidth = 0.0f;
            promptString = recording_a;
            
            break;
        case RecordingVoiceStateProcess:
            
            isHidden = NO;
            isShowProgressView = NO;
            isSpeViewHidden = NO;
            imageName = state_Voice;
            buttonWidth = 0.0f;
            promptString = recording_b;
            
            break;
        case RecordingVoiceStateEnd:
            
            if (self.voiceData)
            {
                isSpeViewHidden = NO;
                isHidden = YES;
                isShowProgressView = NO;
                imageName = play_Voice;
                buttonWidth = 80.0f;
                promptString = recording_c;
            }
            else
            {
                [self setViewStyle:RecordingVoiceStateOn];
            }
            
            break;
        case RecordingVoiceStatePlay:
            isSpeViewHidden = NO;
            isShowProgressView = NO;
            isHidden = YES;
            imageName = state_Voice;
            buttonWidth = 80.0f;
            promptString = recording_d;
            
            break;
            
        default:
            break;
    }

    [spectrumView hiddenAmplitude:isHidden];
    _progressView.hidden = isShowProgressView;
    spectrumView.hidden = isSpeViewHidden;
    
    centerImageView.image = [UIImage imageNamed:imageName];
    voicePromptLabel.text = promptString;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(buttonWidth);
            }];
        });
        [deleteButton layoutIfNeeded];
    }];
    
}
#pragma mark  －－－音频播放---
- (void)voicePlay:(id)voiceData;
{
    if ([voiceData isKindOfClass:[NSData class]])
    {
        self.voiceData = voiceData;
        [self localMusic];
        [self.play play];
        [self setViewStyle:RecordingVoiceStatePlay];
    }
    else
    {
        NSString *url = voiceData;
        if (![url containsString:IMAGE_URL])
        {
            url = [NSString stringWithFormat:@"%@%@",IMAGE_URL,url];
        }
        NSURL *pURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //2.根据URL创建请求
        hudShowLoading(@"下载中");
        NSURLRequest *request = [NSURLRequest requestWithURL:pURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:8];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             if (!connectionError)
             {
                 hudDismiss();
                 [self voicePlay:data];
             }
             else
             {
                 [self dataErr];
             }
         }];
    }
    
}
- (void)localMusic
{
    if (_play == nil)
    {
        _play = [[AVAudioPlayer alloc]initWithData:self.voiceData error:nil];
        _play.delegate = self;
        _play.volume = 1.0f;
    
        [self updataSchedule:_play.duration];
    }
}
// 更新时间显示
- (void)updataSchedule:(double)time
{
    if (time>60)
    {
        time = 60;
    }
    _voiceTimer = [self getMMSSFromSS:time];
    float value = time/maxTimer;
    [_progressView moveCircleToAngle:value*360];
}
#pragma mark - AVAudioPlayerDelegate

// 音频播放完成时
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)fla
{
    [self setViewStyle:RecordingVoiceStateEnd];
    
}
// 解码错误

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    
    hudShowError(@"解码错误！");
    [self setViewStyle:RecordingVoiceStateEnd];
}

// 当音频播放过程中被中断时

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    
    [player pause];
    hudDismiss();
    [self setViewStyle:RecordingVoiceStateEnd];
    
}
// 当中断结束时

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    
    if (player != nil){
        [player play];
    }
    hudDismiss();
    [self setViewStyle:RecordingVoiceStatePlay];
}



@end
