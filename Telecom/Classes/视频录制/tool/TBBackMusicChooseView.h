//
//  TBBackMusicChooseView.h
//  Telecom
//
//  Created by 王小腊 on 2018/1/22.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ChooseMuSicSuccess)(NSURL *musicPath);//成功的回调block

/**
 背景音乐选择
 */
@interface TBBackMusicChooseView : UIView

@property (nonatomic, copy) ChooseMuSicSuccess musicSuccess;


/**
 弹出音乐选择视图
 
 @param success 成功的返回
 */
- (void)showViewChooseSuccess:(ChooseMuSicSuccess)success;

@end
