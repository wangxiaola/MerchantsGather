//
//  TBAdvantagesTableViewCell.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/14.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQTextView.h"

extern NSString *const TBAdvantagesTableViewCellID;

@interface TBAdvantagesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet IQTextView *textView;


@property(nonatomic, copy)void(^startRecording)(TBAdvantagesTableViewCell*cell);

@end
