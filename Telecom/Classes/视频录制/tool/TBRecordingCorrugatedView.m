//
//  TBRecordingCorrugatedView.m
//  Telecom
//
//  Created by 王小腊 on 2018/1/11.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBRecordingCorrugatedView.h"

#define WAVE_UPDATE_FREQUENCY   0.1
#define SILENCE_VOLUME   45.0
#define SOUND_METER_COUNT  6

@implementation TBRecordingCorrugatedView
{
    int soundMeters[SOUND_METER_COUNT];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.backgroundColor = [UIColor clearColor];
    }
    return self;

}
- (void)updateMeters:(CGFloat)powerForChannel;
{
    
    if (powerForChannel < -SILENCE_VOLUME) {
        [self addSoundMeterItem:SILENCE_VOLUME];
        return;
    }
    [self addSoundMeterItem:powerForChannel];

}

- (void)addSoundMeterItem:(int)lastValue{
    for(int i=0; i<SOUND_METER_COUNT - 1; i++) {
        soundMeters[i] = soundMeters[i+1];
    }
    soundMeters[SOUND_METER_COUNT - 1] = lastValue;
    
    [self setNeedsDisplay];
}

#pragma mark - Drawing operations

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    int baseLine = rect.size.height/2;
    static int multiplier = 1;
    int maxLengthOfWave = 45;
    int maxValueOfMeter = 400;
    int yHeights[6];
    float segement[6] = {0.05, 0.2, 0.35, 0.25, 0.1, 0.05};
    
    [[UIColor colorWithRed:55/255.0 green:180/255.0 blue:252/255.0 alpha:1] set];
    CGContextSetLineWidth(context, 2.0);
    
    
    for(int x = SOUND_METER_COUNT - 1; x >= 0; x--)
    {
        int multiplier_i = ((int)x % 2) == 0 ? 1 : -1;
        CGFloat y = ((maxValueOfMeter * (maxLengthOfWave - abs(soundMeters[(int)x]))) / maxLengthOfWave);
        yHeights[SOUND_METER_COUNT - 1 - x] = multiplier_i * y * segement[SOUND_METER_COUNT - 1 - x]  * multiplier+ baseLine;

    }
    [self drawLinesWithContext:context BaseLine:baseLine HeightArray:yHeights lineWidth:2.0 alpha:0.8 percent:1.0 segementArray:segement];
    [self drawLinesWithContext:context BaseLine:baseLine HeightArray:yHeights lineWidth:1.0 alpha:0.4 percent:0.66 segementArray:segement];
    [self drawLinesWithContext:context BaseLine:baseLine HeightArray:yHeights lineWidth:1.0 alpha:0.2 percent:0.33 segementArray:segement];
    multiplier = -multiplier;
}

- (void) drawLinesWithContext:(CGContextRef)context BaseLine:(float)baseLine HeightArray:(int*)yHeights lineWidth:(CGFloat)width alpha:(CGFloat)alpha percent:(CGFloat)percent segementArray:(float *)segement{
    
    CGFloat start = 0;
    [[UIColor colorWithRed:55/255.0 green:180/255.0 blue:252/255.0 alpha:1] set];
    CGContextSetLineWidth(context, width);
    
    for (int i = 0; i < 6; i++) {
        if (i % 2 == 0) {
            CGContextMoveToPoint(context, start, baseLine);
            
            CGContextAddCurveToPoint(context, _SCREEN_WIDTH *segement[i] / 2 + start, (yHeights[i] - baseLine)*percent + baseLine, _SCREEN_WIDTH *segement[i] + _SCREEN_WIDTH *segement[i + 1] / 2 + start, (yHeights[i + 1] - baseLine)*percent + baseLine,_SCREEN_WIDTH *segement[i] + _SCREEN_WIDTH *segement[i + 1] + start , baseLine);
            start += _SCREEN_WIDTH *segement[i] + _SCREEN_WIDTH *segement[i + 1];
        }
    }
    
    CGContextStrokePath(context);
}
@end
