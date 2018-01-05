
//
//  HomeHeaderView.m
//  Telecom
//
//  Created by zhangxingdong 张兴栋 on 16/12/5.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "HomeHeaderView.h"
#import "UIButton+ImageTitleStyle.h"

@interface HomeHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *bueView;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UIButton *ritButton;

@end

@implementation HomeHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.bueView.layer.cornerRadius = 1.5;
    self.bueView.layer.masksToBounds = YES;
    self.bueView.clipsToBounds = YES;
    [self.ritButton setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:2];

}
- (void)setTool:(NSInteger)tool
{
    self.ritButton.hidden = tool == 0;
}
- (void)setHeaderIndexBlock:(HeaderViewBlock)headerIndexBlock
{
    _headerIndexBlock = headerIndexBlock;
    if (self.tag == 100) {
        self.typeLabel.text = @"热门模版";
    } else {
        self.typeLabel.text = @"我的商家";
    }
}
- (IBAction)ritButtonClick:(id)sender
{
    if (self.headerIndexBlock)
    {
        self.headerIndexBlock();
    }
}


@end
