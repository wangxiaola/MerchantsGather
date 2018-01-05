//
//  DYTopTabView.m
//  slyjg
//
//  Created by 汤亮 on 16/3/9.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "ZKTopTabView.h"

@interface ZKTopTabView()
@property (nonatomic, strong) NSMutableArray <UIButton *> *btns;
@property (nonatomic, strong) NSMutableArray <UIView *> *separatorlines;

@property (nonatomic, weak) UIButton *selectedBtn;

@property (nonatomic, weak) MASConstraint *marklineLeft;
@end

@implementation ZKTopTabView

- (NSMutableArray<UIButton *> *)btns
{
    if (_btns == nil) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (NSMutableArray<UIView *> *)separatorlines
{
    if (_separatorlines == nil) {
        _separatorlines = [NSMutableArray array];
    }
    return _separatorlines;
}

- (instancetype)initWithTitles:(NSArray <NSString *> *)titles
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.titles = titles;
        if (titles.count > 0) {
            [self setup];
        }
    }
    return self;
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;

}

- (void)topTabBtnClick:(UIButton *)btn
{
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
    
    NSInteger index = [self.btns indexOfObject:btn];
    self.selectedIndex = index;
    if (self.tabBtnClickCallback) {
        self.tabBtnClickCallback(index);
    }
    self.marklineLeft.offset(self.bounds.size.width / self.titles.count * index);
}

- (void)selectTabBtnAtIndex:(NSInteger)index
{
    if (self.btns.count >0)
    {
      [self topTabBtnClick:self.btns[index]];      
    }
}

- (void)setup
{
    [self.btns removeAllObjects];
    TBWeakSelf
    //创建所有btn分割线
    for (int i = 0; i < self.titles.count - 1; i++) {
        UIView *separatorline = [[UIView alloc] init];
        separatorline.backgroundColor = BODER_COLOR;
        [self addSubview:separatorline];
        [self.separatorlines addObject:separatorline];
    }
    
    //创建所有btn
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:NAVIGATION_COLOR forState:UIControlStateSelected];
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(topTabBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.btns addObject:btn];
    }
    
    //添加所有btn分割线约束
    for (int i = 0; i < self.separatorlines.count; i++) {
        [self.separatorlines[i] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.mas_centerY);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(20);
        }];
    }
    
    //添加所有btn约束
    for (int i = 0; i < self.btns.count; i++) {
        //设置所有btn宽度相等
        if (i != self.btns.count - 1) {
            [self.btns[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(weakSelf.btns[i+1].mas_width);
            }];
        }
        //添加上下边约束
        [self.btns[i] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.mas_top);
            make.bottom.equalTo(weakSelf.mas_bottom);
        }];
        //添加关系约束
        if (i == 0) {
            [self.btns[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.mas_left);
                make.right.equalTo(weakSelf.separatorlines[i].mas_left);
            }];
        }else if (i == self.btns.count - 1) {
            [self.btns[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.separatorlines[i-1].mas_right);
                make.right.equalTo(weakSelf.mas_right);
            }];
        }else {
            [self.btns[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.separatorlines[i-1].mas_right);
                make.right.equalTo(weakSelf.separatorlines[i].mas_left);
            }];
        }
    }
    
    //创建标识线
    UIView *markline = [[UIView alloc] init];
    markline.backgroundColor = NAVIGATION_COLOR;
    [self addSubview:markline];
    
    //添加标识线约束
    [markline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(weakSelf.btns[0].mas_width);
        make.bottom.equalTo(weakSelf.mas_bottom);
        weakSelf.marklineLeft = make.left.equalTo(weakSelf.mas_left);
    }];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 0.5);
    CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
    CGContextMoveToPoint(ctx, 0, self.bounds.size.height);
    CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height);
    CGContextStrokePath(ctx);
}

@end




