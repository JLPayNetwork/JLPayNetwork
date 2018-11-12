//
//  JLPayNetworkClient.h
//  JLPayNetwork
//
//  Created by Canbing Zhen on 2018/10/30.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLPayRequestMethod) {
    /** GET请求方法 */
    JLPayRequestMethodGET = 0,
    /** POST请求方法 */
    JLPayRequestMethodPOST,
    /** HEAD请求方法 */
    JLPayRequestMethodHEAD,
    /** PUT请求方法 */
    JLPayRequestMethodPUT,
    /** PATCH请求方法 */
    JLPayRequestMethodPATCH,
    /** DELETE请求方法 */
    JLPayRequestMethodDELETE
};

/** 缓存方式 */
typedef NS_ENUM(NSUInteger, JLPayCachePolicy) {
    /** 仅从网络获取数据 */
    JLPayCachePolicyNetworkOnly = 0,
    /** 先从网络获取数据，再更新本地缓存 */
    JLPayCachePolicyNetworkAndSaveCache,
    /** 先从网络获取数据，如果获取失败再从缓存获取 */
    JLPayCachePolicyNetworkElseCache,
    /** 仅从缓存获取数据（如果缓存没有数据，返回一个空） */
    JLPayCachePolicyCacheOnly,
    /** 先从缓存获取数据，如果没有再获取网络数据 */
    JLPayCachePolicyCacheElseNetwork,
    /** 先从缓存读取数据，然后在从网络获取并且缓存，在这种情况下，Block将产生两次调用『常用这种』 */
    JLPayCachePolicyCacheThenNetwork
};

/** 网络状态 */
typedef NS_ENUM(NSUInteger, JLPayNetworkStatus) {
    /** 未知网络 */
    JLPayNetworkStatusUnknown,
    /** 无网络 */
    JLPayNetworkStatusNotReachable,
    /** 手机网络 */
    JLPayNetworkStatusReachableViaWWAN,
    /** WIFI网络 */
    JLPayNetworkStatusReachableViaWiFi
};

/** 成功的回调 */
typedef void (^JLPayHttpSuccessBlock)(NSURLSessionDataTask *_Nullable dataTask, id responseObject);
/** 失败的回调 */
typedef void (^JLPayHttpFailureBlock)(NSURLSessionDataTask *_Nullable dataTask, NSError *error);
/** 网络状态Block */
typedef void(^JLPayNetworkStatusBlock)(JLPayNetworkStatus status);

@interface JLPayNetworkClient : NSObject

/**
 GET请求方法

 @param url 请求地址
 @param params 请求参数
 @param cachePolicy 缓存策略
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 */
+ (void)getWithUrl:(NSString *)url
            params:(id)params
       cachePolicy:(JLPayCachePolicy)cachePolicy
           success:(JLPayHttpSuccessBlock)successBlock
           failure:(JLPayHttpFailureBlock)failureBlock;

/**
 *  POST请求方法
 *
 *  @param url 请求地址
 *  @param params 请求参数
 *  @param cachePolicy 缓存策略
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 */
+ (void)postWithUrl:(NSString *)url
             params:(id)params
        cachePolicy:(JLPayCachePolicy)cachePolicy
            success:(JLPayHttpSuccessBlock)successBlock
            failure:(JLPayHttpFailureBlock)failureBlock;

/**
 *  网络请求方法
 *
 *  @param method 请求方法
 *  @param url 请求地址
 *  @param params 请求参数
 *  @param cachePolicy 缓存策略
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 */
+ (void)requestWithMethod:(JLPayRequestMethod)method
                      url:(NSString *)url
                   params:(id)params
              cachePolicy:(JLPayCachePolicy)cachePolicy
                  success:(JLPayHttpSuccessBlock)successBlock
                  failure:(JLPayHttpFailureBlock)failureBlock;

/**
 *  下载文件
 *
 *  @param url              请求地址
 *  @param progress         下载进度的回调
 *  @param success          下载成功的回调
 *  @param failure          下载失败的回调
 *
 */

+ (void)downloadFileWithUrl:(NSString *)url
                   progress:(void(^)(NSProgress *progress))progress
                    success:(void(^)(NSString *filePath))success
                    failure:(void(^)(NSError *error))failure;


/**
 *  上传文件
 *
 *  @param Url              请求地址
 *  @param params           请求参数
 *  @param nameKey          文件对应服务器上的字段
 *  @param filePath         文件本地的沙盒路径
 *  @param progress         上传进度的回调
 *  @param success          请求成功的回调
 *  @param failure          请求失败的回调
 *
 */
+ (void)uploadFileWithUrl:(NSString *)Url
                   params:(id)params
                  nameKey:(NSString *)nameKey
                 filePath:(NSString *)filePath
                 progress:(void(^)(NSProgress *progress))progress
                  success:(void(^)(id responseObject))success
                  failure:(void(^)(NSError *error))failure;

/**
 *  上传单/多张图片
 *
 *  @param Url              请求地址
 *  @param params           请求参数
 *  @param nameKey          图片对应服务器上的字段
 *  @param images           图片数组
 *  @param fileNames        图片文件名数组, 可以为nil, 数组内的文件名默认为当前日期时间"yyyyMMddHHmmss"
 *  @param imageScale       图片文件压缩比 范围 (0.0f ~ 1.0f)
 *  @param imageType        图片文件的类型,例:png、jpg(默认类型)....
 *  @param progress         上传进度的回调
 *  @param success          请求成功的回调
 *  @param failure          请求失败的回调
 *
 */
+ (void)uploadImagesWithUrl:(NSString *)Url
                     params:(id)params
                    nameKey:(NSString *)nameKey
                     images:(NSArray<UIImage *> *)images
                  fileNames:(NSArray<NSString *> *)fileNames
                 imageScale:(CGFloat)imageScale
                  imageType:(NSString *)imageType
                   progress:(void(^)(NSProgress *progress))progress
                    success:(void(^)(id responseObject))success
                    failure:(void(^)(NSError *error))failure;

/** 取消所有Http请求 */
+ (void)cancelAllRequest;

/** 取消指定URL的Http请求 */
+ (void)cancelRequestWithURL:(NSString *)url;

/** 实时获取网络状态 */
+ (void)getNetworkStatusWithBlock:(JLPayNetworkStatusBlock)networkStatusBlock;

/** 是否打开网络加载菊花(默认打开) */
+ (void)openNetworkActivityIndicator:(BOOL)open;

/** 判断当前是否有网络连接 */
+ (BOOL)isNetwork;

/** 判断当前是否是手机网络 */
+ (BOOL)isWWANNetwork;

/** 判断当前是否是WIFI网络 */
+ (BOOL)isWiFiNetwork;

@end

NS_ASSUME_NONNULL_END
