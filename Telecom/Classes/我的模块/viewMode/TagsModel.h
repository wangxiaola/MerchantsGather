//
//  TagsModel.h
//  Telecom
//
//  Created by 王小腊 on 2017/11/30.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagsModel : NSObject

/**
 名称
 */
@property (nonatomic, strong) NSString *nameText;
/**
 标签标题
 */
@property (nonatomic, strong) NSString *userName;
/**
 标签类型 1贫困 0普通
 */
@property (nonatomic, assign) NSInteger  type;

@property (nonatomic, assign) NSInteger  row;



@end
