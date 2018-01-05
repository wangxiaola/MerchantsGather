//
//  ZKPostHttp.h
//  Emergency
//
//  Created by 王小腊 on 2016/11/23.
//  Copyright © 2016年 王小腊. All rights reserved.
//

@interface ZKCache : NSObject
@end

@interface NSError (ZKHttp)
/**HTTP请求的状态码*/
@property (nonatomic, assign) NSInteger statusCode;

@end


#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, ZKCacheType)
{
    ZKCacheTypeReturnCacheDataThenLoad = 0,   //  有缓存就先返回缓存，同步请求数据
    ZKCacheTypeReloadIgnoringLocalCacheData, // 忽略缓存，重新请求
    ZKCacheTypeReturnCacheDataElseLoad, // 有缓存就用缓存，没有缓存就重新请求(用于数据不变时)
    ZKCacheTypeReturnCacheDataDontLoad, // 有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
    ZKCacheTypeReturnCacheDataExpireThenLoad //  有缓存就用缓存，如果过期了就重新请求 没过期就不请求
};

@interface ZKPostHttp : NSObject

/**
 无缓存post请求
 
 @param url 请求的API地址
 @param params 参数
 @param success 成功回调Block
 @param failure 失败回调Block
 */
+ (void)post:(NSString *)url params:(NSMutableDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

/**
 post请求
 
 @param url 请求的API地址
 @param params 参数
 @param cacheType YBCacheType 请求类型
 @param success 成功回调Block
 @param failure 失败回调Block
 */
+ (void)post:(NSString *)url params:(NSMutableDictionary *)params cacheType:(ZKCacheType)cacheType success:(void (^)(NSDictionary *obj))success failure:(void (^)(NSError *error))failure;

/**
 get请求
 
 @param url 请求的API地址
 @param params 参数
 @param success 成功回调Block
 @param failure 失败回调Block
 */
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *obj))success failure:(void (^)(NSError *error))failure;

/**
 get请求
 
 @param url 请求的API地址
 @param params 参数
 @param cacheType YBCacheType  请求类型
 @param success 成功回调Block
 @param failure 失败回调Block
 */
+ (void)get:(NSString *)url params:(NSDictionary *)params cacheType:(ZKCacheType)cacheType success:(void (^)(NSDictionary *obj))success failure:(void (^)(NSError *error))failure;



/**
 *  上传单张图片
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param imag    请求imageData
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)uploadImage:(NSString *)url params:(NSMutableDictionary *)params Data:(id)imag success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;

/**
 上传多张图片
 
 @param images 图片二进制数组
 @param success 成功回调Block
 @param failure 失败回调Block
 */
+ (void)uploadImageArrayWithImages:(NSArray<NSData *> *)images success:(void (^)(NSDictionary *obj))success failure:(void (^)(NSError *error))failure;

/**
 *  多类型上传文件
 *
 *  @param url        请求路径
 *  @param params     参数
 *  @param mediaDatas 数据 （图片：UIImage  视频和音频都穿NSdata）
 *  @param type       0图片  1视频  2音频
 *  @param success    请求成功后的回调
 *  @param failure    请求失败后的回调
 */
+ (void)scPpostImage:(NSString *)url params:(NSMutableDictionary *)params dataArray:(NSData *)mediaDatas type:(NSInteger)type success:(void(^)(id responseObj, NSInteger dataType))success failure:(void(^)(NSError *error, NSInteger dataType))failure;

/**
 *  ios自带的 GET 请求方式
 *
 *  @param path     url
 *  @param params   参数
 *  @param callback 回调
 */
+ (void)getddByUrlPath:(NSString *)path
            andParams:(NSString *)params
          andCallBack:(void (^)(id responseObj))callback;


/**
 不带域名的请求

 @param path 路径
 @param params 参数
 @param success 返回
 @param failure 异常
 */
+ (void)postPath:(NSString *)path
            params:(NSMutableDictionary *)params
            success:(void (^)(id responseObj))success
            failure:(void (^)(NSError *error))failure;

@end
