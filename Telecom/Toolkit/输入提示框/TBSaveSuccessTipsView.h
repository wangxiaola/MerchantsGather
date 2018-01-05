//
//  TBSaveSuccessTipsView.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/30.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^determine)(void);

@interface TBSaveSuccessTipsView : UIView

@property (nonatomic) determine determine;
/**
 弹出提示框
 
 @param prompt 提示信息
 */
- (instancetype)initShowPrompt:(NSString *)prompt;

-(void)showHandler:(determine)change;

@end
