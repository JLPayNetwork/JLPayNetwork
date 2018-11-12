//
//  JLApiOpera+Encrypt.m
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/12.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import "JLApiOpera+Encrypt.h"
#import "JLAES128Helper.h"
#import "JLRSAHelper.h"

@implementation JLApiOpera (Encrypt)

#pragma mark - 数据加解密
/**
 AES加密处理
 
 @param plainText 明文字符串
 @param key 加密key
 @return 加密结果
 */
+ (NSData *)AESEncryptText:(NSString *)plainText key:(NSString *)key
{
    NSData* data    = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSData *aesData = [JLAES128Helper AES128Encrypt:data key:key];
    return aesData;
}

/**
 AES解密处理
 
 @param encryptData 已加密数据
 @param key 解密key
 @return 解密结果
 */
+ (NSData *)AESDecryptData:(NSData *)encryptData key:(NSString *)key
{
    return [JLAES128Helper AES128Decrypt:encryptData key:key];
}

/**
 利用公钥加密 NSString
 
 @param str 要加密 str
 @return 加密结果 已经base64 编码
 */
+ (NSString *)RSAEncryptString:(NSString *)str
{
    return [JLRSAHelper encryptString:str];
}

/**
 利用公钥加密 NSData
 
 @param data 要加密 data
 @return 加密结果 已经base64 编码
 */
+ (NSData *)RSAEncryptData:(NSData *)data
{
    return [JLRSAHelper encryptData:data];
}

/**
 利用私钥解密 NSString
 
 @param str 要解密 str
 @return 解密结果
 */
+ (NSString *)RSADecryptString:(NSString *)str
{
    return [JLRSAHelper decryptString:str];
}

/**
 利用私钥解密 NSData
 
 @param data 要解密 data
 @return 解密结果
 */
+ (NSData *)RSADecryptData:(NSData *)data
{
    return [JLRSAHelper decryptData:data];
}

@end
