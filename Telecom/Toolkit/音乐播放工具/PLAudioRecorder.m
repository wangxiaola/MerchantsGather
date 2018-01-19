//
//  PLAudioRecorder.m
//  AudioDemo
//
//  Created by coderyi on 15/6/5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PLAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "lame.h"

NSString * const RecordErrorStart = @"RecordErrorStart";
NSString * const RecordErrorPermissionDenied = @"RecordErrorPermissionDenied";

@interface PLAudioRecorder()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, copy) RecordSuccess recordSuccess;
@property (nonatomic, copy) RecordFailed recordFailed;
@property (nonatomic, copy) RecordWithMeters recordMeters;
@property (nonatomic) dispatch_source_t recordTimer;
@property (nonatomic, strong) NSDate *startRecordDate;
@property (nonatomic) BOOL isEnableMic;//用户是否禁用麦克风的BOOL值，Mic为“Microphone”的简写



@end


@implementation PLAudioRecorder



- (instancetype)init
{
    self = [super init];
    if (self) {
        //AVAudioSession中断的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(audioSessionInterrupted:)
                                                     name:AVAudioSessionInterruptionNotification
                                                   object:[AVAudioSession sharedInstance]];
        
        if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
            // iOS7 need permission
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                self.isEnableMic = granted;
            }];
        } else {
            self.isEnableMic = YES;
        }
    }
    return self;
}
- (void)dealloc
{
    _recorder.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:nil];
}


#pragma mark - record methods
- (void)startRecordUpdateMeters:(RecordWithMeters)meters
                        success:(RecordSuccess)success
                         failed:(RecordFailed)failed;
{
    
    self.recordSuccess = success;
    self.recordFailed = failed;
    self.recordMeters = meters;
    if (self.isEnableMic) {
        /**
         *
         * 在iOS5真机测试，使用async方式调用将会出现在[self.recorder record]方法crash
         * 因此在iOS5上改为主线程调用。
         */
        if ([[[UIDevice currentDevice]systemVersion] hasPrefix:@"5."]) {
            [self recordWithFilePath:[self cafPath]];
        } else {
            
            // 放在异步线程执行是为了加快首次调用的速度
            
            static BOOL isFirst = YES;
            if (isFirst == NO) {
                [self recordWithFilePath:[self cafPath]];
            } else {
                dispatch_queue_t record_queue = dispatch_queue_create("record_queue", nil);
                dispatch_async(record_queue, ^{
                    [self recordWithFilePath:[self cafPath]];
                    isFirst = NO;
                });
            }}
    } else {
        self.recordFailed([NSError errorWithDomain:RecordErrorPermissionDenied
                                              code:-1
                                          userInfo:@{NSLocalizedFailureReasonErrorKey : NSLocalizedStringFromTable(@"permission denied", @"AudioTable", nil)}]);
    }
}

