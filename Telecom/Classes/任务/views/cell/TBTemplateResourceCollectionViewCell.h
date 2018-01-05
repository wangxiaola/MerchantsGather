//
//  TBTemplateResourceCollectionViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/13.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const  TBTemplateResourceCollectionViewCellID;

@interface TBTemplateResourceCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void(^deleteCell)(NSInteger row);

@property (nonatomic, strong) UIImageView *backImageView;

- (void)valueCellImage:(id )image showDelete:(BOOL)show index:(NSInteger)rows;

@end
