//
//  JLApiOpera+Accert.m
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/6.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import "JLApiOpera+Accert.h"
#import "JLApiTools.h"
#import "JLApiOpera+Encrypt.h"
#import "JLAPI.h"

#define JLAppId  @"LS201809181824"

@implementation JLApiOpera (Accert)

+ (NSDictionary *)accertParamaters
{
//    1. 原始参数
    NSDictionary *oriDic = [JLApiOpera oriAccertParamaters];
//    2.字典转json字符串
    NSString *jsonStr = [JLApiOpera accertParamatersToJsonString:oriDic];
//    3.rsa加密
    NSString *rsaStr = [JLApiOpera encryptedStringWithRSA:jsonStr];
//    4.组装交易参数
    NSDictionary *dic = @{
                          @"app_id":JLAppId,
                          @"context":rsaStr != nil?rsaStr:@""
                          }.copy;
    return dic;
}

+ (NSDictionary *)oriAccertParamaters
{
    NSDictionary *encryptedDic = [JLAPI encryptedKeyDic];
    NSDictionary *dic = @{@"sdk_id":encryptedDic[@"Encrypted_ID"],
                          @"sdk_version":encryptedDic[@"Encrypted_VERSION"],
                          @"device_uuid":[JLApiTools getUUIDFromKeychainItemWrapper] != nil?[JLApiTools getUUIDFromKeychainItemWrapper]:@"",
                          @"timestamp":[JLApiTools getCurrentTime]
                          }.copy;
    return dic;
}

+ (NSString *)accertParamatersToJsonString:(NSDictionary *)dic
{
    if (dic == nil || dic.count < 1) {
        return nil;
    }
    NSString *jsonStr = nil;
    jsonStr = [JLApiTools jsonStringWithJsonData:dic];
    return jsonStr;
}

+ (NSString *)encryptedStringWithRSA:(NSString *)oriStr
{
    if (oriStr == nil || oriStr.length < 1) {
        return nil;
    }
    NSString *rsaStr = nil;
    rsaStr = [JLApiOpera RSAEncryptString:oriStr];
    return rsaStr;
}

/**
 accert接口返回数据解密处理
 
 @param response response
 @param data data
 @return 解析后结果
 */
+ (NSData *)accertRSADataDecryWith:(NSURLResponse *)response reponseData:(NSData *)data
{
    NSHTTPURLResponse *httpReponse = nil;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        httpReponse = (NSHTTPURLResponse *)response;
    }
    NSData *mutbale = data.mutableCopy;
    
    if (httpReponse && httpReponse.statusCode == 200) {
        
        NSData *data = [JLApiOpera RSADecryptData:mutbale];
        if (!data) {
            
            NSString *reponseStr = [[NSString alloc] initWithData:mutbale encoding:NSUTF8StringEncoding];
            NSLog(@"RSA decrypt fail:%@",reponseStr);
            return mutbale;
        }
        NSData *operData = data;
        if (!operData) {
//            DLog(@"RSA oper data is nil");
        }
        
        return operData;
    }
    else{
        return mutbale;
    }
}

@end
