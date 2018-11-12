//
//  JLAES128Helper.m
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/2.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import "JLAES128Helper.h"
#import <CommonCrypto/CommonCryptor.h>
#import "secret.h"

@implementation JLAES128Helper

+ (NSData *)AES128Encrypt:(NSData *)plainData key:(NSString *)key{
    
    if (key == nil || plainData.length < 1 || (key.length != 16 && key.length != 32) ) {
        return nil;
    }
    
    unsigned char *pData = (unsigned char *)[plainData bytes];
    int dateLen          = (int)plainData.length;
    
    const char *aKey     = [key UTF8String];
    unsigned char *pKey  = (unsigned char *)aKey;
    int keyLen           = (int)key.length;
    
    unsigned char *pOut = (unsigned char *)malloc(dateLen+16);
    memset(pOut,0,dateLen+16);
    
    int code = jlencrypt(pKey, keyLen, pData, dateLen, pOut);
    if (code < 0) {
        return nil;
    }
    NSData *resultData = [NSData dataWithBytesNoCopy:pOut length:code];
    return resultData;
}

+(NSData *)AES128Decrypt:(NSData *)encryptData key:(NSString *)key{
    
    if (key == nil || encryptData.length < 1 || (key.length != 16 && key.length != 32)) {
        return nil;
    }
    
    unsigned char *pData = (unsigned char *)[encryptData bytes];
    int dateLen          = (int)encryptData.length;
    
    const char *aKey     = [key UTF8String];
    unsigned char *pKey  = (unsigned char *)aKey;
    int keyLen           = (int)key.length;
    
    unsigned char *pOut = (unsigned char *)malloc(dateLen+16);
    memset(pOut,0,dateLen+16);
    
    int code = jldecrypt(pKey, keyLen, pData, dateLen, pOut);
    if (code < 0) {
        return nil;
    }
    NSData *resultData = [NSData dataWithBytesNoCopy:pOut length:code];
    return resultData;
}

@end
