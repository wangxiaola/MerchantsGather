//
//  TBMaskMakeGuideFile.m
//  Telecom
//
//  Created by 王小腊 on 2018/1/5.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBMaskMakeGuideFile.h"
#import "TBTemplateInfoView.h"
#import "TBTemplateBossHeadBaseView.h"
#import "TBTemplateBackgroundView.h"
#import "TBTemplateResourceView.h"
#import "TBStrategyViewController.h"
#import "TBPreferentialInformationView.h"
#import "TBDiscountCardView.h"
#import "TBPovertyAlleviationView.h"
#import "TBSigningContractInformationView.h"
#import "TBGZEmployeesAddView.h"
#import "TBMerchantsVideoView.h"
#import "TBBankInformationView.h"

#import "TBFolkAppearanceView.h"
#import "TBFolkRoomsView.h"

#import "TBBasicInformationView.h"
#import "TBPovertyAlleviationView.h"

@implementation TBMaskMakeGuideFile

+ (NSMutableArray *)obtainLoadCollectionTask:(NSString *)type;
{
    
    NSMutableArray *viewArray = [NSMutableArray arrayWithCapacity:1];
    NSString *code = [UserInfo account].code;
    // 服务场所
    if ([type isEqualToString:@"service"]) {
        
        TBBasicInformationView *basicInformationView = [[TBBasicInformationView alloc] init];
        [viewArray addObject:basicInformationView];
        
        if (![code isEqualToString:JR_CODE])
        {  // 句容不添加扶贫
            if ([code isEqualToString:GZ_CODE])
            {
                TBGZEmployeesAddView *gzEmployeesAddView = [TBGZEmployeesAddView loadingNibConetenViewWithFrame:CGRectMake(_SCREEN_WIDTH, 0, _SCREEN_WIDTH, 1)];
                
                [viewArray addObject:gzEmployeesAddView];
            }
            else
            {
                TBPovertyAlleviationView *povertyAlleviationView = [[TBPovertyAlleviationView alloc] init];
                [viewArray addObject:povertyAlleviationView];
            }
        }
        
        if (![code isEqualToString:GZ_CODE])
        { // 贵客游不添加此页面
            TBSigningContractInformationView *signingContractInformationView = [[TBSigningContractInformationView alloc] init];
            [viewArray addObject:signingContractInformationView];
        }
        // 银行
        TBBankInformationView *bankView = [[TBBankInformationView alloc] init];
        [viewArray addObject:bankView];
    }
    else // 非服务场所
    {
        // 基本信息
        TBTemplateInfoView *inforView = [[TBTemplateInfoView alloc] init];
        [viewArray addObject:inforView];
        // 老板信息
        TBTemplateBossHeadBaseView *bossHeadView = [[TBTemplateBossHeadBaseView alloc] init];
        [viewArray addObject:bossHeadView];
        
        // 视频录制
        TBMerchantsVideoView *videoView = [[TBMerchantsVideoView alloc] init];
        [viewArray addObject:videoView];
        
        //  蓟州的客栈专有  民俗信息采集
        if ([code isEqualToString:JIZHOU_CODE] && [type isEqualToString:@"hotel"])
        {
            // 民俗外观信息
            TBFolkAppearanceView *appearanceView = [[TBFolkAppearanceView alloc] init];
            [viewArray addObject:appearanceView];
            // 民俗客栈信息
            TBFolkRoomsView *roomsView = [[TBFolkRoomsView alloc] init];
            [viewArray addObject:roomsView];
            
        }
        else
        {
            // 外观
            TBTemplateResourceView *hallView = [[TBTemplateResourceView alloc] init];
            [hallView createLayoutViewType:ResourceImageTypeAppearance];
            [viewArray addObject:hallView];
            // 美食
            TBTemplateResourceView *foodView = [[TBTemplateResourceView alloc] init];
            [foodView createLayoutViewType:ResourceImageTypeFood];
            [viewArray addObject:foodView];
            // 环境
            TBTemplateResourceView *environmentView = [[TBTemplateResourceView alloc] init];
            [environmentView createLayoutViewType:ResourceImageTypeEnvironment];
            [viewArray addObject:environmentView];
            // 老板优惠
            TBPreferentialInformationView *preferentialView = [[TBPreferentialInformationView alloc] init];
            [viewArray addObject:preferentialView];
            // 打折卡
            TBDiscountCardView *discountCardView = [[TBDiscountCardView alloc] init];
            [viewArray addObject:discountCardView];
            
            if (![code isEqualToString:JR_CODE])
            {
                if ([code isEqualToString:GZ_CODE])
                {//  贵州独有-精准扶贫
                    TBGZEmployeesAddView *gzEmployeesAddView = [TBGZEmployeesAddView loadingNibConetenViewWithFrame:CGRectMake(_SCREEN_WIDTH*viewArray.count, 0, _SCREEN_WIDTH, _SCREEN_HEIGHT-64-50)];
                    [viewArray addObject:gzEmployeesAddView];
                }
                else
                {// 精准扶贫
                    TBPovertyAlleviationView *povertyAlleviationView = [[TBPovertyAlleviationView alloc] init];
                    [viewArray addObject:povertyAlleviationView];
                }
            }
            
            if (![code isEqualToString:GZ_CODE])
            {// 签约合同信息
                TBSigningContractInformationView *signingContractInformationView = [[TBSigningContractInformationView alloc] init];
                [viewArray addObject:signingContractInformationView];
            }
        }
        // 银行
        TBBankInformationView *bankView = [[TBBankInformationView alloc] init];
        [viewArray addObject:bankView];
        // 背景
        TBTemplateBackgroundView *backgroundView = [[TBTemplateBackgroundView alloc] init];
        [viewArray addObject:backgroundView];
    }
    
    return viewArray;
}
@end
