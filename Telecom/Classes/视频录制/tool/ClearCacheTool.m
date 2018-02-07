//
//  ClearCacheTool.m
//  VideoDemo
//
//  Created by biyuhuaping on 2017/5/5.
//  Copyright © 2017年 biyuhuaping. All rights reserved.
//

#import "ClearCacheTool.h"

@implementation ClearCacheTool

/**
 清除缓存
 
 @param successful 清除成功
 */
+ (void)clearActionSuccessful:(void(^)())successful;
{
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.color = NAVIGATION_COLOR;
    [[APPDELEGATE window] addSubview:activity];
    activity.frame = CGRectMake(_SCREEN_WIDTH/2-20, _SCREEN_HEIGHT/2-20, 40, 40);
    
    [activity startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *path2 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
        NSString *path4 = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
        NSArray *array = @[path2,path4];
        
        for (NSString *path in array) {
            
            NSLog(@"\n%@\n",path);
            [self cleanCaches:path isDeleteVideo:NO];
        }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            [activity stopAnimating];
            [activity removeFromSuperview];
            if (successful) {
                successful();
            }
        });
    });
    
}
+ (CGFloat)obtainCacheSize;
{
    NSString *path1 = NSTemporaryDirectory();
    NSString *path2 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *path3 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *path4 = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
    
    CGFloat size1 = [self folderSizeAtPath:path1];
    CGFloat size2 = [self folderSizeAtPath:path2];
    CGFloat size3 = [self folderSizeAtPath:path3];
    CGFloat size4 = [self folderSizeAtPath:path4];
    MMLog(@"还剩的缓存 = %.2f",size3);
    CGFloat size = size1+size2+size4;
     
    return size;
}
// 计算目录大小
+ (CGFloat)folderSizeAtPath:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        // 将大小转化为M
        return size / 1000.0 / 1000.0;
    }
    return 0;
}

// 根据路径删除文件
+ (void)cleanCaches:(NSString *)path isDeleteVideo:(BOOL)deleteVideo
{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        
        
        for (NSString *fileName in childrenFiles) {
            
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];


        }
    }
}

@end
