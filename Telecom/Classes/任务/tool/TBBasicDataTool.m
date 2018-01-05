//
//  TBBasicDataTool.m
//  Telecom
//
//  Created by 王小腊 on 2016/12/16.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "TBBasicDataTool.h"

@interface TBBasicDataTool ()

@end

@implementation TBBasicDataTool
- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
    }
    return self;
}
#pragma mark --- 初始化 ---
/**
 初始化
 */
+ (void)initializeTypeData:(void(^)(TBBasicDataTool *tool))complete;
{
    TBBasicDataTool *tool = [[TBBasicDataTool alloc] init];
    
    NSDictionary *data = [[ZKUtil getCacheFileName:@"TBBasicDataToolType"] mj_JSONObject];
    
    if (data.count == 0 )
    {
        NSMutableDictionary *dic = [NSMutableDictionary params];
        dic[@"interfaceId"] = @"178";
        dic[@"type"] = [UserInfo account].type;
        dic[@"shopcode"] = [UserInfo account].code;
        
        [ZKPostHttp post:@"" params:dic success:^(id responseObj) {
            
            NSString *errcode = [responseObj valueForKey:@"errcode"];
            if ([errcode isEqualToString:@"00000"])
            {
                [ZKUtil cacheForData:[responseObj mj_JSONData] fileName:@"TBBasicDataToolType"];
                [tool processingTypeData:responseObj];
                
                if (complete) {
                    complete(tool);
                }
            }
            
        } failure:^(NSError *error) {
            
            
            
        }];
 
    }
    else
    {
        [tool processingTypeData:data];
        
        if (complete) {
            complete(tool);
        }
    }

}

/**
 根据商家类型获取数据
 
 @param type 类型type
 @param toolData self
 */
- (void)requestDataTypes:(NSString *)type dataTool:(void(^)(TBBasicDataTool*tool))toolData;
{
    hudShowLoading(@"数据获取中");
    NSMutableDictionary *dic = [NSMutableDictionary params];
    dic[@"interfaceId"] = @"178";
    dic[@"type"] = type;
    dic[@"shopcode"] = [UserInfo account].code;
    
    [ZKPostHttp post:@"" params:dic success:^(id responseObj) {
        hudDismiss();
        NSString *errcode = [responseObj valueForKey:@"errcode"];
        if ([errcode isEqualToString:@"00000"])
        {
          [self processingTypeData:responseObj];
            if (toolData)
            {
                toolData(self);
            }
        }
        
    } failure:^(NSError *error) {
        hudDismiss();
    }];

}
// 商家类型获取
+ (NSArray *)businessType;
{

    NSArray *data = [NSArray arrayWithObjects:
                     @{@"name":@"农家乐",@"type":@"farmstay",@"ID":@"1"},
                     @{@"name":@"休闲娱乐",@"type":@"recreation",@"ID":@"22"},
                     @{@"name":@"特色美食",@"type":@"food",@"ID":@"21"},
                     @{@"name":@"酒店客栈",@"type":@"hotel",@"ID":@"16"},
                     @{@"name":@"景区景点",@"type":@"view",@"ID":@"17"},
                     @{@"name":@"服务场所",@"type":@"service",@"ID":@"23"},
                     
                     nil];
    return data;
}

+ (void)initRegionData:(void(^)(TBBasicDataTool *tool))complete;
{
    TBBasicDataTool *tool = [[TBBasicDataTool alloc] init];
    
    NSDictionary *data = [[ZKUtil getCacheFileName:@"TBRegionESRootClassNew"] mj_JSONObject];
    if (data.count == 0)
    {
        NSMutableDictionary *dic = [NSMutableDictionary params];
        dic[@"interfaceId"] = @"282";
        dic[@"code"] = [UserInfo account].code;

        
        [ZKPostHttp post:@"" params:dic success:^(id responseObj) {
            
            NSString *errcode = [responseObj valueForKey:@"errcode"];
            if ([errcode isEqualToString:@"00000"])
            {
                [ZKUtil cacheForData:[responseObj mj_JSONData] fileName:@"TBRegionESRootClassNew"];
                
                [tool processingAreaData:responseObj];
                if (complete) {
                    complete(tool);
                }
            }
        } failure:nil];
        
    }
    else
    {
        [tool processingAreaData:data];
        if (complete) {
            complete(tool);
        }
        
    }

}
+ (void)initPackageData:(void(^)(NSArray <TBPackageData *>*))packages;
{
    NSArray *datas = [[ZKUtil getCacheFileName:@"TBPackageData"] mj_JSONObject];
    if (datas.count == 0)
    {
        NSMutableDictionary *dic = [NSMutableDictionary params];
        dic[@"interfaceId"] = @"174";
        dic[@"page"] = @"1";
        dic[@"rows"] = @"10";
        [ZKPostHttp post:@"" params:dic success:^(id responseObj) {
            
            NSString *errcode = [responseObj valueForKey:@"errcode"];
            if ([errcode isEqualToString:@"00000"])
            {
                NSDictionary *data = [responseObj valueForKey:@"data"];
                NSDictionary *models = [data valueForKey:@"models"];
                NSArray *rootArray = [models valueForKey:@"root"];
                
                NSArray *modeArray = [TBPackageData mj_objectArrayWithKeyValuesArray:rootArray];
                
                packages(modeArray);
                
                [ZKUtil cacheForData:[rootArray mj_JSONData] fileName:@"TBPackageData"];
            }
        } failure:nil];
        
    }
    else
    {
        if (packages)
        {
            NSArray *modeArray = [TBPackageData mj_objectArrayWithKeyValuesArray:datas];
            packages(modeArray);
        }
      
    }
}
/**
 银行商家类型
 
 @param typeData 模型数组
 */
