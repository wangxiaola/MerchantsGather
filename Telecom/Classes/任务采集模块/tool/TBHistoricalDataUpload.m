//
//  TBHistoricalDataUpload.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/22.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBHistoricalDataUpload.h"
#import "TBUploadPromptHUD.h"
#import "TBMakingListMode.h"
#import "TBTaskMakeViewMode.h"

@interface TBHistoricalDataUpload ()
@property (nonatomic, strong) TBUploadPromptHUD *uploadHUD;

@property (nonatomic, strong) NSMutableArray <TBMakingListMode *>*successArray;
@property (nonatomic, strong) NSArray <TBMakingListMode *>*allArray;

@property (nonatomic, strong) NSMutableArray *toolArray;

@property (assign, nonatomic) BOOL isUpload;

@property (assign, nonatomic) CGFloat progress;

@end
@implementation TBHistoricalDataUpload
- (instancetype)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}
- (NSMutableArray *)toolArray
{
    if (!_toolArray)
    {
        _toolArray = [NSMutableArray array];
    }
    return _toolArray;
}
- (NSMutableArray<TBMakingListMode *> *)successArray
{
    if (!_successArray)
    {
        _successArray = [NSMutableArray array];
    }
    return _successArray;
}
- (TBUploadPromptHUD *)uploadHUD
{
    if (_uploadHUD == nil)
    {
        _uploadHUD = [[TBUploadPromptHUD alloc] init];
    }
    return _uploadHUD;
}
- (void)updataArray:(NSArray <TBMakingListMode *>*)array deleteArray:(historyData)historyArray;
{
    self.deleteSuccess = historyArray;
    [self.successArray removeAllObjects];
    self.allArray = array;
    [self authenticationInformation];
    
}
- (void)authenticationInformation
{
    self.uploadHUD.prompStr = @"努力上传中";
    self.isUpload = YES;
    TBWeakSelf
    [self.uploadHUD showViewCancelUpload:^{
        self.isUpload = NO;
        weakSelf.deleteSuccess(weakSelf.successArray);
    }];
    
    self.progress = 1/(self.allArray.count+0.2);
    
    [self.toolArray removeAllObjects];
    
    dispatch_group_t group = dispatch_group_create();
    
    [self.allArray enumerateObjectsUsingBlock:^(TBMakingListMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        if ([obj.type isEqualToString:@"service"])// 服务场所
        {
            dispatch_group_enter(group);
            TBTaskMakeViewMode *tool = [self createMakeViewTool];
            tool.makingMode = obj;
            [tool submitServiceSuccessful:^(TBMakingListMode *mode) {
                
                [weakSelf hudProgress:self.progress];
                [weakSelf.successArray addObject:mode];
                dispatch_group_leave(group);
            } failure:^{
                
                dispatch_group_leave(group);
            }];
        }
        else
        {
            dispatch_group_enter(group);
            TBTaskMakeViewMode *tool = [self createMakeViewTool];
            tool.makingMode = obj;
            [tool submitDataSuccessful:^(TBMakingListMode *mode) {
                
                [weakSelf hudProgress:self.progress];
                [weakSelf.successArray addObject:mode];
                dispatch_group_leave(group);
            } failure:^{
                dispatch_group_leave(group);
            }];
            
        }
        
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        [weakSelf hudDism];
        [self.toolArray removeAllObjects];//释放资源
        weakSelf.deleteSuccess(weakSelf.successArray);
        
    });
    
}
#pragma mark --主线程刷新--

- (TBTaskMakeViewMode *)createMakeViewTool
{
    TBTaskMakeViewMode *tool = [[TBTaskMakeViewMode alloc] init];
    tool.hiddeHUD = YES;
    [self.toolArray addObject:tool];
    return tool;
}
- (void)hudDism
{
    TBWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf.uploadHUD hideHUD];;
    });
    
}
- (void)hudShowMsg:(NSString *)msg
{
    TBWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf.uploadHUD uploadSuccessful:msg];
    });
    
}
- (void)hudProgress:(CGFloat)progress
{
    TBWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf.uploadHUD progress:progress];
    });
}
@end
