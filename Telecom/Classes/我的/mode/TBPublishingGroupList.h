//
//  TBPublishingGroupList.h
//  Telecom
//
//  Created by 王小腊 on 2017/4/18.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBPublishingGroupList : NSObject

@property (nonatomic ,strong) NSString *address;//
@property (nonatomic ,strong) NSString *bookdate;//预约日期
@property (nonatomic ,strong) NSString *buyknow;//自定义规则
@property (nonatomic ,strong) NSString *edate;//结束日期
@property (nonatomic ,strong) NSString *ginfo;//预约电话
@property (nonatomic ,strong) NSString *ID;//产品ID
@property (nonatomic ,strong) NSArray *imgs;//图片
@property (nonatomic ,strong) NSArray *info;//描述
@property (nonatomic ,strong) NSString *lat;//
@property (nonatomic ,strong) NSString *limitnum;//限购数量
@property (nonatomic ,strong) NSString *lng;//
@property (nonatomic ,strong) NSString *logo;//
@property (nonatomic ,strong) NSString *name;//产品名称
@property (nonatomic ,strong) NSString *nowstr;//
@property (nonatomic ,strong) NSString *num;//数量
@property (nonatomic ,strong) NSString *price;//价格
@property (nonatomic ,strong) NSString *ptype;//
@property (nonatomic ,strong) NSString *refund;//退款天数
@property (nonatomic ,strong) NSString *rule;//规则
@property (nonatomic ,strong) NSString *sdate;//开始日期
@property (nonatomic ,strong) NSString *sellprice;//售价
@property (nonatomic ,strong) NSString *shopname;//
@property (nonatomic ,strong) NSString *state;//状态
@property (nonatomic ,strong) NSString *time;//上线时间
@property (nonatomic ,strong) NSString *type;//类型
@property (nonatomic ,strong) NSString *shopid;//商家Id

@end
