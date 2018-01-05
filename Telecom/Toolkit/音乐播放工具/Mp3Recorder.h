//
//  Mp3Recorder.h
//  Created by bmind on 15/7/28.
//  Copyright (c) 2015年 bmind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol Mp3RecorderDelegate <NSObject>

- (void)failRecord;
- (void)beginConvert;
- (void)recording:(float)recordTime volume:(float)volume;
- (void)endConvertWithData:(NSData *)voiceData;
@end

@interface Mp3Recorder : NSObject{
    double lowPassResults;
    float recordTime;
    NSTimer *playTimer;
}


@property (nonatomic, weak) id<Mp3RecorderDelegate> delegate;
@property (nonatomic, strong) AVAudioRecorder *recorder;

- (id)initWithDelegate:(id<Mp3RecorderDelegate>)delegate;
- (void)startRecord;
- (void)stopRecord;
- (void)cancelRecord;

@end
