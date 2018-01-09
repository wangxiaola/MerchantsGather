//
//  TBTaskMakeViewMode.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/16.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBTaskMakeViewMode.h"
#import "TBMakingListMode.h"
#import "TBUploadPromptHUD.h"
#import "TBMakingSaveTool.h"
#import "TBMoreReminderView.h"
#import "UIImage+Thumbnail.h"

@interface TBTaskMakeViewMode ()
@property (nonatomic, strong) TBMoreReminderView *more;

@property (nonatomic, strong) TBUploadPromptHUD *uploadHUD;
//记录
@property (nonatomic, strong) NSMutableArray <TBMakingListMode *>*recordArray;
@property (nonatomic, assign) BOOL isUpload;
// 数据库工具
@property (nonatomic, strong) TBMakingSaveTool *saveTool;
// 参数集合
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@end
@implementation TBTaskMakeViewMode
- (NSMutableDictionary *)dictionary
{
    if (!_dictionary) {
        _dictionary = [NSMutableDictionary dictionary];
    }
    return _dictionary;
}
- (TBMoreReminderView *)more
{
    if (!_more)
    {
        _more = [[TBMoreReminderView alloc] initShowPrompt:@"亲，已存在该任务，是否覆盖历史数据?"];
    }
    return _more;
}
- (NSMutableArray<TBMakingListMode *> *)recordArray
{
    if (!_recordArray)
    {
        _recordArray = [NSMutableArray array];
    }
    return _recordArray;
}
- (instancetype)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}
- (TBMakingSaveTool *)saveTool
{
    if (!_saveTool)
    {
        _saveTool = [[TBMakingSaveTool alloc] init];
    }
    return _saveTool;
}
- (TBUploadPromptHUD *)uploadHUD
{
    if (_uploadHUD == nil)
    {
        _uploadHUD = [[TBUploadPromptHUD alloc] init];
    }
    return _uploadHUD;
}

#pragma mark -- 数据请求 ---

- (void)submitDataSuccessful:(successful)successful failure:(failure)failure;
{
    self.successful_s = successful;
    self.failure_f = failure;
    [self authenticationInformation];
}

