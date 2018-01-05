//
//  TBWebViewController.h
//  Telecom
//
//  Created by 王小腊 on 2017/1/9.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBaseViewController.h"
@class TBTaskListRoot;
@interface TBWebViewController : TBBaseViewController

@property (strong, nonatomic) NSString *urlString;

/**
 加载纯外部链接网页
 
 @param string URL地址
 */
- (void)loadWebURLSring:(NSString *)string;
@property (nonatomic, strong) TBTaskListRoot *root;
@end
