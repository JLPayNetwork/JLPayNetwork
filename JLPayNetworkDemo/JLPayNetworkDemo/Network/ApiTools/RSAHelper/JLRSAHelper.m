//
//  JLRSAHelper.m
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/2.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import "JLRSAHelper.h"
#import <RSAUtil/RSAUtil.h>
#import <GTMBase64/GTMBase64.h>

static NSString *publicKey = @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAt9YqYSSHKDvec6DkF9llYjHaOSOVIBYN2cyvWDWBwG0FNq6X2sDigcU2djK6MpkXolBC+WtAgds0a94cPIDoXzkbdYyug2dNOq7Hoc4D02QpeWRnk2xhU3jtlUsrZvD49TXxIe+sBZBWEzhkyAiPl7AwNNFh5SPbbiS/6SdV4HQAEWLqzaTgRzPDIfrb/K7gSuKvFp6Lf6QCyW3vtp3JWhGlaG6aB5bTrDBsux9fq/ARImO01WtLTZSXCr8XfPkOVkycfB9xFo15RtzLQ45zUO+djM9lGQRlJWVa0YqDWHwAYceOKoLCGhlSwyj8nTkywHzoZutBe8/Q7vg8xqPkswIDAQAB";
static NSString *privateKey = @"MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDYNKvpSLdXYw0pS9A+RrJ6lEi1Siriq/bpp/dMmpbZOXo0wm/2cMHM0OJTrOVFCi4Ps3tsETh2MbH0O1wVKKbdTGAz0L4lGc9y5AlBmVCmBv9/A6kAprV3Fxnu4pgp8qorqYPvOFtvetiS6U59KWwBTQQ/TJpUbJ6yKqIWOpFhAHxZwvAy7pndM8f4uwUzgTfuLuYFYuDZ2cF9hoW8iNwq8ZNYRIVsnsE9ubDwbV2iII/v6v7ql2GMlJ6T26o1W+BRdkXvhxXtqlmkz1f6VE6I1w15pPeukibortHTtChoVFWmES1E5Rq1ef8g6Rz1mgHjSy6Isn5hfN5e1F3TCYkJAgMBAAECggEAJpaYDEYHOxiZs8ItQ8A4gLpQk9LN/rD0m9V3xPteaxzgG+SMOS782AJ8MrUMIptjhzfgknQsYKQT/+RMVhZwWdUU4oqiNVr69KWQpV2o0Ek1dsT/d/dJMh00areUsv/1sV9LBfpID4icePQdJyeqeDz3whh4/xJ37JLBZThE1Ev+rRd0JtCN3UeJoeEFWgyUhcXIDAQXTtEUuhH7Oy4gv2Eg6eZg9928ni7SDCnuJCGzwtBDHlQgjVM+tV1tzuWHXVa9PrcDT4kFZDYgCMLvEwkeXLco6iiRJ7S0WZbTZuNMYffjzm4qB/Z3af0ecL8Uv9uB7G0lXA0Pfef0CDoTVQKBgQD9xWH2BwRGUUvAY932PabNZpjtJj4RXB1zeXekNp4VI7YrzN0fn2F9eXYu2oQZacJ4BdKWB+lrEElvTtjM522eHW/zw2SfdbAQSiSUEhFvrzA0IRzS9DN+hGf3T0EXoLC6ZuTj01ataUI5ZUsTdfB9ESfcWiUckXsW1a3oy8MizwKBgQDaGtJGhphkcjQV0fRtdl52pZAcVNJQtTU8EOlcoMkCTmLQjX+g2DuGbtro/mJgbgkMBOIctZxptIXtAeflrfsT+6TqbExwgPGT2U9MaZYE0rATgByxCCnteszs+5Ikz88htU6yUGZX+mAZlwMppu+hbVj34cDAyxLLedeaeKnspwKBgF3qdIyWoDBd2ckDrJt6yYZul938LzBBhOy9YVe2lt5/7uVa1eLkGzJShzhjykuVZlEA5qR7nRjwWB0Hcxix9VF013/BKjYRWe1NYyghX66TiSVhs8cmdQA3hDp0bESQRZdWiRL/na5jrAyNvjEfjrbaaIQWIHHoLUOQJOJotnjlAoGAJkL4SokIKO7j9kP71kwirDvFOUMkFiaD7UKmPaqzOKVZrm50SlpErwO5gZBG39XN3n7oz9KIWv7hU7+219MardnCh6FyE3Z7as1/nM8VE0mGvBUIc4IUIOYfFx/W9oBCPQ6afKugGKUCwNp+Iot3lGEjb3D6KJg3dtysFxw96xcCgYA5dbtZZobxOZb5Y5QGA9Ce4euvJWFWmUTqfk182s53MwswDp42FmQZBexiMCiFXUrnNAmMZbOQssZ1/adx666SaipAVeD2V2d4MoT/419c0dndrZuazif6WYUQ6nj4hXsCsXahFB7+DT8yw05SQHSN3mFUy/2Sn/S50noJo3bdWg==";

@implementation JLRSAHelper

/**
 利用公钥加密 NSString
 
 @param str 要加密 str
 @return 加密结果 已经base64 编码
 */
+ (NSString *)encryptString:(NSString *)str
{
    return [RSAUtil encryptString:str publicKey:publicKey];
}

/**
 利用公钥加密 NSData
 
 @param data 要加密 data
 @return 加密结果 已经base64 编码
 */
+ (NSData *)encryptData:(NSData *)data
{
    return [RSAUtil encryptData:data publicKey:publicKey];
}

/**
 利用私钥解密 NSString
 
 @param str 要解密 str
 @return 解密结果
 */
+ (NSString *)decryptString:(NSString *)str
{
    return [RSAUtil decryptString:str privateKey:privateKey];
}

/**
 利用私钥解密 NSData
 
 @param data 要解密 data
 @return 解密结果
 */
+ (NSData *)decryptData:(NSData *)data
{
    return [RSAUtil decryptData:[GTMBase64 decodeData:data] privateKey:privateKey];
}

@end
