//
//  TBPublishingGroupViewController.h
//  Telecom
//
//  Created by 王小腊 on 2017/4/13.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBBaseViewController.h"

/**
 发布团购秒杀
 */
@interface TBPublishingGroupViewController : TBBaseViewController
//商家id
@property (nonatomic, strong) NSString *shopId;
//产品id
@property (nonatomic, strong) NSString *groupId;

@property (nonatomic, strong) NSString *shopname;
@end
