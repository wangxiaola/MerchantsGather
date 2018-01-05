//
//  TBGZEmployeesAddView.h
//  Telecom
//
//  Created by 王小腊 on 2017/11/16.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBTemplateBaseView.h"

/**
 贵州——贫困员工添加页面
 */
@interface TBGZEmployeesAddView: TBTemplateBaseView

@property (nonatomic) CGRect myFrame;
/**
  加载view

 @param frame frame
 @return self
 */
+ (TBGZEmployeesAddView *)loadingNibConetenViewWithFrame:(CGRect)frame;


@end
