//
//  ZKPickDateView.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/16.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//


/**
 选择器类型

 - PickDataViewTypeMerchants: 商家类型
 - PickDataViewTypeArea: 区域类型
 - PickDataViewTypeBank: 银行类型
 */
typedef NS_ENUM(NSInteger, PickDataViewType){
    
    PickDataViewTypeMerchants = 0,
        PickDataViewTypeArea,
        PickDataViewTypeBank
};

#import <UIKit/UIKit.h>
@class TBBasicDataShoptypes,TBBasicDataArea,TBBankMerchantsTypeData;

@protocol ZKPickDataViewDelegate <NSObject>
@optional

- (void)selectedData:(id)data;

@end
/**
 商家类型选择工具
 */
@interface ZKPickDataView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>


@property (weak, nonatomic)id<ZKPickDataViewDelegate>delegate;

- (instancetype)initData:(NSArray*)cellArray typeName:(NSString *)name type:(PickDataViewType)type;

- (void)showSelectedData:(NSInteger )data;


@end
