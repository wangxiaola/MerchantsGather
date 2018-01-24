//
//  ClearCacheTool.h
//  VideoDemo
//
//  Created by biyuhuaping on 2017/5/5.
//  Copyright © 2017年 biyuhuaping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClearCacheTool : NSObject

/**
  清除缓存
 */
+ (void)clearAction;

/**
 获取缓存大小

 @return 大小
 */
+ (CGFloat)obtainCacheSize;

@end
