//
//  TBContentScrollView.m
//  Telecom
//
//  Created by 王小腊 on 2017/8/9.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBContentScrollView.h"

@implementation TBContentScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (void)setOffset:(CGPoint)offset {
    _offset = offset;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view       = [super hitTest:point withEvent:event];
    BOOL hitHead       = point.y < (TBHeadViewHeight - self.offset.y);
    if (hitHead || !view) {
        self.scrollEnabled = NO;
        if (!view) {
            for (UIView* subView in self.subviews) {
                if (subView.frame.origin.x == self.contentOffset.x) {
                    view = subView;
                }
            }
        }
        return view;
    } else {
        self.scrollEnabled = YES;
        return view;
    }
}


@end
