//
//  JLApiOpera.h
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/2.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLApiOpera : NSObject

/**
 组数据 带签名
 
 @param dic 参数
 @param sign 签名
 @param commandId commandId
 @return NSDictionary
 */
+ (NSDictionary *_Nonnull)parametersBody:(NSDictionary *_Nonnull)dic sign:(NSString *_Nullable)sign commandID:(NSInteger)commandId;


/**
 组数据 带tokenID
 
 @param dic 参数
 @param tokenID tokenID
 @return NSDictionary
 */
+ (NSDictionary *_Nonnull)parametersBody:(NSDictionary *_Nonnull)dic tokenID:(NSString *_Nullable)tokenID commandID:(NSInteger)commandId;

/**
 组数据
 
 @param dic 参数
 @param commandId commandId
 @return NSDictionary
 */
+ (NSDictionary *_Nonnull)parametersBody:(NSDictionary *_Nonnull)dic commandID:(NSInteger)commandId;


/**
 组数据 带sign  tokenid
 
 @param dic 参数
 @param tokenID tokenID
 @param sign sign签名
 @param commandId commandId
 @return NSDictionary
 */
+ (NSDictionary *_Nullable)parametersBody:(NSDictionary *_Nullable)dic tokenID:(NSString *_Nullable)tokenID  sign:(NSString *_Nullable)sign commandID:(NSInteger)commandId;

/**
 重新加载Ticket
 
 @param parameters <#parameters description#>
 @return <#return value description#>
 */
+ (NSDictionary *_Nullable)addTicketValueInParameters:(NSDictionary *_Nullable)parameters;

/**
 参数加密
 
 @param parameters <#parameters description#>
 @return <#return value description#>
 */
+ (NSData *_Nullable)encryptParameters:(NSDictionary *_Nullable)parameters;

/**
 数据解密
 
 @param response <#response description#>
 @param data <#data description#>
 @return <#return value description#>
 */
+ (id _Nullable )apiDataDecryWith:(NSURLResponse *_Nullable)response reponseData:(NSData *_Nullable)data;

/**
 请求头文件
 
 @return <#return value description#>
 */
+ (NSDictionary *_Nonnull)requestHeader;

@end

NS_ASSUME_NONNULL_END
