//
//  TBTaskSearchView.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/5.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TBTaskSearchView : UIView

/**
 搜索结果
 */
@property (nonatomic, copy) void(^searchResult)(NSString *key,NSString *code);

- (instancetype)initWithFrame:(CGRect)frame typeSelection:(BOOL)type;

@end
