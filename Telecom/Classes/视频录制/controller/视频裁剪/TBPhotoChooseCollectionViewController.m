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
#import "TBMoreReminderView.h"
#import "TZImageManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface TBPhotoChooseCollectionViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSMutableArray <PHAsset *> *videoListSegmentArrays;

@property (nonatomic, strong) PHImageManager *phManager;
@property (nonatomic, strong) PHVideoRequestOptions *options;
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
    // 系统弹出授权对话框
    TBWeakSelf
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
            {
                // 用户拒绝，跳转到自定义提示页面
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            else if (status == PHAuthorizationStatusAuthorized)
            {
                // 用户授权，弹出相册对话框
                [weakSelf configuration];
            }
        });
    }];

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
    
    PHImageManager *phManager = [PHImageManager defaultManager];
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    
    self.options = options;
    self.phManager = phManager;
    
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
        TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:tipTextWhenNoPhotosAuthorization];
        [more showHandler:^{
          [self getAlbumsGroup];
        }];

    } else {
        [self getAlbumsGroup];
    }
}

- (void)getAlbumsGroup
{
    TBWeakSelf
    [self.videoListSegmentArrays removeAllObjects];
    
    __block NSInteger videos = 0;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"tz_allowPickingVideo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[TZImageManager manager] getCameraRollAlbum:YES allowPickingImage:NO completion:^(TZAlbumModel *model) {
        
        if (model.models.count == 0) {
            
            [weakSelf updateCollectionView];
        }
        else
        {
            [model.models enumerateObjectsUsingBlock:^(TZAssetModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                videos += 1;
                
                if (obj.type == TZAssetModelMediaTypeVideo) {
                    
                    PHAsset *asset = obj.asset;
                    
                    if (asset.duration >= weakSelf.miniTime) {
                        
                        [weakSelf.videoListSegmentArrays addObject:asset];
                        
                    }
                    if (videos == model.count) {
                        
                        // 更新界面
                        [weakSelf updateCollectionView];
                    }
                }
                
            }];
        }
    }];
}

/**
 更新界面
 */
- (void)updateCollectionView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    });
}
/**
 通过资源获取图片的数据
 
 @param mAsset 资源文件
 @param imageBlock 图片数据回传
 */
- (void)fetchImageWithAsset:(PHAsset*)mAsset imageBlock:(void(^)(UIImage *))imageBlock {
    
    [[PHImageManager defaultManager] requestImageForAsset:mAsset targetSize:CGSizeMake(80, 80) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *resultImage, NSDictionary *info) {
        
        if (imageBlock) {
            imageBlock(resultImage);
        }
    }];
    
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
        
        PHAsset * asset = self.videoListSegmentArrays[indexPath.row];
        [cell.imageView setImage:[UIImage imageNamed:@""]];
        [self fetchImageWithAsset:asset imageBlock:^(UIImage *image) {
            
            [cell.imageView setImage:image];
        }];
        cell.timeLabel.text = [NSString stringWithFormat:@" %.2f秒  ",asset.duration];
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset * asset = self.videoListSegmentArrays[indexPath.row];
    TBWeakSelf
    [self.phManager requestAVAssetForVideo:asset options:self.options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        
        NSURL *url = urlAsset.URL;
        
        SCRecordSessionSegment * segment = [[SCRecordSessionSegment alloc] initWithURL:url info:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            TBClipVideoViewController *vc =[[TBClipVideoViewController alloc] init];
            vc.selectSegment = segment;
            vc.recordTime    = weakSelf.miniTime;
            vc.pathQZ = weakSelf.pathQZ;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        });
    }];
    
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
- (NSMutableArray <PHAsset *> *)videoListSegmentArrays
{
    if (!_videoListSegmentArrays) {
        _videoListSegmentArrays = [NSMutableArray arrayWithCapacity:1];
    }
    return _videoListSegmentArrays;
}
- (void)dealloc
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"tz_allowPickingVideo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
