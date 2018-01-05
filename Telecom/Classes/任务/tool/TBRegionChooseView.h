//
//  TBRegionChooseView.h
//  Telecom
//
//  Created by 王小腊 on 2017/7/17.
//  Copyright © 2017年 王小腊. All rights reserved.
//

typedef struct ChooseViewComponent
{
    NSInteger provincesIndex, cityIndex, areaIndex;
    
} ChooseViewComponent;

UIKIT_STATIC_INLINE ChooseViewComponent ChooseViewComponentMake(NSInteger provincesIndex, NSInteger cityIndex, NSInteger areaIndex) {
    ChooseViewComponent insets = {provincesIndex, cityIndex, areaIndex};
    return insets;
}

#import <UIKit/UIKit.h>
@class TBRegionESRootClass;

@protocol TBRegionChooseViewDelegate <NSObject>

- (void)selectedRegionName:(NSString *)name RegionCode:(NSString *)code;

- (void)selectedProvincesComponent:(ChooseViewComponent)chooseViewComponent;

@end
/**
 地区选择
 */
@interface TBRegionChooseView : UIView

@property (weak, nonatomic)id<TBRegionChooseViewDelegate>delegate;

- (instancetype)initRegionData:(TBRegionESRootClass *)data;

- (void)showSelectedRegionComponent:(ChooseViewComponent)chooseViewComponent;

@end
