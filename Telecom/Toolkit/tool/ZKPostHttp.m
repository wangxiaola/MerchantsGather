//
//  ZKPostHttp.m
//  Emergency
//
//  Created by 王小腊 on 2016/11/23.
//  Copyright © 2016年 王小腊. All rights reserved.
//

#import "ZKPostHttp.h"
#import "AFNetworking.h"
#import <objc/runtime.h>

@interface  ZKCache()

@property (nonatomic, copy) NSString *fileName;//缓存文件名

@property (nonatomic, assign) BOOL result;//是否需要重新请求数据

@end

@implementation ZKCache



@end

static char *NSErrorStatusCodeKey = "NSErrorStatusCodeKey";

@implementation NSError (ZKHttp)

- (void)setStatusCode:(NSInteger)statusCode
{
    objc_setAssociatedObject(self, NSErrorStatusCodeKey, @(statusCode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSInteger)statusCode
{
    return [objc_getAssociatedObject(self, NSErrorStatusCodeKey) integerValue];
}

@end

@implementation ZKPostHttp

//错误处理
+ (void)errorHandle:(NSURLSessionDataTask * _Nullable)task error:(NSError * _Nonnull)error failure:(void (^)(NSError *))failure
{
    
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSInteger statusCode = response.statusCode;
    
    error.statusCode = statusCode;
    
    if (statusCode == 401) {//密码错误
        
    } else if (statusCode == 0) {//没有网络
        
    } else if (statusCode == 500) {//参数错误
        
    } else if (statusCode == 404) {
        
    } else if (statusCode == 400) {
        
    }
    
    if (failure) {
        failure(error);
    }
}

+ (NSString *)fileName:(NSString *)url params:(NSDictionary *)params
{
    NSMutableString *mStr = [NSMutableString stringWithString:url];
    if (params != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [mStr appendString:str];
    }
    return mStr;
}

+ (AFHTTPSessionManager *)sessionManager
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置接受的类型
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //设置请求超时
    sessionManager.requestSerializer.timeoutInterval = 10;
    return sessionManager;
}

#pragma mark 请求实现


+ (ZKCache *)getCache:(ZKCacheType)cacheType url:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *))success
{
    //缓存数据的文件名
    NSString *fileName = [self fileName:url params:params];
    NSData *data = [ZKUtil getCacheFileName:fileName];
    
    ZKCache *cache = [[ZKCache alloc] init];
    cache.fileName = fileName;
    
    if (data.length)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if (cacheType == ZKCacheTypeReloadIgnoringLocalCacheData) {//忽略缓存，重新请求
            
        } else if (cacheType == ZKCacheTypeReturnCacheDataDontLoad) {//有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
            
        } else if (cacheType == ZKCacheTypeReturnCacheDataElseLoad) {//有缓存就用缓存，没有缓存就重新请求(用于数据不变时)
            if (success) {
                success(dict);
            }
            cache.result = YES;
            
        } else if (cacheType == ZKCacheTypeReturnCacheDataThenLoad) {///有缓存就先返回缓存，同步请求数据
            if (success) {
                success(dict);
            }
        } else if (cacheType == ZKCacheTypeReturnCacheDataExpireThenLoad) {//有缓存 判断是否过期了没有 没有就返回缓存
            //判断是否过期
            if (![ZKUtil isExpire:fileName]) {
                if (success) {
                    success(dict);
                }
                cache.result = YES;
            }
        }
    }
    return cache;
}

+ (void)get:(NSString *)url params:(NSDictionary *)params cacheType:(ZKCacheType)cacheType success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *sessionManager = [self sessionManager];
    
    NSString *httpStr = [[NSString stringWithFormat:@"%@%@",POST_URL,url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //缓存数据的文件名 data
    ZKCache *cache = [self getCache:cacheType url:url params:params success:success];
    NSString *fileName = cache.fileName;
    if (cache.result) return;
    TBWeakSelf
    [sessionManager GET:httpStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success)
        {
            success(responseObject);
        }
        
        if (success && cacheType != ZKCacheTypeReloadIgnoringLocalCacheData&&responseObject!=nil)
        {
            //缓存数据
            NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            [ZKUtil cacheForData:data fileName:fileName];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf errorHandle:task error:error failure:failure];
    }];
}

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [self get:url params:params cacheType:ZKCacheTypeReloadIgnoringLocalCacheData success:success failure:failure];
}

