//
//  TBVideoCompositionTool.m
//  Telecom
//
//  Created by 王小腊 on 2018/1/17.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBVideoCompositionTool.h"

@implementation TBVideoCompositionTool

+ (AVVideoComposition *)applyVideoEffectsToAVAsset:(AVAsset *)avAsset shopName:(NSString*)name;
{
   
    CGSize size = avAsset.naturalSize;
    
    AVMutableVideoComposition *composition = [AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:avAsset];
    
    CALayer *coverImgLayer = [CALayer layer];
    coverImgLayer.contents = (id)[UIImage imageNamed:@"banner"].CGImage;
    coverImgLayer.bounds =  CGRectMake(0,0,210, 50);
    coverImgLayer.position = CGPointMake(size.width/2, size.height/2);
    
    UIFont *font = [UIFont systemFontOfSize:30.0];
    CATextLayer *subtitleText = [[CATextLayer alloc] init];
    [subtitleText setFontSize:30];
    [subtitleText setString:name];
    [subtitleText setAlignmentMode:kCAAlignmentCenter];
    [subtitleText setForegroundColor:[[UIColor whiteColor] CGColor]];
    subtitleText.masksToBounds = YES;
    [subtitleText setBackgroundColor:[UIColor clearColor].CGColor];
    CGSize textSize = [name sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    [subtitleText setFrame:CGRectMake(0, 0, textSize.width+20, textSize.height+10)];
    subtitleText.position = CGPointMake(size.width/2, size.height/2);
    
    [coverImgLayer addSublayer:subtitleText];
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:coverImgLayer];
    
    //设置封面
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima.repeatCount = 0;
    anima.duration = 2.0f;  //5s之后消失
    [anima setRemovedOnCompletion:NO];
    [anima setFillMode:kCAFillModeForwards];
    anima.beginTime = AVCoreAnimationBeginTimeAtZero;
    [coverImgLayer addAnimation:anima forKey:@"opacityAniamtion"];
    
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    return composition;
}
@end