+ (void)initBankMerchantsTypeData:(void(^)(NSArray <TBBankMerchantsTypeData*>*))typeData;
{
    NSArray *datas = [[ZKUtil getCacheFileName:@"TBBankMerchantsTypeData"] mj_JSONObject];
    if (datas.count == 0)
    {
        NSMutableDictionary *dic = [NSMutableDictionary params];
        dic[@"interfaceId"] = @"295";
        
        [ZKPostHttp post:@"" params:dic success:^(id responseObj) {
            
            NSString *errcode = [responseObj valueForKey:@"errcode"];
            if ([errcode isEqualToString:@"00000"])
            {
                NSDictionary *data = [responseObj valueForKey:@"data"];
                NSArray *rootArray = [data valueForKey:@"root"];
                
                NSArray *modeArray = [TBBankMerchantsTypeData mj_objectArrayWithKeyValuesArray:rootArray];
                
                typeData(modeArray);
                
                [ZKUtil cacheForData:[rootArray mj_JSONData] fileName:@"TBBankMerchantsTypeData"];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
    else
    {
        if (typeData)
        {
            NSArray *modeArray = [TBBankMerchantsTypeData mj_objectArrayWithKeyValuesArray:datas];
            typeData(modeArray);
        }
    }
}
#pragma mark  -- 数据处理 ---
/**
 处理数据  TypeData

 @param responseObj 数据
 */
- (void)processingTypeData:(NSDictionary *)responseObj
{
    NSDictionary *data = [responseObj valueForKey:@"data"];
    
    self.labels = [TBBasicDataLabels mj_objectArrayWithKeyValuesArray:[data valueForKey:@"labels"]];
    self.shoptypes = [TBBasicDataShoptypes mj_objectArrayWithKeyValuesArray:[data valueForKey:@"shoptypes"]];
    self.suitables = [TBBasicDataSuitables mj_objectArrayWithKeyValuesArray:[data valueForKey:@"suitables"]];
    self.grades = [TBBasicDataLevels mj_objectArrayWithKeyValuesArray:[data valueForKey:@"grades"]];
    self.describle = [TBDescribleList mj_objectArrayWithKeyValuesArray:[data valueForKey:@"describle"]];
    self.ranges = [TBBasicDataRange mj_objectArrayWithKeyValuesArray:[data valueForKey:@"range"]];
    
}
/**
 处理数据  AreaData
 
 @param responseObj 数据
 */
- (void)processingAreaData:(NSDictionary *)responseObj
{

    TBRegionESRootClass *rootList = [TBRegionESRootClass mj_objectWithKeyValues:responseObj];
    
    self.areas = rootList;

}

+ (NSDictionary *)objectClassInArray{
    return @{@"shoptypes" : [TBBasicDataShoptypes class], @"suitables": [TBBasicDataSuitables class], @"labels" : [TBBasicDataLabels class],@"areas":[TBBasicDataArea class],@"grades":[TBBasicDataLevels class],@"describle":[TBDescribleList class],@"range":[TBBasicDataRange class]};
}

@end


#pragma  ----------
@implementation TBBasicDataShoptypes

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end


@implementation TBBasicDataSuitables
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end


@implementation TBBasicDataLabels
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end

@implementation TBBasicDataLevels
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end
@implementation TBBasicDataArea


@end
@implementation TBBasicDataRange

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end

@implementation TBPackageData

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

@end

@implementation TBDescribleList

+ (NSDictionary *)objectClassInArray{
    return @{@"data":[TBDescriDicData class]};
}
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

@end
@implementation TBDescriDicData

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

@end

@implementation TBBankMerchantsTypeData
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

@end;

