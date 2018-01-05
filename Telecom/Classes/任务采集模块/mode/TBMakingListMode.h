//
//  TBMakingListMode.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/15.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBMakingListMode : NSObject
// 判断当前商户模版是否已经激活过云金融
@property (nonatomic, strong) NSString *isbind;
// 数据ID
@property (nonatomic, strong) NSString *saveID;
// 商户ID
@property (nonatomic, assign) NSInteger merchantsID;
// 模板ID
@property (nonatomic, assign) NSInteger modelsID;
// 数据是否完整 0不完整
@property (nonatomic, assign) NSInteger complete;
/**
 模型类型
 */
@property (nonatomic, strong) NSString *type;

/**
 基本信息 验证 - 0
 */
@property (nonatomic, strong) NSDictionary *infoDic;// 可串演服务场所基本信息
@property (nonatomic, strong) NSString *msg;

/**
 老板信息 验证 - 1
 */
@property (nonatomic, strong) NSString *bossHeaderImageUrl;
@property (nonatomic, strong) NSData *bossHeaderData;
@property (nonatomic, strong) NSString *bossVoiceUrl;
@property (nonatomic, strong) NSData *bossVoiceData;

/**
 录制视频 验证 - 2
 */
@property (nonatomic, strong) NSDictionary *videoDictionary;
// 保存封面用的
@property (nonatomic, strong) NSData *videoData;

/**
 外观信息 验证 - 3
 */
@property (nonatomic, strong) NSMutableArray *appearancePhotos;
@property (nonatomic, strong) NSString *appearanceText;
@property (nonatomic, strong) NSString *appearanceLabel;
@property (nonatomic, strong) NSString *appearanceTemplateIndex;


/**
 客房信息 验证 - 4
 */
@property (nonatomic, strong) NSMutableArray *roomDatas;
/**
 美食信息 选填 验证 - 5
 */
@property (nonatomic, strong) NSMutableArray *foodPhotos;
@property (nonatomic, strong) NSString *foofText;
@property (nonatomic, strong) NSString *foofLabel;

/**
 环境信息 验证 - 6
 */
@property (nonatomic, strong) NSMutableArray *environmentPhotos;
@property (nonatomic, strong) NSString *environmentText;
@property (nonatomic, strong) NSString *environmentLabel;

/**
 优惠信息 m10 验证 - 7
 */
@property (nonatomic, strong) NSDictionary *preferentialDic;

/**
 打折卡 m14 验证 - 8
 */
@property (nonatomic, strong) NSDictionary *discountCardDic;

/**
 封面 验证 - 9
 */
@property (nonatomic, strong) NSString *coverPhotoUrl;
@property (nonatomic, strong) NSData  *coverPhotoData;
@property (nonatomic, strong) NSString *coverMusic;

/**
 服务场所基础信息 验证 - 10
 */
@property (nonatomic, strong) NSMutableArray *images;

/**
 精准扶贫 验证 - 11
 */
@property (nonatomic, strong) NSDictionary *povertyInfoDic;
@property (nonatomic, strong) NSMutableArray *povertyPhotoArray;
@property (nonatomic, strong) NSString *povertyMsg;
// 贫困人员信息
@property (nonatomic, strong) NSMutableArray *poorPeopleArray;

/**
 商家账户信息 0 正面 验证 - 12
 */
@property (nonatomic, strong) NSString *positivePhotoUrl;
@property (nonatomic, strong) NSData  *positivePhotoData;

@property (nonatomic, strong) NSString *reversePhotoUrl;
@property (nonatomic, strong) NSData  *reversePhotoData;
// 签约合同信息
@property (nonatomic, strong) NSMutableArray *signingArray;

/**
 银行信息 验证 - 13
 */
@property (nonatomic, strong) NSDictionary *bankDic;
@property (nonatomic, strong) NSString *bankMeg;
@end
