//
//  TBVideoRecordingView.m
//  Telecom
//
//  Created by 王小腊 on 2018/1/10.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBVideoRecordingView.h"
#import "PLAudioRecorder.h"
#import "TBRecordingCorrugatedView.h"
#import "SpectrumView.h"
@interface TBVideoRecordingView()
{
    CGFloat  _contenViewHeight;
    UIView   *_contenView;// 中心view
    UIView   *_centerView;// 音律显示baseview
    UILabel  *_timeLabel;// 时间显示
    UILabel  *_stateLabel;// 状态显示
    UIButton *_completeButton;
    UILabel  *_countdownLabel;// 倒计时
    PLAudioRecorder *_audioRecorder;
    TBRecordingCorrugatedView *_corrugatedView;
    dispatch_source_t _timerSource;// 定时器
    double   _recordingTime;// 录音时间
}
@end
@implementation TBVideoRecordingView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, _SCREEN_HEIGHT)];
    if (self) {
        
        [self createViews];
    }
    return self;
}
#pragma mark  ----视图创建----
- (void)createViews
{
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
    // 初始化录音工具
    _audioRecorder = [[PLAudioRecorder alloc] init];
    [_audioRecorder deleteRecorder];
    
    _contenViewHeight = (_SCREEN_HEIGHT - 64) / 2 ;
    
    _contenView = [[UIView alloc] initWithFrame:CGRectMake(0, _SCREEN_HEIGHT, _SCREEN_WIDTH, _contenViewHeight)];
    _contenView.backgroundColor = RGB(14, 14, 14);
    [self addSubview:_contenView];
    
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(-1, 50, _SCREEN_WIDTH+2, _contenViewHeight/2)];
    _centerView.layer.masksToBounds = YES;
    _centerView.layer.borderWidth = 0.5;
    _centerView.layer.borderColor = RGB(101, 101, 101).CGColor;
    [_contenView addSubview:_centerView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [_contenView addSubview:cancelButton];
    
    UILabel *recordingLabel = [[UILabel alloc] init];
    recordingLabel.text = @"录音";
    recordingLabel.textAlignment = NSTextAlignmentCenter;
    recordingLabel.textColor = RGB(111, 111, 111);
    recordingLabel.font = [UIFont systemFontOfSize:14];
    [_contenView addSubview:recordingLabel];
    
    
    _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_completeButton setTitle:@"完成" forState:(UIControlStateNormal)];
    [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _completeButton.alpha = 0.0;
    _completeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_completeButton addTarget:self action:@selector(completeClick) forControlEvents:UIControlEventTouchUpInside];
    [_contenView addSubview:_completeButton];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = @"00:00";
    _timeLabel.textColor = RGB(111, 111, 111);
    _timeLabel.font = [UIFont systemFontOfSize:14];
    [_contenView addSubview:_timeLabel];
    
    _stateLabel = [[UILabel alloc] init];
    _stateLabel.text = @"请准备";
    _stateLabel.textColor = [UIColor whiteColor];
    _stateLabel.font = [UIFont systemFontOfSize:18 weight:0.1];
    [_contenView addSubview:_stateLabel];
    
    _countdownLabel = [[UILabel alloc] init];
    _countdownLabel.text = @"4";
    _countdownLabel.alpha = 0.0;
    _countdownLabel.font = [UIFont systemFontOfSize:40 weight:0.1];
    _countdownLabel.textColor = [UIColor whiteColor];
    [_centerView addSubview:_countdownLabel];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_contenView);
        make.bottom.equalTo(_centerView.mas_top);
        make.width.equalTo(@60);
    }];
    
    [_completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(_contenView);
        make.bottom.equalTo(_centerView.mas_top);
        make.width.equalTo(@60);
    }];
    
    [recordingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cancelButton.mas_right);
        make.right.equalTo(_completeButton.mas_left);
        make.top.equalTo(_contenView.mas_top);
        make.bottom.equalTo(_centerView.mas_top);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerView.mas_bottom).offset(6);
        make.centerX.equalTo(_contenView.mas_centerX);
        make.height.equalTo(@24);
    }];
    
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_bottom);
        make.bottom.equalTo(_contenView.mas_bottom);
        make.centerX.equalTo(_contenView.mas_centerX);
    }];
    [_countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_centerView);
    }];
}
#pragma mark  ----录音----

/**
 开始录音
 */
