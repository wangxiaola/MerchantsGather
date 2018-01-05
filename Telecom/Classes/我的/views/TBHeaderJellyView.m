//
//  TBHeaderJellyView.m
//  Telecom
//
//  Created by 小腊 on 17/3/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//


#import "TBHeaderJellyView.h"

@interface TBHeaderJellyView ()
@property (nonatomic, assign) CGFloat mHeight;
//红色哪个点得坐标的x值
@property (nonatomic, assign) CGFloat curveX;
//红色哪个点的坐标的Y值
@property (nonatomic, assign) CGFloat curveY;
//对应哪个红色的点对应的视图
@property (nonatomic, strong) UIView *curveView;
//性状对应的layer
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
//这个东西的主要作用是让上面的shapelayer运行多次
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) CGFloat MIN_HEIGHT;

@property (nonatomic, assign) CGFloat amplitude;
@end

@implementation TBHeaderJellyView
@synthesize MIN_HEIGHT,amplitude;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        MIN_HEIGHT = frame.size.height;
        amplitude = 40;
        
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = RGB(3, 180, 156).CGColor;
        [self.layer addSublayer:_shapeLayer];
        
        // _curveView就是r5点
        _curveX = _SCREEN_WIDTH/2.0;
        _curveY = MIN_HEIGHT;
        _curveView = [[UIView alloc] initWithFrame:CGRectMake(_curveX, _curveY, 5, 5)];
        _curveView.backgroundColor = [UIColor clearColor];
        [self addSubview:_curveView];
        // 手势移动时相对高度
        _mHeight = self.frame.size.height;
        // 是否处于动效状态
        _isAnimating = NO;
        //CADisplayLink默认每秒运行60次calculatePath是算出在运行期间_curveView的坐标，从而确定_shapeLayer的形状
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(calculatePath)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _displayLink.paused = YES;
        
        [self updateShapeLayerPath];
        
    }
    
    return self;
}

- (void)handlePanAction:(UIPanGestureRecognizer *)pan
{
    if(!_isAnimating)
    {
        if(pan.state == UIGestureRecognizerStateChanged)
        {
            // 手势移动时，_shapeLayer跟着手势向下扩大区域
            CGPoint point = [pan translationInView:self];
            // 这部分代码使r5红点跟着手势走
            _mHeight = point.y*0.7 + MIN_HEIGHT;
            _curveX = _SCREEN_WIDTH/2.0 + point.x;
            _curveY = _mHeight > MIN_HEIGHT ? _mHeight : MIN_HEIGHT;
            _curveView.frame = CGRectMake(_curveX,
                                          _curveY,
                                          _curveView.frame.size.width,
                                          _curveView.frame.size.height);
            
            // 根据r5的坐标,更新_shapeLayer形状
            [self updateShapeLayerPath];
            
        }
        else if (pan.state == UIGestureRecognizerStateCancelled ||
                 pan.state == UIGestureRecognizerStateEnded ||
                 pan.state == UIGestureRecognizerStateFailed)
        {
            [self endAnimation];
        }
    }
}
- (void)endAnimation
{
    // 手势结束时,_shapeLayer返回原状并产生弹簧动效
    _isAnimating = YES;
    //这个对象开始执行，calculatePath被多次调用
    _displayLink.paused = NO;
    // 弹簧动效
    [UIView animateWithDuration:1.0
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         // 曲线点(r5点)是一个view.所以在block中有弹簧效果.然后根据他的动效路径,在calculatePath中计算弹性图形的形状
                         _curveView.frame = CGRectMake(_SCREEN_WIDTH/2.0, MIN_HEIGHT, 3, 3);
                         
                     } completion:^(BOOL finished) {
                         
                         if(finished)
                         {
                             //
                             _displayLink.paused = YES;
                             _isAnimating = NO;
                         }
                         
                     }];
}

#pragma mark 每次更新的时候，都初始化一个path，然后重新绘制shapelayer
- (void)updateShapeLayerPath
{
    // 更新_shapeLayer形状
    UIBezierPath *tPath = [UIBezierPath bezierPath];
    [tPath moveToPoint:CGPointMake(0, 0)];                              // r1点
    [tPath addLineToPoint:CGPointMake(_SCREEN_WIDTH, 0)];            // r2点
    [tPath addLineToPoint:CGPointMake(_SCREEN_WIDTH,  MIN_HEIGHT)];  // r4点
    [tPath addQuadCurveToPoint:CGPointMake(0, MIN_HEIGHT)
                  controlPoint:CGPointMake(_curveX, _curveY+amplitude)]; // r3,r4,r5确定的一个弧线
    [tPath closePath];
    _shapeLayer.path = tPath.CGPath;
}


- (void)calculatePath
{
    // 由于手势结束时,r5执行了一个UIView的弹簧动画,把这个过程的坐标记录下来,并相应的画出_shapeLayer形状
    CALayer *layer = _curveView.layer.presentationLayer;
    _curveX = layer.position.x;
    _curveY = layer.position.y;
    [self updateShapeLayerPath];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
