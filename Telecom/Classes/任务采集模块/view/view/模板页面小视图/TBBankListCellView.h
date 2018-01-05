//
//  TBBankListCellView.h
//  Telecom
//
//  Created by 王小腊 on 2018/1/3.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TBBankListCellViewDelegate <NSObject>

@optional

/**
 输入框编辑结束
 */
- (void)textFieldEditEnd;

/**
 覆盖视图被点击
 */
- (void)coveringViewClick;

@end

/**
 银行列表cell视图
 */
@interface TBBankListCellView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

/**
 创建cell

 @param boardType 键盘类型
 @param placeholder 默认提示
 @param leftText 左边提示
 @return view
 */
- (instancetype)initTextFieldType:(UIKeyboardType)boardType fieldPlaceholder:(NSString *)placeholder cellLeftText:(NSString *)leftText;

/**
 添加覆盖view
 */
- (void)addClickCoveringView;

@property (nonatomic, assign) id<TBBankListCellViewDelegate>delegate;
@end
