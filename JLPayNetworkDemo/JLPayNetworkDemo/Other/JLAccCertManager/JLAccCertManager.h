//
//  JLAccCertManager.h
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/8.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLAccCertManager : NSObject

/**
 请求Cert 包含app_key sdk_key

 @param block 回调
 */
+ (void)getAccCert:(void(^)(BOOL success, id data))block;

/**
 是否有AppCert
 
 @return <#return value description#>
 */
+ (BOOL)isHaveAppCert;


/**
 sdk key
 
 @return <#return value description#>
 */
+ (NSString *)sdkKey;


/**
 app key
 
 @return <#return value description#>
 */
+ (NSString *)appKey;

@end

NS_ASSUME_NONNULL_END
