//
//  TBBusinessIntelligenceViewMode.h
//  Telecom
//
//  Created by 王小腊 on 2017/3/25.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBBasicServicetypeMode.h"

@interface TBBusinessIntelligenceViewMode : NSObject

@property (nonatomic, copy) void(^servicetypeMode)(TBBasicServicetypeMode *mode);

- (void)postLabels;

@end
