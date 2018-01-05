//
//  TBBackgroundImageTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/14.
//  Copyright © 2016年 王小腊. All rights reserved.
//

extern NSString *const TBBackgroundImageTableViewCellID;

#import <UIKit/UIKit.h>

@interface TBBackgroundImageTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^coverImage)(UIImage *image);

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (assign, nonatomic) BOOL isBackImage;

@end
