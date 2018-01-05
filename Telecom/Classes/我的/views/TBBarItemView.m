//
//  TBBarItemView.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/27.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBarItemView.h"

@interface TBBarItemView ();

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray <UIButton *>*buttonArray;

@end
@implementation TBBarItemView
- (NSMutableArray<UIButton *> *)buttonArray
{
    if (!_buttonArray)
    {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (instancetype)init
{
    self = [ super init];
    
    if (self)
    {
        [self awakeFromNib];
    }
    
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollEnabled = YES;
    [self addSubview:self.scrollView];
    self.spacing = 12;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    // 更新
    [self updateItemsFrame];
    
}
- (void)updateItemsFrame
{
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    TBWeakSelf
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [weakSelf.scrollView addSubview:obj];
        
        if (idx == 0)
        {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.scrollView.mas_left).offset(weakSelf.spacing);
                make.top.bottom.equalTo(weakSelf);
            }];
        }
        else
        {
            UIButton *bty = weakSelf.buttonArray[idx-1];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bty.mas_right).offset(weakSelf.spacing);
                make.top.bottom.equalTo(weakSelf);
                
                if (idx == weakSelf.buttonArray.count -1)
                {
                    make.right.equalTo(weakSelf.scrollView.mas_right).offset(-weakSelf.spacing);
                }
            }];
        }
        
    }];
}

- (void)setTitelArray:(NSArray *)titelArray
{
    [self.buttonArray removeAllObjects];
    
    [titelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *bty = [UIButton buttonWithType:UIButtonTypeCustom];
        [bty setImage:[UIImage imageNamed:@"task-choice"] forState:UIControlStateNormal];
        [bty setTitle:[NSString stringWithFormat:@" %@",titelArray[idx]] forState:UIControlStateNormal];
        bty.tag = 1000+idx;
        [bty addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bty setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        bty.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.buttonArray addObject:bty];
    }];
    [self updateItemsFrame];
}
- (void)buttonClick:(UIButton *)sender
{
    NSInteger index = sender.tag -1000;
    if (self.barSelect)
    {
        self.barSelect(index);
    }
    [self selectIndex:index];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.frame.size.height);
    
    UIButton *preButton = self.buttonArray[index];
    CGRect bounds = self.scrollView.bounds;
    float offsetX = CGRectGetMinX(preButton.frame);
    bounds.origin.x = offsetX;
    bounds.origin.y = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.scrollView scrollRectToVisible:bounds animated:YES];
    });
    
}
- (void)selectIndex:(NSInteger)inde;
{
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == inde)
        {
            [obj setImage:[UIImage imageNamed:@"service-selected"] forState:UIControlStateNormal];
            [obj setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
        else
        {
            [obj setImage:[UIImage imageNamed:@"task-choice"] forState:UIControlStateNormal];
            [obj setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        
    }];
}
@end
