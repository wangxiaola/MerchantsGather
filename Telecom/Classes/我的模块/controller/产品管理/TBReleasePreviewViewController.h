//
//  TBReleasePreviewViewController.h
//  Telecom
//
//  Created by 王小腊 on 2017/4/19.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBaseViewController.h"
@class TBPublishingGroupList;

/**
 发布预览
 */
@interface TBReleasePreviewViewController : TBBaseViewController

/**
 产品id 非发布预览传值
 */
@property (nonatomic, strong) NSString *groupId;
/**
 预览数据源
 */
@property (nonatomic, strong) TBPublishingGroupList *groupList;
@end
