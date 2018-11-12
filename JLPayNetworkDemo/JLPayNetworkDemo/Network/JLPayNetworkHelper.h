//
//  JLPayNetworkHelper.h
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/1.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonResult.h"

@class JLAppCertModel;

NS_ASSUME_NONNULL_BEGIN

@interface JLPayNetworkHelper : NSObject

/**
 POST

 @param params 请求参数
 @param success 请求成功的回调
 @param failure 请求失败的回调
 */
+ (void)postWithParams:(NSDictionary *)params
            success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, JsonResult * _Nullable jsonResult))success
            failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;

/**
 请求sdk_key和app_key

 @param params 请求参数
 @param success 请求成功回调
 @param failure 请求失败回调
 */
+ (void)accCertPostWithParams:(NSDictionary *)params
                      success:(void (^) (NSURLSessionDataTask *_Nullable dataTask, JLAppCertModel *certModel))success
                      failure:(void(^)(NSURLSessionDataTask *_Nullable dataTask, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
