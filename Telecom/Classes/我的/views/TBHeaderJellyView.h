//
//  TBHeaderJellyView.h
//  Telecom
//
//  Created by 小腊 on 17/3/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBHeaderJellyView : UIView

//上面哪个东西是否运行
@property (nonatomic, assign) BOOL isAnimating;

- (void)handlePanAction:(UIPanGestureRecognizer *)pan;
- (void)endAnimation;
@end
