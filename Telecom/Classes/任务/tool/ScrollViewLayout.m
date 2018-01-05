//
//  ScrollViewLayout.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/7.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "ScrollViewLayout.h"

@implementation UIScrollView(Layout)

- (void)equalLayout:(NSArray <UIView *> *)views
{
    if (views.count == 0) {
        return;
    }
    
    if (views.count == 1) {
        [views[0] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        return;
    }
    
    for (int i = 0; i < views.count; i++) {
        UIView *view = views[i];
        
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            if (i == 0) {
                make.height.equalTo(self);
                make.width.equalTo(self);
                make.top.and.bottom.equalTo(self);
            }else {
                make.width.equalTo(views[i - 1].mas_width);
                make.height.equalTo(views[i - 1].mas_height);
                make.top.equalTo(views[i-1].mas_top);
            }
            
            if (i == 0) {
                make.left.equalTo(self);
                make.right.equalTo(views[i + 1].mas_left);
            }else if (i == views.count - 1) {
                make.right.equalTo(self);
                make.left.equalTo(views[i - 1].mas_right);
            }else {
                make.left.equalTo(views[i - 1].mas_right);
                make.right.equalTo(views[i + 1].mas_left);
            }
        }];
    }

}


@end
