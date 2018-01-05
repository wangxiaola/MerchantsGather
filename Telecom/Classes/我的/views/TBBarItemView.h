//
//  TBBarItemView.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/27.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBBarItemView : UIView

@property (nonatomic, strong) NSArray *titelArray;
@property (nonatomic, assign) CGFloat spacing;
- (void)selectIndex:(NSInteger)inde;

@property (nonatomic, copy)void(^barSelect)(NSInteger index);

@end
