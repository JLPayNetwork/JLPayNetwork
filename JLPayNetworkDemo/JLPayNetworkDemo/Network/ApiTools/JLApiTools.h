//
//  JLApiTools.h
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/2.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLApiTools : NSObject

/**
 获取app版本信息

 @return 版本信息
 */
+ (NSString *)getAppVersion;

/**
 获取app buildVersion

 @return buildVersion
 */
+ (NSString *)getAppBuildVersion;

/**
 获取设备版本信息

 @return 设备系统版本
 */
+ (NSString *)getDeviceSysytemVersion;

/**
 获取设备的uuid

 @return uuid
 */
+ (NSString *)getUUIDFromKeychainItemWrapper;

/**
 获取字母和数字的随机字符串

 @param num 长度
 @return 随机字符串
 */
+ (NSString *)getRandomStringWithNum:(NSInteger)num;

/**
 获取当前日期 格式:yyyy-MM-dd HH:mm:ss

 @return 日期
 */
+ (NSString *)getCurrentTime;

/**
 处理JsonString 去除转译字符
 
 @param jsonString 被处理字符串
 @return 处理结果
 */
+ (NSData *)operationJsonString:(NSString *)jsonString;


/**
 json data (NSDictionary or NSArray) 转 JSON String
 
 @param data 被转换数据
 @return 转换结果
 */
+ (NSString *)jsonStringWithJsonData:(id)data;

//是否为整数
+ (BOOL)isPureInt:(NSString*)string;

@end

NS_ASSUME_NONNULL_END
