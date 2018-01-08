//
//  TBEarningsFooterView.m
//  Telecom
//
//  Created by 王小腊 on 2017/8/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//
NSString *const TBEarningsFooterViewID = @"TBEarningsFooterViewID";

#import "TBEarningsFooterView.h"

@implementation TBEarningsFooterView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIButton *loadMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loadMoreButton setImage:[UIImage imageNamed:@"load_more"] forState:UIControlStateNormal];
        [loadMoreButton addTarget:self action:@selector(loadMoreClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:loadMoreButton];
        TBWeakSelf
        [loadMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf.contentView);
            make.width.equalTo(@30);
            make.height.equalTo(@16);
        }];
        
    }
    return self;
}
#pragma mark  ----点击事件----
- (void)loadMoreClick
{
    if (self.selectFooterView)
    {
        self.selectFooterView(self.section);
    }
    
}

@end
