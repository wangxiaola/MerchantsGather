//
//  TBNoDataClickView.h
//  Telecom
//
//  Created by 王小腊 on 2018/8/3.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBNoDataClickView : UIView

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIButton *addClickButton;

/**
 加载view
 
 @param frame frame
 @return self
 */
+ (TBNoDataClickView *)loadingNibConetenViewWithFrame:(CGRect)frame;

@end