- (void)authenticationInformation
{
    
    __block  NSString *images = @"";// 基础信息照片
    __block NSString *audioDataUrl = @"";//声音
    __block NSString *bossHeadImageUrl = @"";//头像
    __block NSString *coverImageUrl = @"";//背景图片
    __block NSString *appearanceImageUrls = @"";//外观图片
    __block NSString *foodImagesUrls = @"";//美食图片
    __block NSString *environmentImagesUrls = @"";//环境图片
    
    __block NSString *appearanceLabel = @"";//外观标签
    __block NSString *foodLabel = @"";//美食标签
    __block NSString *environmentLabel = @"";//环境标签
    
    __block NSString *appearanceInfo = @"";//外观简述
    __block NSString *foodInfo = @"";//美食简述
    __block NSString *environmentInfo = @"";//环境简述
    
    __block  NSMutableArray *povertyImages = [NSMutableArray arrayWithCapacity:self.makingMode.povertyPhotoArray.count];// 精准扶贫照
    __block NSMutableArray *roomDatas = [NSMutableArray arrayWithCapacity:self.makingMode.roomDatas.count];
    
    __block  NSString *positiveImages = @"";// 商家账户信息照片(正)
    __block  NSString *reverseImages = @"";// 商家账户信息照片(反)
    __block  NSString *signingImages = @"";// 签约合同信息照片
    
    [self.dictionary removeAllObjects];
    
    if (self.hiddeHUD == NO)
    {
        self.isUpload = YES;
        self.uploadHUD.prompStr = @"资源上传中...";
        [self.uploadHUD showViewCancelUpload:^{
            self.isUpload = NO;
        }];
    }
    
    dispatch_group_t group = dispatch_group_create();
    TBWeakSelf
    
    if (self.makingMode.appearanceLabel.length>0)
    {
        appearanceLabel = self.makingMode.appearanceLabel;
    }
    
    if (self.makingMode.foofLabel.length >0)
    {
        foodLabel = self.makingMode.foofLabel;
    }
    if (self.makingMode.environmentLabel.length>0)
    {
        environmentLabel = self.makingMode.environmentLabel;
    }
    /* 分割 */
    if (self.makingMode.appearanceText.length>0)
    {
        appearanceInfo = self.makingMode.appearanceText;
    }
    
    if (self.makingMode.foofText.length >0)
    {
        foodInfo = self.makingMode.foofText;
    }
    if (self.makingMode.environmentText.length>0)
    {
        environmentInfo = self.makingMode.environmentText;
    }
    
    if (self.makingMode.images.count > 0) {
        
        // 上传基础图片
        dispatch_group_enter(group);
        [self uploadingResourcesArray:self.makingMode.images resourcesType:0 resultArray:^(NSArray *array) {
            images = nil;
            if (array)
            {
                images = [array componentsJoinedByString:@","];
                weakSelf.makingMode.images = array.mutableCopy;
                if (self.hiddeHUD == NO)
                {
                    [weakSelf hudProgress:0.1];
                }
                
                if (coverImageUrl.length == 0 ) {
                    coverImageUrl = array.firstObject;
                }
            }
            dispatch_group_leave(group);
            
        }];
    }
    // 上传背景图片
    if (self.makingMode.coverPhotoUrl.length > 0)
    {
        coverImageUrl = self.makingMode.coverPhotoUrl;
    }
    else if (self.makingMode.coverPhotoData)
    {
        dispatch_group_enter(group);
        [self uploadingResourcesArray:@[self.makingMode.coverPhotoData] resourcesType:0 resultArray:^(NSArray *array) {
            coverImageUrl = nil;
            if (array)
            {
                weakSelf.makingMode.coverPhotoData = nil;
                coverImageUrl = weakSelf.makingMode.coverPhotoUrl = array.lastObject;
                if (self.hiddeHUD == NO)
                {
                    [weakSelf hudProgress:0.05];
                }
                
            }
            dispatch_group_leave(group);
            
        }];
    }
    
    // 上传环境
    if (self.makingMode.environmentPhotos.count > 0) {
        dispatch_group_enter(group);
        [self uploadingResourcesArray:self.makingMode.environmentPhotos resourcesType:0 resultArray:^(NSArray *array) {
            environmentImagesUrls = nil;
            if (array)
            {
                environmentImagesUrls = [array componentsJoinedByString:@","];
                weakSelf.makingMode.environmentPhotos = array.mutableCopy;
                
                if (self.hiddeHUD == NO)
                {
                    [weakSelf hudProgress:0.1];
                }
            }
            dispatch_group_leave(group);
            
        }];
    }
    
    
    // 上传美食
    if (self.makingMode.foodPhotos.count>0)
    {
        dispatch_group_enter(group);
        [self uploadingResourcesArray:self.makingMode.foodPhotos resourcesType:0 resultArray:^(NSArray *array) {
            foodImagesUrls = nil;
            if (array)
            {
                foodImagesUrls = [array componentsJoinedByString:@","];
                weakSelf.makingMode.foodPhotos = array.mutableCopy;
                if (self.hiddeHUD == NO)
                {
                    [weakSelf hudProgress:0.1];
                }
            }
            dispatch_group_leave(group);
            
        }];
    }
    
    // 上传外观
    if (self.makingMode.appearancePhotos.count > 0) {
        dispatch_group_enter(group);
        [self uploadingResourcesArray:self.makingMode.appearancePhotos resourcesType:0 resultArray:^(NSArray *array) {
            appearanceImageUrls = nil;
            if (array)
            {
                appearanceImageUrls = [array componentsJoinedByString:@","];
                weakSelf.makingMode.appearancePhotos = array.mutableCopy;
                if (self.hiddeHUD == NO)
                {
                    [weakSelf hudProgress:0.1];
                }
            }
            dispatch_group_leave(group);
            
        }];
    }
    
    
    // 上传老板图片
    if (self.makingMode.bossHeaderImageUrl.length>0)
    {
        bossHeadImageUrl = self.makingMode.bossHeaderImageUrl;
    }
    else if (self.makingMode.bossHeaderData)
    {
        dispatch_group_enter(group);
        [self uploadingResourcesArray:@[self.makingMode.bossHeaderData] resourcesType:0 resultArray:^(NSArray *array) {
            bossHeadImageUrl = nil;
            if (array)
            {
                weakSelf.makingMode.bossHeaderData = nil;
                bossHeadImageUrl = weakSelf.makingMode.bossHeaderImageUrl = array.lastObject;
                if (self.hiddeHUD == NO)
                {
                    [weakSelf hudProgress:0.05];
                }
            }
            dispatch_group_leave(group);
            
        }];
    }
    
    // 上传老板声音
    if (self.makingMode.bossVoiceUrl.length>0)
    {
        audioDataUrl = self.makingMode.bossVoiceUrl;
    }
    else if (self.makingMode.bossVoiceData)
    {
        dispatch_group_enter(group);
        [self uploadingResourcesArray:@[self.makingMode.bossVoiceData] resourcesType:2 resultArray:^(NSArray *array) {
            audioDataUrl = nil;
            if (array)
            {
                weakSelf.makingMode.bossVoiceData = nil;
                audioDataUrl = weakSelf.makingMode.bossVoiceUrl = array.lastObject;
                if (self.hiddeHUD == NO)
                {
                    [weakSelf hudProgress:0.05];
                }
            }
            dispatch_group_leave(group);
            
        }];
    }
    
    // 上传精准扶贫照片
    [self.makingMode.povertyPhotoArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        dispatch_group_enter(group);
        [self uploadingPovertyData:obj result:^(NSDictionary *dic) {
            
            if (dic)
            {
                [povertyImages addObject:dic];
            }
            if (self.hiddeHUD == NO)
            {
                [weakSelf hudProgress:0.1/weakSelf.makingMode.povertyPhotoArray.count];
            }
            dispatch_group_leave(group);
        }];
    }];
    // 上传民宿客栈信息
    [self.makingMode.roomDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        dispatch_group_enter(group);
        [self uploadingRoomData:obj result:^(NSDictionary *dic) {
            
            if (dic)
            {
                [roomDatas addObject:dic];
            }
            if (self.hiddeHUD == NO)
            {
                [weakSelf hudProgress:0.1/weakSelf.makingMode.povertyPhotoArray.count];
            }
            dispatch_group_leave(group);
        }];
    }];
    // 上传商家正面照
    if (self.makingMode.positivePhotoUrl.length >0)
    {
        positiveImages = self.makingMode.positivePhotoUrl;
    }
    if ([self.makingMode.positivePhotoData isKindOfClass:[NSData class]])
    {
        dispatch_group_enter(group);
        [self uploadingResourcesArray:@[self.makingMode.positivePhotoData] resourcesType:0 resultArray:^(NSArray *array) {
            positiveImages = nil;
            if (array)
            {
                positiveImages = array.firstObject;
                weakSelf.makingMode.positivePhotoUrl = array.firstObject;
                weakSelf.makingMode.positivePhotoData = nil;
                if (self.hiddeHUD == NO)
                {
                    [weakSelf hudProgress:0.05];
                }
            }
            dispatch_group_leave(group);
            
        }];
        
    }
    // 上传商家反面照
    if (self.makingMode.reversePhotoUrl.length >0)
    {
        reverseImages = self.makingMode.reversePhotoUrl;
    }
    if ([self.makingMode.reversePhotoData isKindOfClass:[NSData class]])
    {
        dispatch_group_enter(group);
        [self uploadingResourcesArray:@[self.makingMode.reversePhotoData] resourcesType:0 resultArray:^(NSArray *array) {
            reverseImages = nil;
            if (array)
            {
                reverseImages = array.firstObject;
                weakSelf.makingMode.reversePhotoUrl = array.firstObject;
                weakSelf.makingMode.reversePhotoData = nil;
                if (self.hiddeHUD == NO)
                {
                    [weakSelf hudProgress:0.05];
                }
            }
            dispatch_group_leave(group);
            
        }];
        
    }
    // 上传合同照片
    if (self.makingMode.signingArray.count >0)
    {
        dispatch_group_enter(group);
        [self uploadingResourcesArray:self.makingMode.signingArray resourcesType:0 resultArray:^(NSArray *array) {
            signingImages = nil;
            if (array)
            {
                signingImages = [array componentsJoinedByString:@","];
                weakSelf.makingMode.signingArray = array.mutableCopy;
                if (self.hiddeHUD == NO)
                {
                    [weakSelf hudProgress:0.1];
                }
            }
            dispatch_group_leave(group);
            
        }];
        
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (audioDataUrl == nil || bossHeadImageUrl == nil || appearanceImageUrls == nil || foodImagesUrls == nil || environmentImagesUrls == nil ||coverImageUrl == nil||positiveImages == nil||reverseImages == nil||signingImages == nil||povertyImages.count !=weakSelf.makingMode.povertyPhotoArray.count || self.makingMode.roomDatas.count != roomDatas.count)
        {
            if (self.hiddeHUD == NO)
            {
                [weakSelf hudDism];
                hudShowError(@"有图片未上传成功,可先保存到待发任务!");
            }
            [weakSelf postSuccess:NO];
            return;
        }
        
        NSMutableDictionary *m1 = weakSelf.makingMode.infoDic.mutableCopy;
        if (images.length > 0) {
            
            [m1 setObject:images forKey:@"imgs"];
        }
        if (coverImageUrl.length == 0 && images.length == 0)
        {
            weakSelf.makingMode.coverPhotoUrl = coverImageUrl = weakSelf.makingMode.appearancePhotos.firstObject;
        }
        
        NSMutableDictionary *povertyDic = weakSelf.makingMode.povertyInfoDic.mutableCopy;
        if (povertyImages.count > 0) {
            [povertyDic setObject:povertyImages forKey:@"listPoverty"];
        }
        if (weakSelf.makingMode.poorPeopleArray.count > 0)
        {
            [povertyDic setObject:weakSelf.makingMode.poorPeopleArray forKey:@"listPoorPeople"];
        }
        
        // m1 m2-老板 m3-外观 m5-美食 m6-环境 m9-封面
        NSString *labelKey = @"label";
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"",@"boss",
                             @"",@"special1",
                             @"",@"special2",
                             @"",@"special3",
                             nil];
        NSString *music = weakSelf.makingMode.coverMusic.length == 0?@"":weakSelf.makingMode.coverMusic;
        
        NSString *indexType = weakSelf.makingMode.appearanceTemplateIndex.length == 0?@"":weakSelf.makingMode.appearanceTemplateIndex;
        
        [weakSelf.dictionary addEntriesFromDictionary:@{@"m1":m1.copy}];
        [weakSelf.dictionary addEntriesFromDictionary:@{@"m2":@{@"img":bossHeadImageUrl,@"mic":audioDataUrl}}];
        [weakSelf.dictionary addEntriesFromDictionary:@{@"m3":@{@"img":appearanceImageUrls,@"desc":appearanceInfo,labelKey:appearanceLabel,@"type":indexType}}];
        [weakSelf.dictionary addEntriesFromDictionary:@{@"m4":@{@"img":@"",@"desc":@"",labelKey:@""}}];
        [weakSelf.dictionary addEntriesFromDictionary:@{@"m5":@{@"img":foodImagesUrls,@"desc":foodInfo,labelKey:foodLabel}}];
        [weakSelf.dictionary addEntriesFromDictionary:@{@"m6":@{@"img":environmentImagesUrls,@"desc":environmentInfo,labelKey:environmentLabel}}];
        [weakSelf.dictionary addEntriesFromDictionary:@{@"m7":@{@"img":@"",@"desc":@""}}];
        [weakSelf.dictionary addEntriesFromDictionary:@{@"m8":dic}];
        [weakSelf.dictionary addEntriesFromDictionary:@{@"m9":@{@"logo":coverImageUrl,@"music":music}}];
        if (weakSelf.makingMode.preferentialDic.count > 0) {
            [weakSelf.dictionary addEntriesFromDictionary:@{@"m10":weakSelf.makingMode.preferentialDic}];
        }
        if (povertyDic.count > 0) {
            [weakSelf.dictionary addEntriesFromDictionary:@{@"m11":povertyDic}];
        }
        
        [weakSelf.dictionary addEntriesFromDictionary:@{@"m12":@{@"img1":positiveImages,@"img2":reverseImages}}];
        [weakSelf.dictionary addEntriesFromDictionary:@{@"m13":@{@"imgs":signingImages}}];
        if (weakSelf.makingMode.discountCardDic.count > 0) {
            [weakSelf.dictionary addEntriesFromDictionary:@{@"m14":weakSelf.makingMode.discountCardDic}];
        }
        if (roomDatas.count > 0) {
            [weakSelf.dictionary addEntriesFromDictionary:@{@"m15":roomDatas}];
        }
        
        if (weakSelf.makingMode.bankMeg.length == 0 && weakSelf.makingMode.bankDic.count > 0) {
            
            [weakSelf.dictionary addEntriesFromDictionary:@{@"m16":weakSelf.makingMode.bankDic}];
        }
        [weakSelf uploadingAllData:self.dictionary.copy];
        
    });
    
}
- (void)uploadingAllData:(NSDictionary *)tionary
{
    if (self.hiddeHUD == NO)
    {
        if (self.isUpload == NO) {return;}
        
        [self hudProgress:1000];
    }
    NSMutableDictionary *dic = [NSMutableDictionary params];
    dic[@"interfaceId"] = @"181";
    NSString *new = @"";
    if (self.makingMode.merchantsID>0)
    {
        new = @"no";
        dic[@"id"] = [NSNumber numberWithInteger:self.makingMode.merchantsID];
    }
    else
    {
        new = @"yes";
    }
    dic[@"oldversion"] = @"oldversion";
    dic[@"uid"] = [UserInfo account].userID;
    NSString *dataJson = [tionary mj_JSONString];
    dic[@"modelinfo"] = dataJson;
    
    dic[@"mid"] = [NSNumber numberWithInteger:self.makingMode.modelsID];
    
    dic[@"isnew"] = new;
    MMLog(@"%@",dataJson);
    
    TBWeakSelf
    [ZKPostHttp post:@"" params:dic success:^(id responseObj)
     {
         if (![responseObj isKindOfClass:[NSDictionary class]])
         {
             if (weakSelf.hiddeHUD == NO)
             {
                 [weakSelf hudDism];
                 hudShowError(@"网络环境较差，请稍后再试!");
             }
             [weakSelf postSuccess:NO];
             
             return ;
         }
         NSString *errcode = [responseObj valueForKey:@"errcode"];
         
         if ([errcode isEqualToString:@"00000"])
         {
             weakSelf.makingMode.merchantsID = [[responseObj valueForKey:@"data"] integerValue];
             [weakSelf postSuccess:YES];
             if (weakSelf.hiddeHUD == NO)
             {
                 [weakSelf hudShowMsg:[responseObj valueForKey:@"errmsg"]];
             }
         }
         else
         {
             if (weakSelf.hiddeHUD == NO)
             {
                 [weakSelf hudDism];
                 NSString *errorString = responseObj[@"errmsg"];
                 hudShowError(errorString);
             }
             [weakSelf postSuccess:NO];
         }
         
     } failure:^(NSError *error) {
         
         if (weakSelf.hiddeHUD == NO)
         {
             [weakSelf hudDism];
             hudShowFailure();
             
         }
         [weakSelf postSuccess:NO];
         
     }];
    
}

