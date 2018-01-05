//
//  TBFolkAppearanceView.m
//  Telecom
//
//  Created by 王小腊 on 2017/11/27.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBFolkAppearanceView.h"
#import "TBBusinessIntelligencePhotoTableViewCell.h"
#import "TBNoteTableViewCell.h"
#import "TBAppearanceTemplateTableViewCell.h"

static NSString*const  reuseIdentifier_photo = @"cell_photo";
static NSString*const  reuseIdentifier_info = @"cell_info";
static NSString*const  reuseIdentifier_template = @"cell_template";

@interface TBFolkAppearanceView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TBBusinessIntelligencePhotoTableViewCell *photoCell;
@property (nonatomic, strong) TBNoteTableViewCell *infoTextCell;
@property (nonatomic, strong) TBAppearanceTemplateTableViewCell *templateCell;

@property (nonatomic, strong) NSString *defaultImageName;
// 模板类型
@property (nonatomic, assign) NSInteger templateIndex;

@end
@implementation TBFolkAppearanceView
- (UITableView *)tableView
{
    
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.estimatedRowHeight = 44;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [_tableView registerNib:[UINib nibWithNibName:@"TBNoteTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier_info];
        [_tableView registerNib:[UINib nibWithNibName:@"TBBusinessIntelligencePhotoTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier_photo];
        [_tableView registerNib:[UINib nibWithNibName:@"TBAppearanceTemplateTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier_template];
    }
    return _tableView;
}
- (instancetype)init
{
    
    self = [super init];
    
    if (self)
    {
        [self initTableView];
    }
    return self;
}
#pragma mark ---setView---
- (void)initTableView
{
    [self.contenView addSubview:self.tableView];
    self.templateIndex = 0;
    
    self.photoCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier_photo];
    self.photoCell.maxRow = 6;
    
    self.infoTextCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier_info];
    [self.infoTextCell.promptButton setTitle:@" 客栈民宿介绍" forState:UIControlStateNormal];
    self.infoTextCell.textView.placeholder = @"简单描述您上传的图片,不超过25个字";
    
    self.infoTextCell.isLimitedNumber = NO;
    self.infoTextCell.textView.placeholder = @"请在这里对您的客栈民宿做介绍，吸引更多的住客...";
    
    self.templateCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier_template];
    
    TBWeakSelf
    
    [self.templateCell setTemplateChooseUpdate:^(NSInteger templateIndex) {
        // 记录模板
        weakSelf.templateIndex = templateIndex;
        // 滑动到底部
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
        [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
    [self.photoCell setUpdataTableView:^{
        
        [weakSelf reloadTableView];
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contenView);
    }];
    
}
#pragma mark ---tableViewDelegate---
- (void)reloadTableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0?2:1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell = self.photoCell;
        }
        else
        {
            cell = self.infoTextCell;
        }
    }
    else
    {
        cell = self.templateCell;
        [(TBAppearanceTemplateTableViewCell *)cell updateTemplateImageIndex:self.templateIndex];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
#pragma mark ----

/**
 数据更新
 
 @param makingList 数据
 @return 标题字典
 */
- (NSDictionary *)updataData:(TBMakingListMode *)makingList;
{
    self.makingList = makingList;
    
    self.templateIndex = [makingList.appearanceTemplateIndex integerValue];
    NSString *info = makingList.appearanceText;
    NSMutableArray *array = makingList.appearancePhotos;
    self.defaultImageName = @"default_appearance";
    
    self.photoCell.defaultName = self.defaultImageName;
    
    if (info.length >0)
    {
        self.infoTextCell.textView.text = info;
    }
    
    TBWeakSelf
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[NSString class]])
            {
                NSString *data = obj;
                if (data.length >200)
                {
                    NSData *_decodedImageData   = [[NSData alloc] initWithBase64EncodedString:obj options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
                    if (_decodedImage)
                    {
                        [array replaceObjectAtIndex:idx withObject:_decodedImage];
                    }
                    else
                    {
                        [array removeObjectAtIndex:idx];
                    }
                }
            }
            
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.photoCell.imageArray = array;
            [weakSelf.photoCell updataCollectionView];
            [weakSelf reloadTableView];
        });
    });
     return @{@"name":@"外观图片",@"prompt":@"(必填)"};
}

/**
 数据提交
 
 @param prompt 是否提示
 @return yes 可以进行下一步
 */
- (BOOL)updataMakingIsPrompt:(BOOL)prompt;
{
    self.makingList.appearancePhotos = self.photoCell.imageArray;
    self.makingList.appearanceText = self.infoTextCell.textView.text;
    self.makingList.appearanceTemplateIndex = [NSString stringWithFormat:@"%ld",self.templateIndex];
    
    if (self.makingList.appearancePhotos.count == 0)
    {
        prompt == NO ? : [UIView addMJNotifierWithText:@"请至少选择一张外观图片" dismissAutomatically:YES];
        return NO;
    }
    if (self.makingList.appearanceText.length == 0) {
        
        prompt == NO ? : [UIView addMJNotifierWithText:@"请填写客栈民宿介绍！" dismissAutomatically:YES];
        return NO;
    }
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
