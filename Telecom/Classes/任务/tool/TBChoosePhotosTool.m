//
//  TBChoosePhotosTool.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/12.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBChoosePhotosTool.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "TZImageManager.h"
#import "ZKNavigationController.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface TBChoosePhotosTool ()<TZImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray *imageArray;
/**
 是否正在显示图片选择器
 */
@property (nonatomic, assign) BOOL isShowPhotos;
@end

@implementation TBChoosePhotosTool

- (NSMutableArray *)imageArray
{
    if (!_imageArray)
    {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)showPhotosIndex:(NSInteger)number;
{
    self.isShowPhotos = NO;
    [self verifyPermissionsPhontos:number isCrop:NO];
}

/**
 头像图片选择（裁剪）
 
 @param controller vc
 */
- (void)showHeadToChooseViewController:(UIViewController *)controller;
{
    self.isShowPhotos = NO;
    [self verifyPermissionsPhontos:1 isCrop:YES];
}
- (void)showPreviewPhotosArray:(NSArray *)array baseView:(UIImageView*)view selected:(NSInteger)num;
{
    [self.imageArray removeAllObjects];
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.srcImageView = view; // 来源于哪个UIImageView
        if ([obj isKindOfClass:[UIImage class]])
        {
            photo.image = obj; // 图片路径
        }
        else
        {
            NSString *url = obj;
            if (![url containsString:IMAGE_URL]) {
                url = [NSString stringWithFormat:@"%@%@",IMAGE_URL,url];
            }
            photo.url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]; // 图片路径
        }
        [self.imageArray addObject:photo];
    }];
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = num; // 弹出相册时显示的第一张图片是？
    browser.photos = self.imageArray; // 设置所有的图片
    browser.isDelete = YES;
    [browser show];
}
#pragma mark  ----创建----
// 验证权限
- (void)verifyPermissionsPhontos:(NSInteger)maxCount isCrop:(BOOL)crop
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self verifyPermissionsPhontos:maxCount isCrop:crop];
                    });
                }
            }];
        } else {
            [self verifyPermissionsPhontos:maxCount isCrop:crop];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self verifyPermissionsPhontos:maxCount isCrop:crop];
        }];
    } else {
        [self pushTZImagePickerControllerPhontos:maxCount isCrop:crop];
    }
}

/**
 创建图片选择器
 
 @param maxCount 数量
 @param crop 是否裁剪
 */
- (void)pushTZImagePickerControllerPhontos:(NSInteger)maxCount isCrop:(BOOL)crop;
{
    if (self.isShowPhotos == YES)
    {
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    // 1.设置目前已经选中的图片数组
    imagePickerVc.isSelectOriginalPhoto = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    }
    else
    {
        imagePickerVc.allowTakePicture = NO;
    }
    
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    
    if (crop == YES)
    {
        imagePickerVc.showSelectBtn = NO;
        imagePickerVc.allowCrop = crop;
        imagePickerVc.needCircleCrop = NO;
        // 设置竖屏下的裁剪尺寸
        NSInteger left = 30;
        NSInteger widthHeight = _SCREEN_WIDTH - 2 * left;
        NSInteger top = (_SCREEN_HEIGHT - widthHeight) / 2;
        imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    }
    
    imagePickerVc.isStatusBarDefault = NO;
#pragma mark - 到这里为止
    
    [[ZKUtil getPresentedViewController] presentViewController:imagePickerVc animated:YES completion:nil];
    self.isShowPhotos = YES;
}
#pragma mark  ----TZImagePickerControllerDelegate----
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto;
{
    if ([self.delegate respondsToSelector:@selector(choosePhotosArray:)]&&photos.count > 0) {
        [self.delegate choosePhotosArray:photos];
    }
}
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker;
{
}

// 决定相册显示与否 albumName:相册名字 result:相册原始数据
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(id)result;
{
    return YES;
}
// 决定照片显示与否
- (BOOL)isAssetCanSelect:(id)asset;
{
    return YES;
}
@end
