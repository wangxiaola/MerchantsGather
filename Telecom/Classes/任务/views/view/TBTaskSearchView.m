//
//  TBTaskSearchView.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/5.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBTaskSearchView.h"
#import "UIButton+ImageTitleStyle.h"
#import "YBPopupMenu.h"
#import "TBBasicDataTool.h"

static NSString *prompt = @"不限套餐";
@interface TBTaskSearchView ()<UISearchBarDelegate,YBPopupMenuDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UIButton *searchButton;

@property (nonatomic, strong) NSArray <TBPackageData *>*packageData;

@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, strong) NSString *code;

@end
@implementation TBTaskSearchView

@synthesize searchButton;
- (NSMutableArray *)array
{
    if (_array == nil)
    {
        _array = [NSMutableArray array];
    }
    
    return _array;
}
- (void)initData
{
    TBWeakSelf
    [self.array removeAllObjects];
    [TBBasicDataTool initPackageData:^(NSArray<TBPackageData *> *array) {
        weakSelf.packageData = array;

        [array enumerateObjectsUsingBlock:^(TBPackageData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [weakSelf.array addObject:obj.title];
        }];
        [self.array insertObject:prompt atIndex:0];
        
    }];
}

- (instancetype)initWithFrame:(CGRect)frame typeSelection:(BOOL)type;
{
    if (self)
    {
        self = [super initWithFrame:frame];
        self.code = @"";
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self initData];
        
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.masksToBounds = YES;
        backView.layer.cornerRadius = (frame.size.height-16)/2;
        [self addSubview:backView];
        
        CGFloat lef = 0;
        CGFloat width = 0;
        if (type == YES)
        {
            lef = 16;
            width = 1;
            
        }
        
        searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        searchButton.backgroundColor = [UIColor whiteColor];
        if (type == YES)
        {
            [searchButton setTitle:prompt forState:UIControlStateNormal];
            [searchButton setImage:[UIImage imageNamed:@"task-botton"] forState:UIControlStateNormal];
        }
        searchButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [searchButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [searchButton addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:searchButton];
        [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backView.mas_left).offset(lef);
            make.top.mas_equalTo(backView.mas_top).offset(0);
            make.bottom.mas_equalTo(backView.mas_bottom).offset(0);
            if (type == NO)
            {
                make.width.mas_equalTo(0);
            }
        }];
        
        UIView *linView = [[UIView alloc] init];
        linView.backgroundColor = BODER_COLOR;
        [backView addSubview:linView];
        
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入关键字搜索";
        _searchBar.userInteractionEnabled = YES;
        _searchBar.barTintColor = [UIColor whiteColor];
        [_searchBar setBackgroundImage:[UIImage new]];
        _searchBar.returnKeyType = UIReturnKeySearch;
        [backView addSubview:_searchBar];
        
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(8);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-8);
        }];

        [linView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(searchButton.mas_right).offset(lef);
            make.top.mas_equalTo(backView.mas_top).offset(6);
            make.bottom.mas_equalTo(backView.mas_bottom).offset(-6);
            make.width.mas_equalTo(width);
        }];
        
        [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(linView.mas_right).offset(6);
            make.right.mas_equalTo(backView.mas_right).offset(6);
            make.top.mas_equalTo(backView.mas_top).offset(0);
            make.bottom.mas_equalTo(backView.mas_bottom).offset(0);
        }];
        
        if (type == YES)
        {
            [searchButton setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:2];
        }
        
        
    }
    
    return self;
}

- (void)searchClick:(UIButton*)sender
{
    [self endEditing:YES];
    
    if (self.array.count == 0 )
    {
        hudShowInfo(@"类型数据加载中");
        [self initData];
        return;
    }
    [searchButton setImage:[UIImage imageNamed:@"task-top"] forState:UIControlStateNormal];
    
    YBPopupMenu *popupMenu = [YBPopupMenu showRelyOnView:sender titles:self.array icons:nil menuWidth:140 delegate:self];
    popupMenu.offset = 5;
    popupMenu.fontSize = 14;
    popupMenu.type = YBPopupMenuTypeDefault;
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    [self endEditing:YES];
    NSString *key = searchBar.text;
    if (self.searchResult)
    {
        self.searchResult(key,self.code);
    }
    
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
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    NSString *name;
    if (index == 0)
    {
        self.code = @"";
        name = prompt;
    }
    else
    {
      TBPackageData *pack = self.packageData[index-1];
      self.code = [NSString stringWithFormat:@"%ld",(long)pack.ID];
        name = pack.title;
    }
    [searchButton setTitle:name forState:UIControlStateNormal];
    [self buttonView];
    if (self.searchResult)
    {
        self.searchResult(self.searchBar.text,self.code);
    }
    
}

- (void)ybPopupMenuBeganDismiss;
{
    [self buttonView];
}
- (void)ybPopupMenuDidDismiss;
{
    [self buttonView];
}
- (void)buttonView;
{
    [searchButton setImage:[UIImage imageNamed:@"task-botton"] forState:UIControlStateNormal];
    [searchButton setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:2];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
@end
