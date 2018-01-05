//
//  TBCityChooseView.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/12.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChooseLocationView;
/**
 城市选择器
 */
@interface TBCityChooseView : UIView

- (void)showCity:(NSString*)code;

@property (nonatomic, strong) ChooseLocationView *chooseLocationView;

@property (nonatomic, copy) void (^addressChooseLocation)(NSString *address,NSString *code);


@end