+ (void)post:(NSString *)url params:(NSMutableDictionary *)params cacheType:(ZKCacheType)cacheType success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *sessionManager = [self sessionManager];
    
    NSString *httpStr = [[NSString stringWithFormat:@"%@%@",POST_URL,url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //缓存数据的文件名 data
    ZKCache *cache = [self getCache:cacheType url:url params:params success:success];
    NSString *fileName = cache.fileName;
    if (cache.result) return;
    params[@"shopcode"] = [UserInfo account].code;
    MMLog(@"\n\n%@\n%@\n\n",httpStr,params);
    TBWeakSelf
    [sessionManager POST:httpStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       id response = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (success)
        {
            success(response);
        }
        if (success && cacheType != ZKCacheTypeReloadIgnoringLocalCacheData&&response!=nil) {
            //缓存数据
            NSData *data = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:nil];
            [ZKUtil cacheForData:data fileName:fileName];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [weakSelf errorHandle:task error:error failure:failure];
    }];
}

+ (void)post:(NSString *)url params:(NSMutableDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;
{
    AFHTTPSessionManager *manager = [self sessionManager];
    NSString *httpStr = [[NSString stringWithFormat:@"%@",POST_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    params[@"shopcode"] = [UserInfo account].code;
    MMLog(@"\n\n%@\n%@\n\n",httpStr,params);
    [manager POST:httpStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            id response = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            success(response);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            
            failure(error);
        }
    }];
}


+ (void)uploadImage:(NSString *)url params:(NSMutableDictionary *)params Data:(id)imag success:(void(^)(id responseObj))success failure:(void(^)(NSError *error))failure;
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    params[@"shopcode"] = [UserInfo account].code;
    [manager POST:[NSString stringWithFormat:@"%@",POST_URL] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //添加要上传的文件，此处为图片
        [formData appendPartWithFileData:imag name:@"Filedata" fileName:@".png" mimeType:@"image/jpeg）"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
}

+ (void)uploadImageArrayWithImages:(NSArray<NSData *> *)images success:(void (^)(NSDictionary *obj))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *sessionManager = [self sessionManager];
    [sessionManager.requestSerializer setValue:@"image/jpg" forHTTPHeaderField:@"Content-Type"];
    NSString *httpStr = @"http://file.geeker.com.cn/iosUpload";
    TBWeakSelf
    [sessionManager POST:httpStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
    {
        [images enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //upfiles 是参数名 根据项目修改
            [formData appendPartWithFileData:obj name:@"Filedata" fileName:[NSString stringWithFormat:@"%.0f.jpg", [[NSDate date] timeIntervalSince1970]] mimeType:@"image/jpg"];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            [weakSelf errorHandle:task error:error failure:failure];
        }
    }];
}


+ (void)scPpostImage:(NSString *)url params:(NSMutableDictionary *)params dataArray:(NSData *)mediaDatas type:(NSInteger)type success:(void(^)(id responseObj, NSInteger dataType))success failure:(void(^)(NSError *error, NSInteger dataType))failure;
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    if (type == 2)
    {
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    }
    params[@"shopcode"] = [UserInfo account].code;
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
            
            if (type == 0)
            {
                //                添加要上传的文件，此处为图片
                [formData appendPartWithFileData:mediaDatas name:@"Filedata" fileName:@".png" mimeType:@"image/jpeg"];
                
            }
            else if(type == 1)
            {        // 视频
                [formData appendPartWithFileData:mediaDatas name:@"Filedata" fileName:@"video.mp4" mimeType:@"video/quicktime"];
                
            }
            else if (type == 2)
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]]; //fileName这里取当前时间戳  voice
                NSString *fileName = [NSString stringWithFormat:@"%@.mp3", str];
                [formData appendPartWithFileData:mediaDatas name:@"Filedata" fileName:fileName mimeType:@"wav/mp3/wmr"];
                
            }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id response = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];

        if (success) {
            
         success(response,type);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        //取消所有的网络请求
        [manager.operationQueue cancelAllOperations];

        if (failure) {
            failure(error,type);
            
        }
    }];
    
}

//ios自带的get请求方式
+(void)getddByUrlPath:(NSString *)path andParams:(NSString *)params andCallBack:(void (^)(id))callback{
    
    if (params) {
        
        
        [path stringByAppendingString:[NSString stringWithFormat:@"?%@",params]];
    }
    
    NSString*  pathStr = [path  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    MMLog(@"url:%@",pathStr);
    NSURL *url = [NSURL URLWithString:pathStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                callback(jsonData);
                
            }else {
                callback(nil);
            }
            
        });
        
    }];
    //开始请求
    [task resume];
}
+ (void)postPath:(NSString *)path
          params:(NSMutableDictionary *)params
         success:(void (^)(id responseObj))success
         failure:(void (^)(NSError *error))failure;
{
   
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置请求超时
    sessionManager.requestSerializer.timeoutInterval = 10;

    params[@"shopcode"] = [UserInfo account].code;
    [sessionManager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {

            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
  }];

}
@end
