//
//  TBNoticePromptBoxView.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/10.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBNoticePromptBoxView.h"
#import "TBTaskSearchView.h"

@interface TBNoticePromptBoxView ()<UISearchBarDelegate>

@end
@implementation TBNoticePromptBoxView
{
    UIView *_contenView;
    float  _contenHeight;
    UISearchBar *_searchBar;
    UIView *_lefLinView;
    UIImageView *_lefImageView;
    UILabel *_messgeLabel;
    BOOL  _isAnimate;
    
}
- (instancetype)initShowPromptString:(NSString *)messge;
{
    
    self =[super init];
    if (self) {
        
        _contenHeight = 44;
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 4;
        //        self.layer.masksToBounds = YES;
        _contenView = [[UIView alloc] init];
        _contenView.userInteractionEnabled = YES;
        _contenView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:_contenView];
        
        _lefImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ReminderImage"]];
        [_contenView addSubview:_lefImageView];
        
        _messgeLabel = [[UILabel alloc] init];
        _messgeLabel.textColor = [UIColor whiteColor];
        _messgeLabel.font = [UIFont systemFontOfSize:13 weight:0.2];
        _messgeLabel.numberOfLines = 2;
        _messgeLabel.text = messge.length >0?messge:@"...";
        [_contenView addSubview:_messgeLabel];
        
        _lefLinView = [[UIView alloc] init];
        _lefLinView.backgroundColor = [UIColor whiteColor];
        [_contenView addSubview:_lefLinView];
        
        UIView *ritLinView = [[UIView alloc] init];
        ritLinView.backgroundColor = [UIColor whiteColor];
        [_contenView addSubview:ritLinView];
        
        UIButton *ritButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ritButton setTitle:@"搜索" forState:UIControlStateNormal];
        [ritButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ritButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        ritButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [ritButton addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
        [_contenView addSubview:ritButton];
        
        
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入关键字搜索";
        _searchBar.userInteractionEnabled = YES;
        _searchBar.barTintColor = [UIColor whiteColor];
        [_searchBar setBackgroundImage:[UIImage new]];
        _searchBar.returnKeyType = UIReturnKeySearch;
        [_contenView addSubview:_searchBar];
        
        /***布局更新**/
        [_contenView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.top.mas_equalTo(self.mas_top).offset(-_contenHeight);
            make.height.mas_equalTo(_contenHeight);
        }];
        
        [_lefImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(_contenView.mas_centerY);
            make.left.equalTo(@10);
            make.width.height.mas_equalTo(_contenHeight*0.6);
        }];
        
        [ritButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.top.bottom.equalTo(_contenView);
            make.width.mas_equalTo(_contenHeight);
        }];
        

        [_messgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_lefImageView.mas_right).offset(10);
            make.right.equalTo(_searchBar.mas_left);
            make.centerY.equalTo(_contenView.mas_centerY);
        }];
        
        [_lefLinView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(ritLinView.mas_left);
            make.top.equalTo(@10);
            make.bottom.equalTo(@-10);
        }];
        [ritLinView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.bottom.equalTo(@-10);
            make.right.equalTo(ritButton.mas_left);
            make.width.equalTo(@1);
        }];
        
        
        [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.equalTo(_contenView);
            make.left.equalTo(_lefLinView.mas_right);
            make.right.equalTo(ritLinView.mas_left);
        }];
    }
    
    return self;
    
}

- (void)showSearchKey:(SearchKey)key;
{
    self.searchKey = key;

    [self layoutIfNeeded];//强制刷新
    TBWeakSelf
    [UIView animateWithDuration:0.8 animations:^{
        
        [_contenView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(0);

        }];
        [weakSelf layoutIfNeeded];//强制绘制
    } completion:^(BOOL finished)
    {
        [weakSelf performSelector:@selector(timeAnimate) withObject:nil afterDelay:2.0f];
    }];
    
}
- (void)timeAnimate
{
    if (_isAnimate == NO)
    {
        _isAnimate = YES;
        [self layoutIfNeeded];//强制刷新
        [UIView animateWithDuration:0.6 animations:^{
            
            [_lefLinView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(_lefImageView.mas_right).offset(10);
                make.top.equalTo(@10);
                make.bottom.equalTo(@-10);
                make.width.equalTo(@1);
                make.right.equalTo(_searchBar.mas_left);
            }];
            
            [_messgeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(_lefImageView.mas_right).offset(10);
                make.width.equalTo(@0);
                make.centerY.equalTo(_contenView.mas_centerY);
            }];
            [self layoutIfNeeded];//强制绘制
        }];
    }
}
- (void)searchClick
{
    if (_isAnimate == NO)
    {
        [self timeAnimate];
    }
    if (self.searchKey&&_searchBar.text.length >0)
    {
        self.searchKey(_searchBar.text);
    }
    [_searchBar resignFirstResponder];

}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    [self endEditing:YES];
    NSString *key = _searchBar.text;
    if (self.searchKey&&_searchBar.text.length>0)
    {
        self.searchKey(key);
    }
    [_searchBar resignFirstResponder];
    
}
//让 UISearchBar 支持空搜索，当没有输入的时候，search 按钮一样可以点击
- (void)searchBarTextDidBeginEditing:(UISearchBar *) searchBar
{
    UITextField *searchBarTextField = nil;
    NSArray *views = ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) ? searchBar.subviews : [[searchBar.subviews objectAtIndex:0] subviews];
    for (UIView *subview in views)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchBarTextField = (UITextField *)subview;
            break;
        }
    }
    searchBarTextField.enablesReturnKeyAutomatically = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;
{
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
