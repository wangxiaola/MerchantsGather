//
//  TBBasePageTabBar.m
//  Telecom
//
//  Created by 小腊 on 17/3/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBasePageTabBar.h"

@interface TBBasePageTabBar ()
@property (nonatomic, weak) id<TBBasePageTabBarPrivateDelegate> praviteDelegate;
@end

@implementation TBBasePageTabBar

- (void)clickedPageTabBarAtIndex:(NSInteger)index
{
    if ([_praviteDelegate respondsToSelector:@selector(basePageTabBar:clickedPageTabBarAtIndex:)]) {
        [_praviteDelegate basePageTabBar:self clickedPageTabBarAtIndex:index];
    }
}

- (void)switchToPageIndex:(NSInteger)index
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