- (void)postSuccess:(BOOL)success
{
    NSLog(@" ======= ");
    
    if (success == YES)
    {
        if (self.successful_s)
        {
            self.successful_s(self.makingMode);
        }
    }
    else
    {
        if (self.failure_f)
        {
            self.failure_f();
        }
        
    }
    
}

/**
 上传客栈民宿
 
 @param data 数据
 @param dic 修改后的数据
 */
- (void)uploadingRoomData:(NSDictionary *)data result:(void(^)(NSDictionary *dic))dic;
{
    NSArray *imgs = [data valueForKey:@"img"];
    __block NSString *images = @"";
    
    dispatch_group_t group = dispatch_group_create();
    // 上传正面图片
    dispatch_group_enter(group);
    [self uploadingResourcesArray:imgs resourcesType:0 resultArray:^(NSArray *array) {
        images = nil;
        if (array)
        {
            images = [array componentsJoinedByString:@","];
        }
        dispatch_group_leave(group);
    }];
    
    // 处理完成回调
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (images == nil && dic)
        {
            dic(nil);
        }
        else
        {
            NSDictionary *dictionary = @{@"img":images.copy,
                                         @"type":[data valueForKey:@"type"],
                                         @"price":[data valueForKey:@"price"],
                                         @"number":[data valueForKey:@"number"]};
            dic(dictionary);
        }
    });
}
/**
 上传贫困员工信息
 
 @param data 字典信息
 @param dic 成功后的数据
 */
