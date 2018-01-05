//
//  TBRoomEditorViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/11/28.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBRoomEditorViewController.h"
#import "TBMoreReminderView.h"
#import "TBChoosePhotosTool.h"
#import "TBTemplateResourceCollectionViewCell.h"

@interface TBRoomEditorViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,TBChoosePhotosToolDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *editorTypeField;
@property (weak, nonatomic) IBOutlet UITextField *editorPriceField;
@property (weak, nonatomic) IBOutlet UITextField *editorNumberField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

@property (strong, nonatomic) NSMutableArray *imageArray;
// 房型索引
@property (assign, nonatomic) NSInteger roomIndex;

@property (strong, nonatomic) NSDictionary *data;

@property (assign, nonatomic) CGFloat  cellWidth;
// 最大选择数
@property (assign, nonatomic) NSInteger maxRow;
// 默认无照片显示数量
@property (assign, nonatomic) NSInteger defaultRow;

@property (strong, nonatomic) NSString *defaultName;
@end

@implementation TBRoomEditorViewController
{
    TBChoosePhotosTool       *tool;
}
- (NSMutableArray *)imageArray
{
    
    if (!_imageArray)
    {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (_SCREEN_HEIGHT == 812) {
        self.bottomViewHeight.constant = 50 + 32;
    }
    self.navigationItem.title = @"客房信息编辑";
    [self setUpViews];
}
#pragma mark  ----视图添加设置----
- (void)setUpViews;
{
    tool = [[TBChoosePhotosTool alloc] init];
    tool.delegate = self;
    self.cellWidth = (_SCREEN_WIDTH-(10*2)-16*2-1)/3;
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    [flowlayout setItemSize:CGSizeMake(self.cellWidth, self.cellWidth)];
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowlayout.minimumInteritemSpacing = 9;
    flowlayout.minimumLineSpacing = 9;
    flowlayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.bounces = NO;
    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerClass:[TBTemplateResourceCollectionViewCell class] forCellWithReuseIdentifier:TBTemplateResourceCollectionViewCellID];
    self.collectionView.collectionViewLayout = flowlayout;
    
    self.maxRow = 3;
    self.defaultRow = 1;
    self.defaultName = @"default_room";
    
    self.imageArray  = [[self.data valueForKey:@"img"] mutableCopy];
    self.editorTypeField.text   = [self.data valueForKey:@"type"];
    self.editorPriceField.text  = [self.data valueForKey:@"price"];
    self.editorNumberField.text = [self.data valueForKey:@"number"];
    
    [self.collectionView reloadData];
}
/**
 修改数据
 
 @param data 数据
 @param row 索引
 */
- (void)editorData:(NSDictionary *)data indexRow:(NSInteger)row;
{
    self.data = data;
    self.roomIndex = row;
}
- (IBAction)cancelClick:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveClick:(UIButton *)sender {
    
    if (self.imageArray.count == 0)
    {
        [UIView addMJNotifierWithText:@"请上传房型图片" dismissAutomatically:YES];
        return;
    }
    if (self.editorTypeField.text.length == 0)
    {
        [self showPrompts:@"请填写房型!" shakeAnimationForView:self.editorTypeField.superview];
        return;
    }
    
    if (self.editorPriceField.text.length == 0)
    {
        [self showPrompts:@"请填写价格!" shakeAnimationForView:self.editorPriceField.superview];
        return;
    }
    
    if (![ZKUtil ismoney:self.editorPriceField.text])
    {
        [self showPrompts:@"输入的价格格式错误!" shakeAnimationForView:self.editorPriceField.superview];
        return;
    }
    
    if (self.editorNumberField.text.length == 0)
    {
        [self showPrompts:@"请填写房间数量!" shakeAnimationForView:self.editorNumberField.superview];
        return;
    }
    if (![ZKUtil isInteger:self.editorNumberField.text])
    {
        [self showPrompts:@"房间数量第一位数字不能为0" shakeAnimationForView:self.editorNumberField.superview];
        return;
    }
    
    NSDictionary *dic = @{@"img":[self.imageArray mutableCopy],
                          @"type":self.editorTypeField.text,
                          @"price":self.editorPriceField.text,
                          @"number":self.editorNumberField.text};
    
    if (self.updataTableView)
    {
        self.updataTableView(dic, self.roomIndex);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 异常回馈
 
 @param meg 消息
 @param view 动画视图
 */
- (void)showPrompts:(NSString *)meg shakeAnimationForView:(UIView *)view
{
    [UIView addMJNotifierWithText:meg dismissAutomatically:YES];
    [ZKUtil shakeAnimationForView:view];
}
#pragma mark <UICollectionViewDataSource>
- (void)updataCollectionView;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.imageArray.count == self.maxRow)
    {
        return self.imageArray.count;
    }
    else
    {
        NSInteger tatol = self.imageArray.count+self.defaultRow;
        NSInteger validationRow = self.maxRow - tatol;
        return validationRow <0?self.maxRow:tatol;
    }
}
- (TBTemplateResourceCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TBTemplateResourceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TBTemplateResourceCollectionViewCellID forIndexPath:indexPath];
    
    if (indexPath.row < self.imageArray.count)
    {
        [cell valueCellImage:self.imageArray[indexPath.row] showDelete:YES index:indexPath.row];
    }
    else
    {
        NSString *imageName = self.imageArray.count == 0?self.defaultName:@"task-shangchuan-small";
        [cell valueCellImage:[UIImage imageNamed:imageName] showDelete:NO index:indexPath.row];
    }
    TBWeakSelf
    [cell setDeleteCell:^(NSInteger row)
     {
         [weakSelf friendlyPromptIndex:row];
         
     }];
    return cell;
}
// 提示
- (void)friendlyPromptIndex:(NSInteger)dex
{
    [self.view endEditing:YES];
    
    TBWeakSelf
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"亲，是否删除当前图片?"];
    [more showHandler:^{
        [weakSelf.imageArray removeObjectAtIndex:dex];
        [weakSelf.collectionView reloadData];
    }];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    if (indexPath.row<self.imageArray.count)
    {
        TBTemplateResourceCollectionViewCell *cell = (TBTemplateResourceCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        
        [tool showPreviewPhotosArray:self.imageArray baseView:cell.backImageView selected:indexPath.row];
    }
    else
    {
        [tool showPhotosIndex:self.maxRow-self.imageArray.count];
    }
}

#pragma mark ---- TBChoosePhotosToolDelegate --

- (void)choosePhotosArray:(NSArray<UIImage*>*)images;
{
    TBWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf.imageArray addObjectsFromArray:images];
        [weakSelf.collectionView reloadData];
    });
    
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
