//
//  TBEarningsContentTableView.m
//  Telecom
//
//  Created by 王小腊 on 2017/8/9.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBEarningsContentTableView.h"
#import "TBEarningsTableViewCell.h"
#import "TBEarningsESRootClass.h"
#import "UIScrollView+EmptyDataSet.h"

@interface TBEarningsContentTableView()<UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSArray <TBEarningsRoot *>*root;
@end

@implementation TBEarningsContentTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"TBEarningsTableViewCell" bundle:nil] forCellReuseIdentifier:TBEarningsTableViewCellID];
        [self registerClass:[TBEarningsHeaderView class] forHeaderFooterViewReuseIdentifier:TBEarningsHeaderViewID];
        [self registerClass:[TBEarningsFooterView class] forHeaderFooterViewReuseIdentifier:TBEarningsFooterViewID];
        
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        
    }
    return self;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
}

- (void)setContentOffset:(CGPoint)contentOffset {
    if (self.window) {
        [super setContentOffset:contentOffset];
    }
}
#pragma mark  ----tableview----
/**
 更新数据
 
 @param rootClass 数组
 */
- (void)updataTableViewData:(NSArray *)rootClass;
{
    self.root = rootClass;
    [self reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return self.root.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    TBEarningsRoot *root = [self.root objectAtIndex:section];
    return root.details.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TBEarningsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TBEarningsTableViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.root.count > indexPath.section)
    {
      TBEarningsRoot *root = [self.root objectAtIndex:indexPath.section];
        if (root.count > indexPath.row)
        {
         
            [cell updataCellData:[root.details objectAtIndex:indexPath.row]];
        }
    }
    return cell;
}
#pragma mark ---DZNEmptyDataSetSource--

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    text = @"暂无数据可加载，点击加载";
    font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.75];
    textColor = [UIColor grayColor];
    paragraph.lineSpacing = 3.0;
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:NAVIGATION_COLOR range:[attributedString.string rangeOfString:@"点击加载"]];
    
    return attributedString;
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 10.0f;
}
// 返回可点击按钮的 image
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"sure_placeholder_error"];
}
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *imageName = @"sure_placeholder_error";
    
    if (state == UIControlStateNormal) imageName = [imageName stringByAppendingString:@"_normal"];
    if (state == UIControlStateHighlighted) imageName = [imageName stringByAppendingString:@"_highlight"];
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsZero;
    
    return [[[UIImage imageNamed:imageName] resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}
#pragma mark ---DZNEmptyDataSetDelegate--

// 处理按钮的点击事件
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view;
{
    if (self.requestData)
    {
        self.requestData();
    }
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button;
{
    if (self.requestData)
    {
        self.requestData();
    }
}

@end
