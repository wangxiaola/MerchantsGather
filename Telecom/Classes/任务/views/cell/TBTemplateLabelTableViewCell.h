//
//  TBTemplateLabelTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/6.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXTagsView.h"

@interface TBTemplateLabelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelViewHeghit;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIView *labelBackView;

@property (nonatomic, strong) HXTagsView *tagsView;

- (void)updataTags:(NSArray *)tags TitisArray:(NSArray *)titisArray;

@end
