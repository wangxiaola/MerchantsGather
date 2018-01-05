//
//  DYTopTabView.h
//  slyjg
//
//  Created by 汤亮 on 16/3/9.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKTopTabView : UIView
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *titles;
- (instancetype)initWithTitles:(NSArray <NSString *> *)titles;

@property (nonatomic, copy) void(^tabBtnClickCallback)(NSInteger index);
- (void)selectTabBtnAtIndex:(NSInteger)index;

@end
