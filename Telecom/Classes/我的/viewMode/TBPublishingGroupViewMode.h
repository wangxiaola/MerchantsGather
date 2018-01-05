//
//  TBPublishingGroupViewMode.h
//  Telecom
//
//  Created by 王小腊 on 2017/4/18.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBPublishingGroupList.h"

@interface TBPublishingGroupViewMode : NSObject

- (void)postPublishingGroupData:(NSString *)ID groupData:(void(^)(TBPublishingGroupList *list))data;

- (void)requestData:(TBPublishingGroupList *)mode successful:(void(^)(void))successful;

@end
