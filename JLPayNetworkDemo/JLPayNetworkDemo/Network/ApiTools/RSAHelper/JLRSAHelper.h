//
//  JLRSAHelper.h
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/2.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLRSAHelper : NSObject

/**
 利用公钥加密 NSString
 
 @param str 要加密 str
 @return 加密结果 已经base64 编码
 */
+ (NSString *)encryptString:(NSString *)str;

/**
 利用公钥加密 NSData
 
 @param data 要加密 data
 @return 加密结果 已经base64 编码
 */
+ (NSData *)encryptData:(NSData *)data;

/**
 利用私钥解密 NSString
 
 @param str 要解密 str
 @return 解密结果
 */
+ (NSString *)decryptString:(NSString *)str;

/**
 利用私钥解密 NSData
 
 @param data 要解密 data
 @return 解密结果
 */
+ (NSData *)decryptData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
