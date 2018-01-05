//
//  TBRoomListTableViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/11/28.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBRoomListTableViewController.h"
#import "TBRoomListTableViewCell.h"
#import "TBRoomEditorViewController.h"
#import "TBMoreReminderView.h"
#import "UIScrollView+EmptyDataSet.h"

@interface TBRoomListTableViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource>

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TBRoomListTableViewController
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"客房信息列表";
    [self configurationForm];
}
#pragma mark  ----setUI----
- (void)configurationForm
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // 创建头部视图
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _SCREEN_WIDTH, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *roomTypeLabel = [self createLabelTextString:@"房型"];
    UILabel *roomPriceLabel = [self createLabelTextString:@"价格(元)"];
    UILabel *roomNumberLabel = [self createLabelTextString:@"房间数"];
    
    [headerView addSubview:roomTypeLabel];
    [headerView addSubview:roomPriceLabel];
    [headerView addSubview:roomNumberLabel];
    [self.view addSubview:headerView];
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"TBRoomListTableViewCell" bundle:nil] forCellReuseIdentifier:TBRoomListTableViewCellID];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // 布局
    TBWeakSelf
    [roomTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(roomPriceLabel.mas_width);
        make.width.equalTo(roomNumberLabel.mas_width);
        make.left.top.bottom.equalTo(headerView);
    }];
    [roomPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(roomTypeLabel.mas_right);
        make.top.bottom.equalTo(headerView);
    }];
    [roomNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(roomPriceLabel.mas_right);
        make.top.bottom.equalTo(headerView);
        make.right.equalTo(headerView).offset(-50);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(headerView.mas_bottom);
    }];

}
#pragma mark  ----funs----
// 重新编辑
- (void)formAssignmentIndex:(NSInteger)index
{
    TBRoomEditorViewController *vc = [[TBRoomEditorViewController alloc] init];
    [vc editorData:self.roomData[index] indexRow:index];
    TBWeakSelf
    [vc setUpdataTableView:^(NSDictionary *data, NSInteger index) {
        // 数据更新
        [weakSelf.roomData replaceObjectAtIndex:index withObject:data];
        [weakSelf.tableView reloadData];
        [UIView addMJNotifierWithText:@"数据编辑成功" dismissAutomatically:YES];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
// 删除
- (void)removePoorWorkersDataIndex:(NSInteger)index
{
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"亲！真的要删除这个房间信息吗？"];
    TBWeakSelf
    [more showHandler:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 更新界面
            [weakSelf.roomData removeObjectAtIndex:index];
            [UIView addMJNotifierWithText:@"数据已删除" dismissAutomatically:YES];
            [weakSelf.tableView reloadData];
        }];
    }];
}
- (UILabel *)createLabelTextString:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.roomData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBRoomListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TBRoomListTableViewCellID];
    if (self.roomData.count > indexPath.section) {
        [cell updataCellTextData:self.roomData[indexPath.section]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    TBWeakSelf
    [alert addAction:[UIAlertAction actionWithTitle:@"重新编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        [weakSelf formAssignmentIndex:indexPath.section];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        [weakSelf removePoorWorkersDataIndex:indexPath.section];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
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
    
    text = @"暂无数据可加载";
    font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.75];
    textColor = [UIColor grayColor];
    paragraph.lineSpacing = 3.0;
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
