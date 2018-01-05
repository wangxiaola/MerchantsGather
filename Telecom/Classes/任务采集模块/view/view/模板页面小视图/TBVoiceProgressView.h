//
//  TBVoiceProgressView.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/18.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBVoiceProgressView : UIView

@property int minNum;
@property int maxNum;

@property CGFloat dialRadius;
@property UIColor *dialColor;


@property CGFloat outerRadius;
@property UIColor *backColor;


@property UIColor *arcColor;
@property CGFloat arcRadius;

@property CGFloat arcThickness;

@property UIColor *labelColor;

- (void) moveCircleToAngle: (double)angle;

@end
