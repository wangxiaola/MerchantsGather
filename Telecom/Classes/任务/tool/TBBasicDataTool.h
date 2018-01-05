//
//  TBBasicDataTool.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/16.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBRegionESRootClass.h"
/**
 基础数据提供
 */
@class TBBasicDataShoptypes,TBBasicDataSuitables,TBBasicDataLabels,
TBBasicDataArea,TBBasicDataLevels,TBPackageData,
TBDescribleList,TBDescriDicData,TBBasicDataRange,TBBankMerchantsTypeData;

@interface TBBasicDataTool :NSObject

- (instancetype)init;

/**
 标签及适合及商家类型字典

 @param complete 加载完成
 */
+ (void)initializeTypeData:(void(^)(TBBasicDataTool *tool))complete;


/**
 根据商家类型获取数据

 @param type 类型type
 @param toolData self
 */
- (void)requestDataTypes:(NSString *)type dataTool:(void(^)(TBBasicDataTool*tool))toolData;
// 商家类型获取
+ (NSArray *)businessType;

/**
 获取区域代码

 @param complete 加载完成
 */
+ (void)initRegionData:(void(^)(TBBasicDataTool *tool))complete;

/**
 模板数据

 @param packages 模板
 */
+ (void)initPackageData:(void(^)(NSArray <TBPackageData *>*))packages;

/**
 银行商家类型

 @param typeData 模型数组
 */
+ (void)initBankMerchantsTypeData:(void(^)(NSArray <TBBankMerchantsTypeData*>*))typeData;

@property (nonatomic, strong) NSArray<TBBasicDataShoptypes *> *shoptypes;//类型
//标签列表
@property (nonatomic, strong) NSArray<TBBasicDataLabels *> *labels;
//适合标签列表
@property (nonatomic, strong) NSArray<TBBasicDataSuitables *> *suitables;
//等级
@property (nonatomic, strong) NSArray<TBBasicDataLevels *> *grades;
//经营范围
@property (nonatomic, strong) NSArray <TBBasicDataRange *> *ranges;
//所属区域
@property (nonatomic, strong) TBRegionESRootClass *areas;

//图片标签 0外观 1美食 2环境
@property (nonatomic, strong) NSArray<TBDescribleList *> *describle;

@end


@interface TBBasicDataShoptypes : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *type;

@end

@interface TBBasicDataSuitables : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *name;

@end

@interface TBBasicDataLabels : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *name;

@end
@interface TBBasicDataLevels : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *name;

@end

@interface TBBasicDataArea : NSObject

@property (nonatomic, strong) NSString *code;

@property (nonatomic, copy) NSString *name;

@end

@interface TBBasicDataRange : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *name;

@end

@interface TBDescribleList : NSObject

@property (nonatomic, strong) NSArray <TBDescriDicData*>*data;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *name;

@end

@interface TBDescriDicData : NSObject

@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *name;

@end

@interface TBPackageData : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *url;
@end

@interface TBBankMerchantsTypeData : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *shop_class_id;
@property (nonatomic, copy) NSString *shop_class_name;
@end
