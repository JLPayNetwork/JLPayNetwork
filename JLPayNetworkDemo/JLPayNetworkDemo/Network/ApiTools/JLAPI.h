//
//  JLAPI.h
//  lishua
//
//  Created by Zeng on 2017/4/5.
//  Copyright © 2017年 嘉联支付有限公司. All rights reserved.
//
///注：api管理类
//管理所有api

#import <Foundation/Foundation.h>

@interface JLAPI : NSObject

/**
 获取api数组信息

 @return 字典（title，JLAPI，JLLoanAPI）
 */
+ (NSArray *)getAPIArray;
/**
 获取base url

 @return  base url string
 */
+ (NSString *)getBaseUrlString;

/**
 app加密以及签名key下载

 @return url string
 */
+ (NSString *)getAccessCertBaseUrlString;


/**
 信用卡代还入口

 @return getBaseLoanURLString
 */
+ (NSString *)getBaseLoanURLString;

/**
 获取配置文件的URL

 @return 配置文件url string
 */
+ (NSString *)getConfigUrlString;

/**
 获取h5的url
 
 @return h5的url
 */
+ (NSString *)getH5UrlString;

/**
 获取 信用卡待还 h5的url
 
 @return h5的url
 */
+ (NSString *)getLoanH5UrlString;

/**
 报文加密秘钥 版本号 sdk_id

 @return NSDictionary
 */
+ (NSDictionary *)encryptedKeyDic;

@end
