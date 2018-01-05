//
//  TBBossPromptView.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/28.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBossPromptView.h"

@implementation TBBossPromptView

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
        self.backgroundColor = [UIColor whiteColor];
        
        NSString *str = @"不知道说什么？可以试试这样说:\n1.欢迎五湖四海的朋友光临我在什么位置的店\n2.我的店铺我推荐，本店最大特色是什么\n3.我热情邀请你来旅游、来玩，谢谢";
        
        UILabel *prompLabel = [self createLabel];
        [self setLabelSpace:prompLabel withValue:str withFont:[UIFont systemFontOfSize:14]];
        [self addSubview:prompLabel];
        
        [prompLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(18);
            make.right.equalTo(self.mas_right).offset(-18);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom).offset(-8);
        }];

        
    }
    
    return self;
}
-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    paraStyle.alignment = NSTextAlignmentLeft;
    
    paraStyle.lineSpacing = 4; //设置行间距
    
    paraStyle.hyphenationFactor = 1.0;
    
    paraStyle.firstLineHeadIndent = 0.0;
    
    paraStyle.paragraphSpacingBefore = 0.0;
    
    paraStyle.headIndent = 0;
    
    paraStyle.tailIndent = 0;
    
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    
    label.attributedText = attributeStr;
    
}
- (UILabel *)createLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    
    return label;
}
@end
