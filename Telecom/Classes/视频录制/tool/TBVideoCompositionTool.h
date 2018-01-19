//
//  TBVideoCompositionTool.h
//  Telecom
//
//  Created by 王小腊 on 2018/1/17.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface TBVideoCompositionTool : NSObject

+ (AVVideoComposition *)applyVideoEffectsToAVAsset:(AVAsset *)avAsset shopName:(NSString*)name;

@end
