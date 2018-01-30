//
//  TBVideoRecordButtonView.m
//  Telecom
//
//  Created by 王小腊 on 2018/1/25.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBVideoRecordButtonView.h"

@interface TBVideoRecordButtonView()
@property (strong, nonatomic) UIBezierPath *path;
@property (strong, nonatomic) CAShapeLayer *shapeLayer;


@end
@implementation TBVideoRecordButtonView

{
    UIButton *_recordButton;
    UIView   *_pathView;
    UILabel  *_timeLabel;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
     
        [self createViews];
        
    }
    return self;
}
#pragma mark  ----view----
- (void)createViews;
{
    _pathView = [[UIView alloc] initWithFrame:self.bounds];
    _pathView.backgroundColor = [UIColor clearColor];
    _pathView.hidden = YES;
    [self addSubview:_pathView];
    
    _path = [UIBezierPath bezierPathWithOvalInRect:_pathView.bounds];
    
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = self.bounds;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.lineWidth = 2.f;
    _shapeLayer.lineCap = kCALineCapRound;
    _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    _shapeLayer.strokeStart = 0.f;
    _shapeLayer.strokeEnd = 0.f;

    _shapeLayer.path = _path.CGPath;
    [_pathView.layer addSublayer:_shapeLayer];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.width/2)];
    _timeLabel.center = _pathView.center;
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:16 weight:0.1];
    [_pathView addSubview:_timeLabel];
    
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _recordButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [_recordButton setBackgroundImage:[UIImage imageNamed:@"vide_ recording"] forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(recordClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_recordButton];
    
}
#pragma mark  ----click----
- (void)recordClick
{
    if (self.startRecord) {
        self.startRecord();
    }
}
- (void)updateLabelText:(CGFloat)text;
{
    _timeLabel.text = [NSString stringWithFormat:@"%.1fs",text];
    
}
#pragma mark  ----自实现----
@synthesize value = _value;
-(void)setValue:(CGFloat)value{
    _value = value;
    _shapeLayer.strokeEnd = value;

    if (value >=1) {
        _recordButton.hidden = NO;
        _pathView.hidden     = YES;
        _shapeLayer.strokeEnd = 0;
    }
    else
    {
        _recordButton.hidden = YES;
        _pathView.hidden     = NO;
    }
}
-(CGFloat)value{
    return _value;
}

@synthesize lineColr = _lineColr;
-(void)setLineColr:(UIColor *)lineColr{
    _lineColr = lineColr;
    _shapeLayer.strokeColor = lineColr.CGColor;
}
-(UIColor*)lineColr{
    return _lineColr;
}

@synthesize lineWidth = _lineWidth;
-(void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    _shapeLayer.lineWidth = lineWidth;

}
-(CGFloat)lineWidth{
    return _lineWidth;
}
@end
