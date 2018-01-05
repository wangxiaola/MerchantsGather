//
//  JYTMyTextField.h
//  jy_bean_out
//
//  Created by 周德江 on 14-11-12.
//  Copyright (c) 2014年 joyoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKTextField : UITextField
- (CGRect)textRectForBounds:(CGRect)bounds;
- (CGRect)editingRectForBounds:(CGRect)bounds;

@property (nonatomic,assign) IBInspectable float spacing;

@end