- (void)uploadingPovertyData:(NSDictionary *)data result:(void(^)(NSDictionary *dic))dic;
{
    id positive = [data valueForKey:@"img1"];
    id reverse = [data valueForKey:@"img2"];
    NSString *name = [data valueForKey:@"name"];
    
    __block NSString *positiveUrl = @"";
    __block NSString *reverseUrl = @"";
    
    dispatch_group_t group = dispatch_group_create();
    // 上传正面图片
    dispatch_group_enter(group);
    [self uploadingResourcesArray:@[positive] resourcesType:0 resultArray:^(NSArray *array) {
        positiveUrl = nil;
        
        if (array)
        {
            positiveUrl = array.firstObject;
        }
        dispatch_group_leave(group);
    }];
    // 上传反面图片
    dispatch_group_enter(group);
    [self uploadingResourcesArray:@[reverse] resourcesType:0 resultArray:^(NSArray *array)
     {
         reverseUrl = nil;
         if (array)
         {
             reverseUrl = array.firstObject;
         }
         dispatch_group_leave(group);
         
     }];
    // 处理完成回调
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (positiveUrl == nil || reverseUrl == nil)
        {
            dic(nil);
        }
        else
        {
            dic(@{@"img1":positiveUrl,@"img2":reverseUrl,@"name":name});
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
- (void)hudProgress:(CGFloat)progress
{
    TBWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakSelf.uploadHUD progress:progress];
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
        
        if ([data isKindOfClass:[NSString class]])
        {
            NSString *images = data;
            
            if (images.length>200)
            {
                NSData *newData  = [[NSData alloc] initWithBase64EncodedString:images options:NSDataBase64DecodingIgnoreUnknownCharacters];
                UIImage *imageData = [UIImage imageWithData:newData];
                data = UIImageJPEGRepresentation([imageData compressionCap:1000],0.9);
            }
        }
        if (![data isKindOfClass:[NSString class]])
            
        {
            if (type == 0)
            {
                if ([data isKindOfClass:[UIImage class]])
                {
                    data = UIImageJPEGRepresentation([data compressionCap:1000], 0.9);
                }
            }
            
            [ZKPostHttp scPpostImage:POST_URL params:dic dataArray:data type:type success:^(id responseObj, NSInteger dataType)
             {
                 MMLog(@"类型-%ld 第 %d 张图片上传成功: %@", (long)type,(int)i + 1, responseObj);
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

- (void)postMakingDataID:(NSInteger)_id;
{
    if ([self.delegate respondsToSelector:@selector(postDataStart)])
    {
        [self.delegate postDataStart];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary params];
    dic[@"interfaceId"] = @"203";
    dic[@"id"] = [NSNumber numberWithInteger:_id];
    TBWeakSelf
    [ZKPostHttp post:@"" params:dic success:^(id responseObj) {
        
        NSString *errcode = [responseObj valueForKey:@"errcode"];
        if ([errcode isEqualToString:@"00000"])
        {
            NSDictionary *dic = [responseObj valueForKey:@"data"];
            if ([weakSelf.delegate respondsToSelector:@selector(makingTemplateData:)])
            {
                [weakSelf.delegate makingTemplateData:[weakSelf modeMakeResults:dic shID:_id]];
            }
        }
        else
        {
            if ([weakSelf.delegate respondsToSelector:@selector(dataPostError:)])
            {
                [weakSelf.delegate dataPostError:[responseObj valueForKey:@"errmsg"]];
            }
        }
        
    } failure:^(NSError *error) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(dataPostError:)])
        {
            [weakSelf.delegate dataPostError:@"网络出错了,请稍后再试!"];
        }
        
    }];
    
    
}
- (void)postEditDataID:(NSInteger)_id;
{
    if ([self.delegate respondsToSelector:@selector(postDataStart)])
    {
        [self.delegate postDataStart];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary params];
    dic[@"interfaceId"] = @"183";
    dic[@"id"] = [NSNumber numberWithInteger:_id];
    dic[@"uid"] = [UserInfo account].userID;
    TBWeakSelf
    [ZKPostHttp post:@"" params:dic success:^(id responseObj) {
        
        NSString *errcode = [responseObj valueForKey:@"errcode"];
        
        if ([errcode isEqualToString:@"00000"])
        {
            if ([weakSelf.delegate respondsToSelector:@selector(editTemplateData:)])
            {
                [weakSelf.delegate editTemplateData:[weakSelf modelOfTheAssignment:responseObj shID:_id]];
            }
        }
        else
        {
            if ([weakSelf.delegate respondsToSelector:@selector(dataPostError:)])
            {
                [weakSelf.delegate dataPostError:[responseObj valueForKey:@"errmsg"]];
            }
        }
        
    } failure:^(NSError *error) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(dataPostError:)])
        {
            [weakSelf.delegate dataPostError:@"网络出错了,请稍后再试!"];
        }
    }];
    
}
- (TBMakingListMode *)modeMakeResults:(NSDictionary *)dic shID:(NSInteger)_id
{
    TBMakingListMode *mode = [[TBMakingListMode alloc] init];
    mode.merchantsID = _id;
    mode.infoDic = dic;
    mode.saveID = [NSString stringWithFormat:@"%ld",(long)_id];
    return mode;
}
- (TBMakingListMode *)modelOfTheAssignment:(NSDictionary *)dic shID:(NSInteger)_id;
{
    TBMakingListMode *mode = [[TBMakingListMode alloc] init];
    mode.merchantsID = _id;
    NSDictionary *data = [dic valueForKey:@"data"];
    NSString *modelinfo = [data valueForKey:@"modelinfo"];
    NSDictionary *dic_c = [modelinfo mj_JSONObject];
    NSDictionary *m1 = [dic_c valueForKey:@"m1"];
    NSDictionary *m11 = [dic_c valueForKey:@"m11"];
    NSDictionary *m12 = [dic_c valueForKey:@"m12"];
    NSDictionary *m13 = [dic_c valueForKey:@"m13"];
    
    mode.roomDatas = [[dic_c valueForKey:@"m15"] mutableCopy];
    
    mode.modelsID = [[data valueForKey:@"mid"] integerValue];
    mode.saveID   = [NSString stringWithFormat:@"%ld",(long)_id];
    mode.isbind   = [data valueForKey:@"isbind"];
    mode.povertyInfoDic = m11;
    NSArray *povertyPhotos = [m11 valueForKey:@"listPoverty"];
    mode.povertyPhotoArray = povertyPhotos.mutableCopy;
    mode.positivePhotoUrl = [m12 valueForKey:@"img1"];
    mode.reversePhotoUrl = [m12 valueForKey:@"img2"];
    mode.poorPeopleArray = [[m11 valueForKey:@"listPoorPeople"] mutableCopy];
    
    NSString *signingImages = [m13 valueForKey:@"imgs"];
    if (signingImages.length >0)
    {
        mode.signingArray = [signingImages componentsSeparatedByString:@","].mutableCopy;
    }
    if ([[m1 valueForKey:@"type"] integerValue] == 23)//服务场所
    {
        mode.images = [[m1 valueForKey:@"imgs"] componentsSeparatedByString:@","].mutableCopy;
        mode.infoDic = m1;
    }
    else
    {
        mode.infoDic = m1;
        mode.preferentialDic = [dic_c valueForKey:@"m10"];
        mode.discountCardDic = [dic_c valueForKey:@"m14"];
        NSDictionary *m2 = [dic_c valueForKey:@"m2"];
        mode.bossVoiceUrl = [m2 valueForKey:@"mic"];
        mode.bossHeaderImageUrl = [m2 valueForKey:@"img"];
        
        NSDictionary *m3 = [dic_c valueForKey:@"m3"];
        NSString *img_3 = [m3 valueForKey:@"img"];
        if (img_3.length >0)
        {
            mode.appearancePhotos = [img_3 componentsSeparatedByString:@","].mutableCopy;
            
        }
        mode.appearanceLabel = [m3 valueForKey:@"label"];
        mode.appearanceText = [m3 valueForKey:@"desc"];
        mode.appearanceTemplateIndex = [m3 valueForKey:@"type"];
        
        NSDictionary *m5 = [dic_c valueForKey:@"m5"];
        NSString *img_5 = [m5 valueForKey:@"img"];
        if (img_5.length >0)
        {
            mode.foodPhotos = [img_5 componentsSeparatedByString:@","].mutableCopy;
            
        }
        mode.foofLabel = [m5 valueForKey:@"label"];
        mode.foofText = [m5 valueForKey:@"desc"];
        
        NSDictionary *m6 = [dic_c valueForKey:@"m6"];
        NSString *img_6 = [m6 valueForKey:@"img"];
        if (img_6.length >0)
        {
            mode.environmentPhotos = [img_6 componentsSeparatedByString:@","].mutableCopy;
            
        }
        mode.environmentText = [m6 valueForKey:@"desc"];
        mode.environmentLabel = [m6 valueForKey:@"label"];
        NSDictionary *m9 = [dic_c valueForKey:@"m9"];
        mode.coverPhotoUrl = [m9 valueForKey:@"logo"];
        mode.coverMusic = [m9 valueForKey:@"music"];
        
    }
    return mode;
}
#pragma mark ----逻辑处理---

