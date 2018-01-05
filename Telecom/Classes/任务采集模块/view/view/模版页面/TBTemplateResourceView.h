//
//  TBTemplateResourceView.h
//  Telecom
//
//  Created by 王小腊 on 2016/12/13.
//  Copyright © 2016年 王小腊. All rights reserved.
//

/**
 资源上传类型

 - ResourceImageTypeAppearance: 外观
 - ResourceImageTypeFood: 美食
 - ResourceImageTypeEnvironment: 环境
 */
typedef NS_ENUM(NSInteger, ResourceImageType) {

    ResourceImageTypeAppearance = 0,
    ResourceImageTypeFood,
    ResourceImageTypeEnvironment
};
#import "TBTemplateBaseView.h"

/**
 资源图片上传
 */
@interface TBTemplateResourceView : TBTemplateBaseView

/**
 创建布局类型

 @param type 类型··
 */
- (void)createLayoutViewType:(ResourceImageType)type;

@end
