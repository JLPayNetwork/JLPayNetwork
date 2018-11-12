//
//  JLPayNetworkConfig.h
//  JLPayNetwork
//
//  Created by Canbing Zhen on 2018/10/26.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AFSecurityPolicy;
@class HttpsAuthModel;

/** 请求序列化类型 */
typedef NS_ENUM(NSUInteger, JLPayRequestSerializer) {
    /** 设置请求数据为JSON格式 */
    JLPayRequestSerializerJSON,
    /** 设置请求数据为二进制格式 */
    JLPayRequestSerializerHTTP
};

/** 响应序列化类型 */
typedef NS_ENUM(NSUInteger, JLPayResponseSerializer) {
    /** 设置响应数据为JSON格式 */
    JLPayResponseSerializerJSON,
    /** 设置响应数据为二进制格式 */
    JLPayResponseSerializerHTTP
};

typedef NS_ENUM(NSUInteger, JLPayDataEncryptedType) {
    /** 数据明文传输*/
    JLPayDataEncryptedTypeDefault,
    /** 数据密文传输*/ //aes加密
    JLPayDataEncryptedTypeCipherAES,
};


@interface JLPayNetworkConfig : NSObject

+ (JLPayNetworkConfig *)sharedConfig;

@property (nonatomic, strong) NSString                *baseUrl;
@property (nonatomic, strong) AFSecurityPolicy        *securityPolicy;
@property (nonatomic        ) BOOL                    debugLogEnabled;
@property (nonatomic, assign) int                     timeOut;//接口超时时间
@property (nonatomic, assign) JLPayRequestSerializer  requestSerializerType;
@property (nonatomic, assign) JLPayResponseSerializer responseSerializerType;
@property (nonatomic, assign) JLPayDataEncryptedType  dataEncryptedType;
@property (nonatomic, copy  ) NSDictionary            *headerDic;
@property (nonatomic, strong) HttpsAuthModel          *httpsAuthModel;

@end

@interface HttpsAuthModel : NSObject

@property (nonatomic, copy) NSString *p12Name;
@property (nonatomic, copy) NSString *p12Password;
@property (nonatomic, copy) NSString *cerName;

@end

NS_ASSUME_NONNULL_END
