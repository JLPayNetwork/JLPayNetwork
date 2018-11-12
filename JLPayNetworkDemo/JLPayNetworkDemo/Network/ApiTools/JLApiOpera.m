//
//  JLApiOpera.m
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/2.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import "JLApiOpera.h"
#import "JLAccCertManager.h"
#import "JLTicketManager.h"
#import "JLApiTools.h"
#import "JLApiOpera+Encrypt.h"
#import <YYKit/YYKit.h>
#import "JLAPI.h"

@interface JLApiOpera ()

@property (nonatomic,copy) NSDictionary *apiBaseDict;

@end

@implementation JLApiOpera

//单态类保存接口公共数据
+ (instancetype)share{
    
    static JLApiOpera *apiOpera;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        apiOpera = [[JLApiOpera alloc] init];
    });
    return apiOpera;
}

#define SeqID    1
#define NodeType 0
#define NodeID   @"ios"

#pragma mark - 公共的接口参数
+ (NSDictionary *)baseParam{
    
    if ([[JLApiOpera share].apiBaseDict allKeys].count > 0) {
        return [JLApiOpera share].apiBaseDict;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"SeqID"]     = @(SeqID);
    parameters[@"NodeType"]  = @(NodeType);
    parameters[@"NodeID"]    = NodeID;
    
    NSString *versionStr        = [NSString stringWithFormat:@"%@.%@",[JLApiTools getAppVersion],[JLApiTools getAppBuildVersion]];
    parameters[@"Version"]      = versionStr;
    
    NSString *buildVersion      = [JLApiTools getAppBuildVersion];
    parameters[@"BuildVersion"] = buildVersion;
    
    NSString *sysNum            = [JLApiTools getDeviceSysytemVersion];
    parameters[@"SysNum"]       = sysNum;
    
    NSString *deviceUUID        = [JLApiTools getUUIDFromKeychainItemWrapper];
    parameters[@"DeviceUUID"]   = deviceUUID;
    
    if (versionStr.length > 0 && buildVersion.length > 0 &&
        sysNum.length > 0 && deviceUUID.length > 0) {
        
        [JLApiOpera share].apiBaseDict = parameters.copy;
    }
    
    return parameters.copy;
}

+ (NSDictionary *_Nullable)addTicketValueInParameters:(NSDictionary *_Nullable)parameters{
    
    NSDictionary *body     = parameters[@"Body"];
    NSDictionary *signBody = [self signBodyDict:body];
    
    NSMutableDictionary *newParamters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [newParamters setObject:signBody forKey:@"Body"];
    
    return [newParamters copy];
}

#pragma mark - 数据加密
+ (NSData *)encryptParameters:(NSDictionary *)parameters
{
    NSString *jsonString = [JLApiTools jsonStringWithJsonData:parameters];
    NSData *aesData = [JLApiOpera AESEncryptText:jsonString key:[JLAccCertManager sdkKey]];
    NSData *data    = aesData;
    if (data == nil) {
        NSLog(@"交易参数设置失败~~~~");
        return nil;
    }
    return data;
}

#pragma mark - 数据解密处理
+ (id)apiDataDecryWith:(NSURLResponse *)response reponseData:(NSData *)data{
    
    NSHTTPURLResponse *httpReponse = nil;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        httpReponse = (NSHTTPURLResponse *)response;
    }
    
    NSData *mutbale = data.mutableCopy;
    if (httpReponse && httpReponse.statusCode == 200) {
        
        NSData *data = [JLApiOpera AESDecryptData:mutbale key:[JLAccCertManager sdkKey]];
        if (!data) {
            
            NSString *reponseStr = [[NSString alloc] initWithData:mutbale encoding:NSUTF8StringEncoding];
            NSLog(@"decrypt fail:%@",reponseStr);
            return mutbale;
        }
        
        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData *operData = [JLApiTools operationJsonString:jsonStr];
        if (!operData) {
            NSLog(@"oper data is nil");
        }
        
        return operData;
    }
    else{
        return mutbale;
    }
}

