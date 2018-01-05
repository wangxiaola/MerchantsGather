//
//  TBPublishingGroupViewMode.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/18.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBPublishingGroupViewMode.h"
#import "TBUploadPromptHUD.h"

@interface TBPublishingGroupViewMode()

@property (nonatomic, strong) TBUploadPromptHUD *uploadHUD;
@property (nonatomic, assign) BOOL isUpload;
@property (nonatomic, assign) CGFloat index;
@end
@implementation TBPublishingGroupViewMode
- (TBUploadPromptHUD *)uploadHUD
{
    if (_uploadHUD == nil)
    {
        _uploadHUD = [[TBUploadPromptHUD alloc] init];
        _uploadHUD.prompStr = @"资源上传中...";
    }
    return _uploadHUD;
}

- (void)postPublishingGroupData:(NSString *)ID groupData:(void(^)(TBPublishingGroupList *list))data;
{
    if (ID)
    {
        hudShowLoading(@"请稍等");
        NSMutableDictionary *dic = [NSMutableDictionary params];
        [dic setObject:@"220" forKey:@"interfaceId"];
        [dic setObject:ID forKey:@"id"];
        [ZKPostHttp post:@"" params:dic success:^(id responseObj) {
            
            NSString *errcode = [responseObj valueForKey:@"errcode"];
            if ([errcode isEqualToString:@"00000"])
            {
                hudDismiss();
                NSDictionary *dataDic = [responseObj valueForKey:@"data"];
                TBPublishingGroupList *mode = [TBPublishingGroupList mj_objectWithKeyValues:dataDic];
                if (data)
                {
                    data(mode);
                }
            }
            else
            {
                hudShowError(@"数据异常");
            }
            
        } failure:^(NSError *error) {
            hudShowError(@"网络异常");
        }];
        
    }

}

- (void)requestData:(TBPublishingGroupList *)mode successful:(void(^)(void))successful;
{
 
    self.index = (1-0.2)/mode.imgs.count;
    self.isUpload = YES;
    self.uploadHUD.prompStr = @"资源上传中...";
    [self.uploadHUD showViewCancelUpload:^{
        self.isUpload = NO;
    }];

    __block  NSString *imags = @"";
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    TBWeakSelf
    [self uploadingResourcesArray:mode.imgs resourcesType:0 resultArray:^(NSArray *array) {
       
        if (array.count == mode.imgs.count)
        {
            imags = [array componentsJoinedByString:IMAGE_OPERATOR];
        }
        else
        {
            [weakSelf hudErr];
        }
        dispatch_group_leave(group);
        
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (imags.length == 0)
        {
           [weakSelf hudErr];
        }
        else if (weakSelf.isUpload == YES)
        {
            NSMutableDictionary *dic = [NSMutableDictionary params];
            [dic setObject:@"237" forKey:@"interfaceId"];
            [dic setObject:mode.name forKey:@"name"];
            [dic setObject:mode.price forKey:@"price"];
            [dic setObject:mode.sellprice forKey:@"sellprice"];
            [dic setObject:mode.num forKey:@"number"];
            [dic setObject:mode.ginfo forKey:@"ginfo"];
            [dic setObject:[mode.info componentsJoinedByString:IMAGE_OPERATOR] forKey:@"info"];
            [dic setObject:mode.sdate forKey:@"sdate"];
            [dic setObject:mode.edate forKey:@"edate"];
            [dic setObject:mode.time forKey:@"ptime"];
            [dic setObject:imags forKey:@"imgs"];
            [dic setObject:mode.limitnum forKey:@"limitnumber"];
            [dic setObject:mode.bookdate forKey:@"limitdate"];
            [dic setObject:mode.refund forKey:@"refundate"];
            [dic setObject:mode.buyknow forKey:@"buyknow"];
            if (mode.ID.integerValue >0)
            {
              [dic setObject:mode.ID forKey:@"shopid"];
            }
            if (mode.shopid.integerValue>0)
            {
            [dic setObject:mode.shopid forKey:@"shopid"];
            }
            
            [ZKPostHttp post:@"" params:dic success:^(id responseObj) {
                
                NSString *errcode = [responseObj valueForKey:@"errcode"];
                NSString *errmsg = [responseObj valueForKey:@"errmsg"];
                if ([errcode isEqualToString:@"00000"])
                {
                    [weakSelf hudShowMsg:errmsg];
                    if (successful)
                    {
                        successful();
                    }
                }
                else
                {
                  [weakSelf hudErr];
                  hudShowError(errmsg);
                }
            } failure:^(NSError *error) {
                [weakSelf hudErr];
                hudShowError(@"网络异常");
            }];

        }
        
    });

}
#pragma mark ---- 资源上传 ----

/**
 资源上传
 
 @param datas 数据资源
 @param type 资源类型 0图片  1视频  2音频
 */
- (void )uploadingResourcesArray:(NSArray*)datas resourcesType:(NSInteger)type  resultArray:(void (^)(NSArray *array))responseArray;

{
    // 准备保存结果的数组
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:datas.count];
    NSMutableDictionary *dic =[NSMutableDictionary params];
    dic[@"interfaceId"] = @"184";
    
    dispatch_group_t group = dispatch_group_create();
    for (NSInteger i = 0; i < datas.count; i++)
    {
        dispatch_group_enter(group);
        
        id data = datas[i];
        
        if (![data isKindOfClass:[NSString class]])
            
        {
            if (type == 0)
            {
                if ([data isKindOfClass:[UIImage class]])
                {
                    data = UIImageJPEGRepresentation(data, 1.0);
                    
                }
            }
            TBWeakSelf
            [ZKPostHttp scPpostImage:POST_URL params:dic dataArray:data type:type success:^(id responseObj, NSInteger dataType)
             {
                 MMLog(@"类型-%ld 第 %d 张图片上传成功: %@", (long)type,(int)i + 1, responseObj);
                 [weakSelf hudProgress:weakSelf.index];
                 @synchronized (result) {
                     // NSMutableArray 是线程不安全的，所以加个同步锁
                     NSString *url = [responseObj valueForKey:@"url"];
                     if (url.length >0)
                     {
                         [result addObject:url];
                     }
                 }
                 dispatch_group_leave(group);
                 
                 
             } failure:^(NSError *error, NSInteger dataType) {
                 MMLog(@"类型-%ld 第 %d 张图片上传失败",(long)type, (int)i + 1);
                 dispatch_group_leave(group);
             }];
            
        }
        else
        {
            [result addObject:data];
            dispatch_group_leave(group);
        }
        
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (responseArray)
        {
            if (result.count == datas.count)
            {
                responseArray(result);
            }
            else
            {
                responseArray(nil);
            }
            
        }
    });
    
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
- (void)hudErr
{
    TBWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf.uploadHUD uploadErr];
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
