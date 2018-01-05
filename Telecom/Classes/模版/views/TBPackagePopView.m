//
//  TBPackagePopView.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/20.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBPackagePopView.h"
#import "TBBasicDataTool.h"

@interface TBPackagePopView ()

@property (nonatomic, strong)  UIView *contenView;
@property (nonatomic ,strong) NSArray *selectArray;
@end
@implementation TBPackagePopView

- (instancetype)init
{
    self =[super initWithFrame:APPDELEGATE.window.bounds];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.contenView = [[UIView alloc] init];
        //shadowColor阴影颜色
        self.contenView.layer.shadowColor = [UIColor blackColor].CGColor;
        //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.contenView.layer.shadowOffset = CGSizeMake(0,-6);
        //阴影透明度，默认0
        self.contenView.layer.shadowOpacity = 0.6;
        //阴影半径，默认3
        self.contenView.layer.shadowRadius = 4;
        self.contenView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contenView];

    }
    return self;
}

// 创建button
- (UIButton *)createButtonAction:(SEL)action
{
      UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    button.backgroundColor = NAVIGATION_COLOR;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 4;
    button.titleLabel.font = [UIFont systemFontOfSize:18 weight:0.2];
    button.layer.masksToBounds = YES;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
#pragma mark ---click ---
- (void)cancelButtonClick
{
    [self hideButtonClick];
    
}
- (void)packageClick:(UIButton *)button
{
    NSInteger row = button.tag - 1000;
    if (self.selectArray.count >row)
    {
     TBPackageData *data = self.selectArray[row];
        if (self.successful)
        {
            self.successful(data);
        }
    }
    [self hideButtonClick];

}
#pragma mark --- 初始化数控--
// 弹出选择框
- (void)showPackageData:(NSArray <TBPackageData *> *)arrat selectData:(selectSuccessful)selectData;
{
    self.successful = selectData;
    self.selectArray = arrat;
    
    UIButton *cancelButton = [self createButtonAction:@selector(cancelButtonClick)];
    cancelButton.backgroundColor = [UIColor orangeColor];
    [cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    [self.contenView addSubview:cancelButton];
    CGFloat margin = 16;//边距
    CGFloat spacing = 10;//间距
    CGFloat cellHeghit = 44;//高
    TBWeakSelf
    [self.contenView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(weakSelf);
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contenView.mas_bottom).offset(-26);
        make.left.equalTo(weakSelf.contenView.mas_left).offset(margin);
        make.right.equalTo(weakSelf.contenView.mas_right).offset(-margin);
        make.height.mas_equalTo(cellHeghit);
    }];
    
   __block CGFloat addHeghit = 26*2+cellHeghit;
    
    [arrat enumerateObjectsUsingBlock:^(TBPackageData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = [weakSelf createButtonAction:@selector(packageClick:)];
        button.tag = idx+1000;
        NSString *buttonName = @"";
        if ([obj.title containsString:@"29"]) {
            buttonName = PACKAGE_29;
        }
        else if ([obj.title containsString:@"99"])
        {
            buttonName = PACKAGE_99;
        }
        else
        {
            buttonName = obj.title;
        }
        [button setTitle:buttonName forState:UIControlStateNormal];
        [weakSelf.contenView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(weakSelf.contenView.mas_left).offset(margin);
            make.right.equalTo(weakSelf.contenView.mas_right).offset(-margin);
            make.height.mas_equalTo(cellHeghit);
            

            if (idx == arrat.count -1)
            {
                make.top.equalTo(weakSelf.contenView.mas_top).offset(20);
            }
      
            make.bottom.equalTo(weakSelf.contenView.mas_bottom).offset(-addHeghit);
            
            
            
        }];
        
        addHeghit = addHeghit +cellHeghit +spacing;
    }];
    
    [self layoutIfNeeded];
    [self show];

}
-(void)show;
{
    self.alpha = 1;
    
    
    [[APPDELEGATE window] addSubview:self];
    self.contenView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contenView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.contenView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}

-(void)hideButtonClick{
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}
@end
