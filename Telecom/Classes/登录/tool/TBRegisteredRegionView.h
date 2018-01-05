//
//  TBRegisteredRegionView.h
//  Telecom
//
//  Created by 王小腊 on 2017/4/25.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TBRegisteredRegionMode;

@interface TBRegisteredRegionView : UIView

- (void)showAdderssPois:(NSArray <TBRegisteredRegionMode*>*)array;

@property (nonatomic, copy) void(^adderssPoi)(TBRegisteredRegionMode *);

@end

@interface TBRegisteredRegionMode : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *ID;

@end
