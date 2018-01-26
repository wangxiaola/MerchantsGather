//
//  SCWatermarkOverlayView.m
//  SCRecorderExamples
//
//  Created by Simon CORSIN on 16/06/15.
//
//

#import "TBWatermarkOverlayView.h"

@interface TBWatermarkOverlayView() {

    UIImageView *_watermarkWc;
    UIImageView *_watermarkDq;
    CGFloat _imageW;
    CGFloat _imageH;
}
@end

@implementation TBWatermarkOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        UIImage *image = [UIImage imageNamed:@"watermark_wc"];
        _imageW = image.size.width;
        _imageH = image.size.height;
        
//        _watermarkWc = [[UIImageView alloc] initWithImage:image];
//        _watermarkWc.contentMode = UIViewContentModeScaleAspectFill;
//        _watermarkWc.backgroundColor = [UIColor clearColor];
//        [self addSubview:_watermarkWc];
        
        _watermarkDq = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"watermark_dq"]];
        _watermarkDq.contentMode = UIViewContentModeScaleAspectFill;
        _watermarkDq.backgroundColor = [UIColor clearColor];
        [self addSubview:_watermarkDq];
        

        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    70 64

    CGFloat videoH = 540;
    
//    [_watermarkWc sizeToFit];
    [_watermarkDq sizeToFit];

//    _watermarkWc.frame = CGRectMake(960-_imageW-12, videoH-_imageH-20, _imageW, _imageH);
    _watermarkDq.frame = CGRectMake(960-(_imageW+12)*1, videoH-_imageH-25, _imageW, _imageH);
}


@end
