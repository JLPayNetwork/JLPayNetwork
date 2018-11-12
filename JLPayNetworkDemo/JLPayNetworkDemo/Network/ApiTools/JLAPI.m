//
//  JLAPI.m
//  lishua
//
//  Created by Zeng on 2017/4/5.
//  Copyright © 2017年 嘉联支付有限公司. All rights reserved.
//


#import "JLAPI.h"

static NSString *const kBaseURL = @"";

static NSString *const kAccessCertBaseURL = @"";

static NSString *const kBaseLoanURL = @"";

static NSString *const kConfigXMLURL = @"";

static NSString *const kH5URL = @"";//h5的url

static NSString *const kLoanH5URL = @"";//loan h5的url

//报文加密信息
static NSString *const LSEncrypted_ID      = @"";
static NSString *const LSEncrypted_VERSION = @"";
static NSString *const LSEncrypted_KEY     = @"";

/**
 @brief 管理所有接口URL
 */
@implementation JLAPI

+ (NSArray *)getAPIArray
{

    return @[@{@"title" : @"生产测试环境",
               @"JLAPI" : @"",
               @"JLAccessCertAPI" : @"",
               @"JLLoanAPI" : @"",
               @"ConfigUrl":@"",
               @"H5Url":@"",
               @"LoanH5Url":@""},
             
             @{@"title" : @"正式环境",
               @"JLAPI" : kBaseURL,
               @"JLAccessCertAPI" : kAccessCertBaseURL,
               @"JLLoanAPI" : kBaseLoanURL,
               @"ConfigUrl":kConfigXMLURL,
               @"H5Url":kH5URL,
               @"LoanH5Url":kLoanH5URL},
             
             @{@"title" : @"21环境",
               @"JLAPI" : @"",
               @"JLAccessCertAPI" : @"",
               @"JLLoanAPI" : @"",
               @"ConfigUrl":@"",
               @"H5Url":@"",
               @"LoanH5Url":@""},
             
             @{@"title" : @"开发环境",
               @"JLAPI" : @"",
               @"JLAccessCertAPI" : @"",
               @"JLLoanAPI" : @"",
               @"ConfigUrl":@"",
               @"H5Url":@"",
               @"LoanH5Url":@""}];
}

/**
 报文加密信息数组

 @return dic
 */
+ (NSArray *)getEncryptedArray
{
    return @[@{@"title" : @"生产测试环境",
               @"Encrypted_ID" : @"7688220672320408",
               @"Encrypted_KEY" : @"7222375456522508",
               @"Encrypted_VERSION":@"1.0"},
             
             @{@"title" : @"正式环境",
               @"Encrypted_ID" : LSEncrypted_ID,
               @"Encrypted_KEY" : LSEncrypted_KEY,
               @"Encrypted_VERSION":LSEncrypted_VERSION},
             
             @{@"title" : @"21环境",
               @"Encrypted_ID" : @"",
               @"Encrypted_KEY" : @"",
               @"Encrypted_VERSION":@"1.0"},
             
             @{@"title" : @"开发环境",
               @"Encrypted_ID" : @"",
               @"Encrypted_KEY" : @"",
               @"Encrypted_VERSION":@"1.0"}];
}

+ (NSString *)getBaseUrlString
{
#if isDevelopment
    NSInteger select = [JLSetting share].domainSelectedIndex;
    NSArray *arr = [[JLAPI getAPIArray] copy];
    NSString *baseUrl = arr[select][@"JLAPI"];
    return  baseUrl;

#else
    NSString *baseUrl = kBaseURL;
    NSLog(@"--------当前环境：%@----------", baseUrl);
    return baseUrl;
#endif
}

/**
 app加密以及签名key下载
 
 @return url string
 */
+ (NSString *)getAccessCertBaseUrlString
{
#if isDevelopment
    NSInteger select = [JLSetting share].domainSelectedIndex;
    NSArray *arr = [[JLAPI getAPIArray] copy];
    NSString *baseUrl = arr[select][@"JLAccessCertAPI"];
    return  baseUrl;
    
#else
    NSString *baseUrl = kAccessCertBaseURL;
    NSLog(@"--------当前环境：%@----------", baseUrl);
    return baseUrl;
#endif
}

/**
 信用卡代还入口
 
 @return getBaseLoanURLString
 */
+ (NSString *)getBaseLoanURLString
{
#if isDevelopment
    NSInteger select = [JLSetting share].domainSelectedIndex;
    NSArray *arr = [[JLAPI getAPIArray] copy];
    
    return  arr[select][@"JLLoanAPI"];

#else

    return kBaseLoanURL;
#endif
}

/**
 获取配置文件的URL
 
 @return 配置文件url string
 */
+ (NSString *)getConfigUrlString
{
#if isDevelopment
    NSInteger select = [JLSetting share].domainSelectedIndex;
    NSArray *arr = [[JLAPI getAPIArray] copy];
    
    return  arr[select][@"ConfigUrl"];

#else
    return kConfigXMLURL;
#endif

}

/**
 获取h5的url

 @return h5的url
 */
+ (NSString *)getH5UrlString
{
    
#if isDevelopment
    NSInteger select = [JLSetting share].domainSelectedIndex;
    NSArray *arr = [[JLAPI getAPIArray] copy];
    
    return  arr[select][@"H5Url"];
    

#else
    return kH5URL;
#endif

}

/**
 获取 信用卡待还 h5的url
 
 @return h5的url
 */
+ (NSString *)getLoanH5UrlString
{
    
#if isDevelopment
    NSInteger select = [JLSetting share].domainSelectedIndex;
    NSArray *arr = [[JLAPI getAPIArray] copy];
    
    return  arr[select][@"LoanH5Url"];
    
    
#else
    return kLoanH5URL;
#endif
    
}

/**
 报文加密秘钥 版本号 sdk_id
 
 @return NSDictionary
 */
+ (NSDictionary *)encryptedKeyDic
{
    NSDictionary *keyDic = [NSDictionary dictionary];
#if isDevelopment
    NSInteger select = [JLSetting share].domainSelectedIndex;
    NSArray *arr = [[JLAPI getEncryptedArray] copy];
    keyDic = arr[select];
    return  keyDic;
#else
    keyDic = @{@"title" : @"正式环境",
               @"Encrypted_ID" : LSEncrypted_ID,
               @"Encrypted_KEY" : LSEncrypted_KEY,
               @"Encrypted_VERSION":LSEncrypted_VERSION};
    return keyDic;
#endif
}


@end
