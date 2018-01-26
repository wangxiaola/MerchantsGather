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

 @param successful 清除成功
 */
+ (void)clearActionSuccessful:(void(^)())successful;

/**
 获取缓存大小

 @return 大小
 */
+ (CGFloat)obtainCacheSize;

@end
