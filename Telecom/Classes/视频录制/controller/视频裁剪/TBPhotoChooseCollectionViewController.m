//
//  TBPhotoChooseCollectionViewController.m
//  Telecom
//
//  Created by 王小腊 on 2018/1/29.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBPhotoChooseCollectionViewController.h"
#import "TBClipVideoViewController.h"
#import "TBPhotoVideoChooseCollectionViewCell.h"
#import "SCRecordSessionSegment+LZAdd.h"
#import "UIScrollView+EmptyDataSet.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface TBPhotoChooseCollectionViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *videoListSegmentArrays;


@end

@implementation TBPhotoChooseCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
- (instancetype)init
{
    // 创建一个流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置cell的尺寸
    CGFloat width = (_SCREEN_WIDTH- 5*5)/4 - 0.1;
    layout.itemSize = CGSizeMake(width, width);
    // 设置滚动的方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 行间距
    layout.minimumLineSpacing = 5;
    // 设置cell之间的间距
    layout.minimumInteritemSpacing = 5;
    //    // 组间距
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    return [super initWithCollectionViewLayout:layout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的视频";

    [self configuration];
    // Do any additional setup after loading the view.
}
#pragma mark  ----配置----
- (void)configuration
{
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    [self.collectionView registerClass:[TBPhotoVideoChooseCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.bounces = YES;
    self.collectionView.alwaysBounceVertical = YES;
    
    
    self.collectionView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(verifyAuthorization)];
    [self.collectionView.mj_header beginRefreshing];
    

}
#pragma mark  ----数据加载----
/** 验证授权信息 */
- (void)verifyAuthorization
{
    NSString *tipTextWhenNoPhotosAuthorization; // 提示语
    
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    
    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
        tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
        // 展示提示语
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:tipTextWhenNoPhotosAuthorization delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        [self getAlbumsGroup];
    }
}

- (void)getAlbumsGroup
{
    WS(weakSelf);
    [self.videoListSegmentArrays removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            //获取所有group
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {//从group里面
                NSString* assetType = [result valueForProperty:ALAssetPropertyType];
                if([assetType isEqualToString:ALAssetTypeVideo]){
    
                    NSDictionary *assetUrls = [result valueForProperty:ALAssetPropertyURLs];
            
                    for (NSString *assetURLKey in assetUrls) {

                        SCRecordSessionSegment * segment = [[SCRecordSessionSegment alloc] initWithURL:assetUrls[assetURLKey] info:nil];
                        
                        if (CMTimeGetSeconds(segment.duration) >= self.miniTime) {
                          [weakSelf.videoListSegmentArrays addObject:segment];
                        }
                        
                    }

                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                    [self.collectionView reloadData];
                    [self.collectionView.mj_header endRefreshing];
                });
                
            }];
        } failureBlock:^(NSError *error) {
          
            [self.collectionView.mj_header endRefreshing];
        }];
       
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.videoListSegmentArrays.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TBPhotoVideoChooseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (self.videoListSegmentArrays) {
        
        SCRecordSessionSegment * segment = self.videoListSegmentArrays[indexPath.row];
        
        [cell.imageView setImage:segment.thumbnail];
        cell.timeLabel.text = [NSString stringWithFormat:@" %.2f秒  ",CMTimeGetSeconds(segment.duration)];
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    SCRecordSessionSegment * segment = self.videoListSegmentArrays[indexPath.row];
    
    TBClipVideoViewController *vc =[[TBClipVideoViewController alloc] init];
    vc.selectSegment = segment;
    vc.recordTime    = self.miniTime;

    [self.navigationController pushViewController:vc animated:YES];
    
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
    
    text = @"没有符合的视频，点击加载";
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
    [self.collectionView.mj_header beginRefreshing];
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button;
{
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - 懒加载
- (NSMutableArray *)videoListSegmentArrays
{
    if (!_videoListSegmentArrays) {
        _videoListSegmentArrays = [NSMutableArray array];
    }
    
    return _videoListSegmentArrays;
}


@end
