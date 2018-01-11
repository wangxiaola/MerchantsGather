//
//  TBTemplateBaseView.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/9.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBTemplateBaseView.h"

@implementation TBTemplateBaseView


- (instancetype)init;
{
    self = [super init];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];

        TBWeakSelf
        self.contenView = [[UIView alloc] init];
        self.contenView.backgroundColor = BACKLIST_COLOR;
        [self addSubview:self.contenView];
        
        [weakSelf.contenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(weakSelf);
            make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-1);//55
        }];
      [self createAview];
    }
    
    return self;
    
}
/**
 子视图开始添加
 */
- (void)createAview;
{
    
}
/**
 数据更新
 
 @param makingList 数据
 @return 标题字典
 */
- (NSDictionary *)updataData:(TBMakingListMode *)makingList;
{
    return nil;
}
/**
 数据提交
 
 @param prompt 是否提示
 @return yes 可以进行下一步
 */
- (BOOL)updataMakingIsPrompt:(BOOL)prompt;
{
    return YES;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