#pragma mark - body参数签名
+ (NSDictionary *)signBodyDict:(NSDictionary *)body{
    
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithDictionary:body];
    
    NSString *ticket = [JLTicketManager ticket];
    if (ticket.length > 0) {
        
        [mutableDict removeObjectForKey:@"Ticket"];
        [mutableDict removeObjectForKey:@"Nonce"];
        [mutableDict removeObjectForKey:@"TicketSign"];
        
        mutableDict[@"Ticket"] = ticket;
        mutableDict[@"Nonce"]  = [JLApiTools getRandomStringWithNum:32];
        
        NSString *bodyString = [self keyValueStringWithDict:mutableDict];
        bodyString = [NSString stringWithFormat:@"app_key=%@&%@",[JLAccCertManager appKey],bodyString];
        
        NSString *resultStr        = [[bodyString sha256String] lowercaseString];
        NSString *ticketSignStr    = [resultStr base64EncodedString];
        mutableDict[@"TicketSign"] = ticketSignStr;
    }
    
    return mutableDict;
}

//拼接key value string
+ (NSString *)keyValueStringWithDict:(NSDictionary *)dict{
    
    NSArray *keyArray = [dict allKeys];
    
    NSArray *newArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        return [obj1 compare:obj2];
    }];
    
    NSMutableString *keyValueStr = [NSMutableString string];
    for (int i = 0;i < newArray.count;i++) {
        
        NSString *key   = newArray[i];
        NSString *value = dict[key];
        
        //value为空则不参与计算
        if ([value isKindOfClass:[NSString class]] && value.length < 1) {
            continue;
        }
        
        if (keyValueStr.length == 0) {
            [keyValueStr appendFormat:@"%@=%@",key,value];
        }
        else{
            [keyValueStr appendFormat:@"&%@=%@",key,value];
        }
    }
    
    return keyValueStr;
}

/**
 组数据 带签名
 
 @param dic 参数
 @param sign 签名
 @param commandId commandId
 @return NSDictionary
 */
+ (NSDictionary *_Nonnull)parametersBody:(NSDictionary *_Nonnull)dic sign:(NSString *_Nullable)sign commandID:(NSInteger)commandId
{
    return [[self class] parametersBody:dic tokenID:@"" sign:sign commandID:commandId];
}


/**
 组数据 带tokenID
 
 @param dic 参数
 @param tokenID tokenID
 @return NSDictionary
 */
+ (NSDictionary *_Nonnull)parametersBody:(NSDictionary *_Nonnull)dic tokenID:(NSString *_Nullable)tokenID commandID:(NSInteger)commandId
{
    return [[self class] parametersBody:dic tokenID:tokenID sign:@"" commandID:commandId];
}

//组网络数据
/**
 组数据
 
 @param dic 参数
 @param commandId commandId
 @return NSDictionary
 */
+ (NSDictionary *_Nonnull)parametersBody:(NSDictionary *_Nonnull)dic commandID:(NSInteger)commandId
{
    return [[self class] parametersBody:dic tokenID:@"" sign:@"" commandID:commandId];
}


/**
 组数据 带sign  tokenid
 
 @param dic 参数
 @param tokenID tokenID
 @param sign sign签名
 @param commandId commandId
 @return NSDictionary
 */
+ (NSDictionary *_Nullable)parametersBody:(NSDictionary *_Nullable)dic tokenID:(NSString *_Nullable)tokenID  sign:(NSString *_Nullable)sign commandID:(NSInteger)commandId
{
    NSDictionary *baseParam         = [JLApiOpera baseParam];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:baseParam];
    parameters[@"CommandID"]        = @(commandId);
    parameters[@"TokenID"]          = tokenID;
    parameters[@"Sign"]             = sign;
    parameters[@"app_key"]   = [JLAccCertManager appKey];
    if (commandId == 5001) {
        parameters[@"Body"] = dic;
    }
    else{
        parameters[@"Body"] = [self signBodyDict:dic];
    }
    return parameters;
}

+ (NSDictionary *)requestHeader{
    
    NSDictionary *dict = [JLAPI encryptedKeyDic];
    
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    header[@"Content-Type"] = @"application/json";
    header[@"SDK_ID"]       = dict[@"Encrypted_ID"];
    header[@"SDK_VERSION"]  = dict[@"Encrypted_VERSION"];
    header[@"DEVICE_NO"]    = [JLApiTools getUUIDFromKeychainItemWrapper];
    
    return header;
}

@end