//保存
- (void)saveState:(isSaveState)state;
{
    self.saveState = state;
    
    TBWeakSelf
    [self.saveTool  queryConditionsRange:NSMakeRange(0, 10000) results:^(NSArray<TBMakingListMode *> *listArray) {
        
        [weakSelf saveMode:listArray];
    }];
}
- (void)deleteMode:(TBMakingListMode *)mode state:(void(^)(BOOL successful))successfu;
{
    [self.saveTool deleteMakingListArray:@[mode] deleteState:^(BOOL state) {
        if (successfu) {
            successfu(YES);
        }
    }];
    
}
- (void)saveMode:(NSArray <TBMakingListMode*> *)modes
{
    if (modes.count == 0)
    {
        [self saveList];
    }
    else
    {
        TBWeakSelf
        [self.recordArray removeAllObjects];
        [modes enumerateObjectsUsingBlock:^(TBMakingListMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.saveID isEqualToString:weakSelf.makingMode.saveID ])
            {
                [weakSelf.recordArray addObject:obj];
            }
        }];
        
        if (self.recordArray.count >0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                hudDismiss();
                
                [weakSelf.more cancelClick:^{
                    if (weakSelf.saveState)
                    {
                        weakSelf.saveState(NO);
                    }
                }];
                [weakSelf.more showHandler:^{
                    
                    hudShowLoading(@"正在删除");
                    [weakSelf.recordArray addObject:weakSelf.makingMode];
                    [weakSelf.saveTool deleteMakingListArray:weakSelf.recordArray deleteState:^(BOOL state) {
                        
                        [weakSelf.recordArray removeAllObjects];
                        if (state == YES)
                        {
                            hudShowLoading(@"正在保存");
                            [weakSelf saveList];
                        }
                        else
                        {
                            hudShowError(@"删除失败");
                        }
                        
                    }];
                    
                }];
                
            });
            
        }
        else
        {
            [weakSelf saveList];
        }
        
        
    }
    
}
- (void)saveList
{
    TBWeakSelf
    [self.saveTool saveMakingList:self.makingMode saveState:^(BOOL state) {
        
        if (weakSelf.saveState)
        {
            weakSelf.saveState(state);
        }
        
    }];
}
- (void)showPrompt:(NSString *)stateInfo
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:stateInfo preferredStyle:UIAlertControllerStyleAlert];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self postSuccess:NO];
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"任性上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self authenticationInformation];
    }]];
    
    [[ZKUtil getPresentedViewController] presentViewController:alertView animated:YES completion:nil];
}

@end
