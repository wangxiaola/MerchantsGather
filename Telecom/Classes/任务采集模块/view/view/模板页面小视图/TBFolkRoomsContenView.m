//
//  TBFolkRoomsContenView.m
//  Telecom
//
//  Created by 王小腊 on 2017/11/28.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBFolkRoomsContenView.h"
#import "UIButton+ImageTitleStyle.h"
#import "TBMoreReminderView.h"
#import "TBChoosePhotosTool.h"
#import "TBTemplateResourceCollectionViewCell.h"

@interface TBFolkRoomsContenView()<UICollectionViewDataSource,UICollectionViewDelegate,TBChoosePhotosToolDelegate>

@end
@implementation TBFolkRoomsContenView
{
    __weak IBOutlet UICollectionView *collectionView;
    __weak IBOutlet UITextField *roomTypeField;
    __weak IBOutlet UITextField *priceField;
    __weak IBOutlet UITextField *numberField;
    __weak IBOutlet UIButton *addButton;
    __weak IBOutlet UIButton *toViewButton;
    __weak IBOutlet NSLayoutConstraint *collectionViewHeight;
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
#pragma mark  ----视图添加设置----

/**
 加载view
 
 @param frame frame
 @return self
 */
+ (TBFolkRoomsContenView *)loadingNibConetenViewWithFrame:(CGRect)frame;
{

    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TBFolkRoomsContenView" owner:nil options:nil];
    TBFolkRoomsContenView *view = [array lastObject];
    view.contenFrame = frame;
    [view setUpViews];
    
    return view;
}
/**
 设置控件
 */
- (void)setUpViews;
{
    addButton.layer.borderColor = RGB(227, 227, 227).CGColor;
    addButton.layer.borderWidth = 0.5;
    addButton.layer.cornerRadius = 5;
    [addButton setTitleColor:NAVIGATION_COLOR forState:UIControlStateNormal];
    
    [toViewButton setImage:[UIImage imageNamed:@"rightJt"] forState:UIControlStateNormal];
    [toViewButton setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:2];
    toViewButton.layer.borderColor = RGB(227, 227, 227).CGColor;
    toViewButton.layer.borderWidth = 0.5;
    toViewButton.layer.cornerRadius = 5;
    [toViewButton setTitleColor:NAVIGATION_COLOR forState:UIControlStateNormal];
    
    
    tool = [[TBChoosePhotosTool alloc] init];
    tool.delegate = self;
    self.cellWidth = (_SCREEN_WIDTH-(10*2)-16*2-1)/3;
    collectionViewHeight.constant = 118;
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    [flowlayout setItemSize:CGSizeMake(self.cellWidth, self.cellWidth)];
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowlayout.minimumInteritemSpacing = 9;
    flowlayout.minimumLineSpacing = 9;
    flowlayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.bounces = NO;
    collectionView.scrollEnabled = NO;
    [collectionView registerClass:[TBTemplateResourceCollectionViewCell class] forCellWithReuseIdentifier:TBTemplateResourceCollectionViewCellID];
    collectionView.collectionViewLayout = flowlayout;
    
    self.maxRow = 3;
    self.defaultRow = 1;
    self.defaultName = @"default_room";

}

#pragma mark  ----按钮点击事件----
- (IBAction)addRoomClick:(UIButton *)sender {
    
    if (self.imageArray.count == 0)
    {
        [UIView addMJNotifierWithText:@"请上传房型图片" dismissAutomatically:YES];
        return;
    }
    if (roomTypeField.text.length == 0)
    {
        [self showPrompts:@"请填写房型!" shakeAnimationForView:roomTypeField.superview];
        return;
    }
    
    if (priceField.text.length == 0)
    {
        [self showPrompts:@"请填写价格!" shakeAnimationForView:priceField.superview];
        return;
    }
    
    if (![ZKUtil ismoney:priceField.text])
    {
        [self showPrompts:@"输入的价格格式错误!" shakeAnimationForView:priceField.superview];
        return;
    }
    
    if (numberField.text.length == 0)
    {
        [self showPrompts:@"请填写房间数量!" shakeAnimationForView:numberField.superview];
        return;
    }
    if (![ZKUtil isInteger:numberField.text])
    {
        [self showPrompts:@"房间数量第一位数字不能为0" shakeAnimationForView:numberField.superview];
        return;
    }
    
    NSDictionary *dic = @{@"img":[self.imageArray mutableCopy],
                          @"type":roomTypeField.text,
                          @"price":priceField.text,
                          @"number":numberField.text};
    
    if ([self.delegate respondsToSelector:@selector(increaseTheGuestRoomData:)]) {
        [self.delegate increaseTheGuestRoomData:dic];
        
        [self.imageArray removeAllObjects];
        roomTypeField.text = @"";
        priceField.text    = @"";
        numberField.text   = @"";
        [collectionView reloadData];
    }
    
}
- (IBAction)toViewRoomClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(lookAtAllTheRoom)]) {
        
        [self.delegate lookAtAllTheRoom];
    }
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
        [collectionView reloadData];
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
    [self endEditing:YES];
    
    TBWeakSelf
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"亲，是否删除当前图片?"];
    [more showHandler:^{
        [weakSelf.imageArray removeObjectAtIndex:dex];
        [collectionView reloadData];
    }];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self endEditing:YES];
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
        [collectionView reloadData];
    });
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)drawRect:(CGRect)rect
{
    self.frame = self.contenFrame;//关键点在这里
}
@end
