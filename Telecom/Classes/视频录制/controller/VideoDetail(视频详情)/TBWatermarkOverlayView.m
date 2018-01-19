//
//  SCWatermarkOverlayView.m
//  SCRecorderExamples
//
//  Created by Simon CORSIN on 16/06/15.
//
//

#import "TBWatermarkOverlayView.h"

@interface TBWatermarkOverlayView() {

    UIImageView *_watermarkImageView;
    
}
@end

@implementation TBWatermarkOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _watermarkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_watermark"]];
        _watermarkImageView.contentMode = UIViewContentModeScaleAspectFill;
        _watermarkImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_watermarkImageView];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_watermarkImageView sizeToFit];
    CGRect watermarkFrame = CGRectMake(10, 10, 100, 30.4);
    _watermarkImageView.frame = watermarkFrame;
    
}


@end
