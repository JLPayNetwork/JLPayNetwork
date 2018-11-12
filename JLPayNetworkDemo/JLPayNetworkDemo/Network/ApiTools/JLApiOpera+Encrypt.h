//
//  JLApiOpera+Encrypt.h
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/12.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import "JLApiOpera.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLApiOpera (Encrypt)

#pragma mark - 数据加解密
/**
 AES加密处理
 
 @param plainText 明文字符串
 @param key 加密key
 @return 加密结果
 */
+ (NSData *)AESEncryptText:(NSString *)plainText key:(NSString *)key;

/**
 AES解密处理
 
 @param encryptData 已加密数据
 @param key 解密key
 @return 解密结果
 */
+ (NSData *)AESDecryptData:(NSData *)encryptData key:(NSString *)key;

/**
 利用公钥加密 NSString
 
 @param str 要加密 str
 @return 加密结果 已经base64 编码
 */
+ (NSString *)RSAEncryptString:(NSString *)str;

/**
 利用公钥加密 NSData
 
 @param data 要加密 data
 @return 加密结果 已经base64 编码
 */
+ (NSData *)RSAEncryptData:(NSData *)data;

/**
 利用私钥解密 NSString
 
 @param str 要解密 str
 @return 解密结果
 */
+ (NSString *)RSADecryptString:(NSString *)str;

/**
 利用私钥解密 NSData
 
 @param data 要解密 data
 @return 解密结果
 */
+ (NSData *)RSADecryptData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
