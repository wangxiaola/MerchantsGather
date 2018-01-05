//
//  HUD.h
//  TrainOnline
//
//  Created by tangliang on 16/10/24.
//  Copyright © 2016年 daqsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

void hudConfig(void);
void hudShowLoading(NSString *msg);
void hudShowSuccess(NSString *msg);
void hudShowError(NSString *msg);
void hudShowFailure(void);
void hudDismiss(void);
void hudShowInfo(NSString *msg);

