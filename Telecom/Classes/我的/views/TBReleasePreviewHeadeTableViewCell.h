//
//  TBReleasePreviewHeadeTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2017/4/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//
typedef void(^Cellheight)(void);

#import <UIKit/UIKit.h>

@interface TBReleasePreviewHeadeTableViewCell : UITableViewCell

@property (nonatomic, copy) Cellheight cellheight;

- (void)updataText:(NSString *)text state:(BOOL)show buttonClick:(Cellheight)isShow;

@end