- (void)recordWithFilePath:(NSString *)path
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:NULL];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];//启动音频会话管理,此时会阻断后台音乐的播放
    //    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;//扬声器
    //    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    // get your audio session somehow
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL success = [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    if(!success)
    {
        hudShowError(@"请打开扬声器！");
        if (self.recordFailed) {
            
            NSError *error = nil;
            self.recordFailed(error);
        }
        return;
    }
    
    /**
     *
     使用kAudioSessionProperty_OverrideAudioRoute时，当发生任何中断如插拔耳机时，audio route就会重置回听筒，你必须再设置一次。
     使用kAudioSessionProperty_OverrideCategoryDefaultToSpeaker则除非你更改category，否则会一直生效。
     
     */
    
    NSDictionary *recordSetting = @{
                                    AVFormatIDKey               : @(kAudioFormatLinearPCM),
                                    AVSampleRateKey             : @(44100.f),
                                    AVNumberOfChannelsKey       : @(2),
                                    AVLinearPCMBitDepthKey      : @(16),
                                    AVLinearPCMIsNonInterleaved : @NO,
                                    AVLinearPCMIsFloatKey       : @NO,
                                    AVLinearPCMIsBigEndianKey   : @NO
                                    };
    /**
     *
     AVFormatIDKey  音乐格式
     AVSampleRateKey 采样率
     AVNumberOfChannelsKey 音乐通道数
     AVLinearPCMBitDepthKey,采样位数 默认 16
     AVLinearPCMIsFloatKey,采样信号是整数还是浮点数
     AVLinearPCMIsBigEndianKey,大端还是小端 是内存的组织方式
     AVEncoderAudioQualityKey,音频编码质量
     
     */
    NSError *error = nil;
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:path]
                                                settings:recordSetting
                                                   error:&error];
    [self.recorder recordForDuration:(NSTimeInterval)60.0];
    
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.recordFailed) {
                self.recordFailed(error);
            }
        });
    } else {
        self.recorder.meteringEnabled = YES;//开启仪表计数功能
        [self.recorder setDelegate:self];
        
        if (![self.recorder record]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.recordFailed) {
                    self.recordFailed([[NSError alloc] initWithDomain:RecordErrorStart
                                                                 code:-1
                                                             userInfo:@{NSLocalizedFailureReasonErrorKey : NSLocalizedStringFromTable(@"record start failed", @"AudioTable", nil)}]);
                }
            });
        } else {
            self.startRecordDate = [NSDate date];
            self.recordTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
            dispatch_source_set_timer(self.recordTimer, DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
            dispatch_source_set_event_handler(self.recordTimer, ^{
                [self.recorder updateMeters];
                self.recordMeters([self.recorder averagePowerForChannel:0]);
            });
            dispatch_resume(self.recordTimer);
            
            
        }
    }
}

- (void)stopRecord
{
    if (self.recordTimer) {
        dispatch_source_cancel(self.recordTimer);
    }
    self.recordTimer = NULL;
    [self.recorder stop];
    self.recorder = nil;
    
}


- (void)stopTimer
{
    if (self.recordTimer) {
        dispatch_source_cancel(self.recordTimer);
    }
    self.recordTimer = NULL;
}

- (void)recordComplete
{
    
    if (![NSThread isMainThread])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self audio_PCMtoMP3];
        });
    }else
    {
        [self audio_PCMtoMP3];
    }
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [self stopTimer];
    
}
#pragma mark - Convert Utils
- (void)audio_PCMtoMP3
{
    NSString *cafFilePath = [self cafPath];
    NSString *mp3FilePath = [self mp3Path];
    
    // remove the old mp3 file
    [self deleteMp3Cache];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 44100.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        MMLog(@"%@",[exception description]);
    }
    @finally {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
    }
    
    [self deleteCafCache];
   // NSLog(@"MP3转换结束");
    
    if (self.recordSuccess) {
        
        self.recordSuccess([self mp3Path]);
    }
}
- (void)deleteRecorder;
{
    [self deleteMp3Cache];
    [self deleteCafCache];
}
- (void)deleteMp3Cache
{
    [self deleteFileWithPath:[self mp3Path]];
}

- (void)deleteCafCache
{
    [self deleteFileWithPath:[self cafPath]];
}
- (void)deleteFileWithPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager removeItemAtPath:path error:nil])
    {
        MMLog(@"删除以前的mp3文件");
    }
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)aRecorder successfully:(BOOL)flag
{
    [self recordComplete];
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.recordFailed) {
            self.recordFailed(error);
        }
    });
    
    [self stopTimer];
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    [self recordComplete];
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags {
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withFlags:(NSUInteger)flags {
}

#pragma mark AVAudioSessionInterruptionNotification
- (void)audioSessionInterrupted:(NSNotification*)notification {
    NSDictionary *interruptionDictionary = [notification userInfo];
    NSNumber *interruptionType = (NSNumber *)[interruptionDictionary valueForKey:AVAudioSessionInterruptionTypeKey];
    
    if ([interruptionType intValue] == AVAudioSessionInterruptionTypeBegan) {
        
        [self stopRecord];
    }
}
#pragma mark - Path Utils
- (NSString *)cafPath
{
    NSString *cafPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.caf"];
    return cafPath;
}

- (NSString *)mp3Path
{
    NSString *mp3Path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"mp3.caf"];
    return mp3Path;
}
@end