- (void)startRecording
{
    _stateLabel.text = @"请说话";
    _completeButton.alpha = 1.0;
    
    _corrugatedView = [[TBRecordingCorrugatedView alloc] initWithFrame:CGRectMake(0, 0, _centerView.frame.size.width, _centerView.frame.size.height)];
    [_centerView addSubview:_corrugatedView];
    
    // 开启录音
    TBWeakSelf
    [_audioRecorder startRecordUpdateMeters:^(float meters) {
        [_corrugatedView updateMeters:meters];
    } success:^(NSString *recordPath) {
       
        if (weakSelf.recordSuccess) {
            weakSelf.recordSuccess(recordPath);
        }
    } failed:^(NSError *error) {
        if (weakSelf.recordSuccess) {
            weakSelf.recordSuccess(@"");
        }
        [weakSelf disappear];
        
    }];
    [self puslocation];
}
#pragma mark  ----点击事件----
// 取消
- (void)cancelClick
{
    [_countdownLabel removeFromSuperview];
    _countdownLabel = nil;
    
    if (self.recordSuccess) {
        self.recordSuccess(@"");
    }
    [self disappear];
}
// 完成
- (void)completeClick
{
    [_audioRecorder stopRecord];
    [self disappear];
}
#pragma mark  ----show----

/**
 弹出录音视图
 
 @param time 时间
 @param success 成功的返回
 */
- (void)showRecordingTime:(double)time success:(RecordSuccess)success;
{
    _recordingTime = time;
    self.recordSuccess = success;
    
    _timeLabel.text = [NSString stringWithFormat:@"%.2f",time];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _contenView.frame = CGRectMake(0, _SCREEN_HEIGHT - _contenViewHeight, _SCREEN_WIDTH, _contenViewHeight);
        [self performSelector:@selector(countdownToUpdate) withObject:nil afterDelay:0.4];
    }];
}

/**
 消失
 */
- (void)disappear
{
    [self destructionTimer];
    [UIView animateWithDuration:0.2 animations:^{
        _contenView.frame = CGRectMake(0, _SCREEN_HEIGHT, _SCREEN_WIDTH, _contenViewHeight);
    } completion:^(BOOL finished) {
        [_countdownLabel removeFromSuperview];
        [self removeFromSuperview];
    }];
}

/**
 更新倒计时
 */
- (void)countdownToUpdate
{
    if (_countdownLabel == nil) {
        return;
    }
    _countdownLabel.alpha = 1.0;
    NSInteger time = _countdownLabel.text.integerValue;
    time -= 1;
    if (time > 0 ){
        _countdownLabel.text = [NSString stringWithFormat:@"%ld",time];
        CAKeyframeAnimation *anima2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        //字体变化大小
        NSValue *value1 = [NSNumber numberWithFloat:3.0f];
        NSValue *value2 = [NSNumber numberWithFloat:2.0f];
        NSValue *value3 = [NSNumber numberWithFloat:0.7f];
        NSValue *value4 = [NSNumber numberWithFloat:1.0f];
        anima2.values = @[value1,value2,value3,value4];
        anima2.duration = 0.8;
        [_countdownLabel.layer addAnimation:anima2 forKey:@"scalsTime"];
        
        [self performSelector:@selector(countdownToUpdate) withObject:nil afterDelay:1];
    }else {
        [_countdownLabel removeFromSuperview];
        [self startRecording];
    }
    
}
#pragma mark  定时器
// 倒计时
- (void)puslocation
{
    TBWeakSelf
    dispatch_queue_t timerQueue = dispatch_queue_create("timerQueue", 0);
    /// 创建 gcd timer.
    _timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, timerQueue);
    double interval = 0.01 * NSEC_PER_SEC; /// 间隔0.02秒
    dispatch_source_set_timer(_timerSource, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
    /// 定时器block设置
    dispatch_source_set_event_handler(_timerSource, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf updateRecordingState];
        });
    });
    /// 唤起定时器任务.
    dispatch_resume(_timerSource);
    
}
// 销毁
- (void)destructionTimer
{
    if (_timerSource) {
       dispatch_source_cancel(_timerSource);
    }
    _timerSource = NULL;
}
/**
 更新录音状态
 */
- (void)updateRecordingState
{
    _recordingTime -= 0.01;
    
    if (_recordingTime < 0) {
        [self destructionTimer];
        [self completeClick];
    }
    else
    {
        _timeLabel.text = [NSString stringWithFormat:@"%.2f",_recordingTime];
    }
    
}

@end
