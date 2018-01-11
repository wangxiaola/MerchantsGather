//
//  TBVoiceProgressView.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/18.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)

#import "TBVoiceProgressView.h"
#import <math.h>
#import <QuartzCore/QuartzCore.h>

@interface TBVoiceProgressView() <UIGestureRecognizerDelegate>
@property CGPoint trueCenter;
@property int currentNum;
@property double angle;
@property UIView *circle;



@end
@implementation TBVoiceProgressView

# pragma mark view appearance setup

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        // overall view settings
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        
        // setting default values
        self.minNum = 0;
        self.maxNum = 100;
        self.currentNum = self.minNum;
        
        // determine true center of view for calculating angle and setting up arcs
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        self.trueCenter = CGPointMake(width/2, height/2);
        
        // radii settings
        self.dialRadius = 5;
        self.arcRadius = 50;
        self.outerRadius = MIN(width, height)/2;
        self.arcThickness = 5.0;
        
        self.circle = [[UIView alloc] initWithFrame:CGRectMake((width - self.dialRadius*2)/2, height*.25, self.dialRadius*2, self.dialRadius*2)];
        self.circle.userInteractionEnabled = YES;
        [self addSubview: self.circle];

        
        self.arcColor = [UIColor redColor];
        self.backColor = [UIColor clearColor];
        self.dialColor = [UIColor blueColor];
        self.labelColor = [UIColor blackColor];
        
    }
    
    return self;
}

- (void) drawRect:(CGRect)rect {
    UIColor *color = self.arcColor;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 3);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    UIBezierPath *path = [self createArcPathWithAngle:self.angle atPoint:self.trueCenter withRadius:self.arcRadius];
    path.lineWidth = self.arcThickness;
    if(self.angle > 1)[path stroke];
    
}

- (void) willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    
    self.arcRadius = MIN(self.arcRadius, self.outerRadius - self.dialRadius);
    
    // background circle
    self.layer.cornerRadius = self.outerRadius;
    self.backgroundColor = self.backColor;
    
    // dial
    self.circle.frame =  CGRectMake((self.frame.size.width - self.dialRadius*2)/2, self.frame.size.height*.25, self.dialRadius*2, self.dialRadius*2);
    self.circle.layer.cornerRadius = self.dialRadius;
    self.circle.backgroundColor = self.dialColor;
    
    
    [self moveCircleToAngle:0];
    [self setNeedsDisplay];
    
}

# pragma mark move circle in response to pan gesture

- (void) moveCircleToAngle: (double)angle
{

    if (angle>=360)
    {
        angle = 358;
    }
    self.angle = angle;
    [self setNeedsDisplay];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGPoint newCenter = CGPointMake(width/2, height/2);
    
    newCenter.y += self.arcRadius * sin(M_PI/180 * (angle - 90));
    newCenter.x += self.arcRadius * cos(M_PI/180 * (angle - 90));
    self.circle.center = newCenter;
    self.currentNum = self.minNum + (self.maxNum - self.minNum)*(angle/360.0);
}


- (UIBezierPath *)createArcPathWithAngle:(double)angle atPoint: (CGPoint) point withRadius: (float) radius
{
    float endAngle = (float)(((int)angle + 270 + 1)%360);
    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:point
                                                         radius:radius
                                                     startAngle:DEGREES_TO_RADIANS(270)
                                                       endAngle:DEGREES_TO_RADIANS(endAngle)
                                                      clockwise:YES];
    return aPath;
}



@end
