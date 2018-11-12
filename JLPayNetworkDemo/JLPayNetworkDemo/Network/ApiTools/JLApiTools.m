//
//  JLApiTools.m
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/2.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import "JLApiTools.h"
#import <UIKit/UIKit.h>
#import <KeychainItemWrapper/KeychainItemWrapper.h>

//设备UUID
#define DEVICE_UUID_KEY   @"deviceUUID"
static NSString *deviceUuid = nil;

@implementation JLApiTools
/**
 获取app版本信息
 
 @return 版本信息
 */
+ (NSString *)getAppVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

/**
 获取app buildVersion
 
 @return buildVersion
 */
+ (NSString *)getAppBuildVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}
/**
 获取设备版本信息
 
 @return 设备系统版本
 */
+ (NSString *)getDeviceSysytemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

/**
 获取设备的uuid
 
 @return uuid
 */
+ (NSString *)getUUIDFromKeychainItemWrapper
{
    NSString *uniqueIdentifier = nil;
    
    if (deviceUuid.length < 1) {
        
        //标识符（Identifier）在后面我们要从keychain中取数据的时候会用到。如果你想要在应用之间共享信息，那么你需要指定访问组（access group）。有同样的访问组 的应用能够访问同样的keychain信息。
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:DEVICE_UUID_KEY accessGroup:nil];
        uniqueIdentifier = [wrapper objectForKey:(__bridge id)kSecAttrAccount];
        
        // initially all these are empty
        if (uniqueIdentifier.length < 1) {
            
            CFUUIDRef uuid = CFUUIDCreate(NULL);
            CFStringRef string = CFUUIDCreateString(NULL, uuid);
            CFRelease(uuid);
            NSString *tmpUUID = (__bridge_transfer NSString *)string;
            
            [wrapper setObject:tmpUUID forKey:(__bridge id)kSecAttrAccount];
            uniqueIdentifier = tmpUUID;
        }
        
        deviceUuid = uniqueIdentifier;
    }
    else{
        uniqueIdentifier = deviceUuid;
    }
    
    
    return uniqueIdentifier;
}

/**
 获取字母和数字的随机字符串
 
 @param num 长度
 @return 随机字符串
 */
+ (NSString *)getRandomStringWithNum:(NSInteger)num
{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < num; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}

/**
 获取当前日期 格式:yyyy-MM-dd HH:mm:ss
 
 @return 日期
 */
+ (NSString *)getCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    if (currentTimeString.length < 1) {
        return @"";
    }
    return currentTimeString;
}

/**
 处理JsonString 去除转译字符
 
 @param jsonString 被处理字符串
 @return 处理结果
 */
+ (NSData *)operationJsonString:(NSString *)jsonString
{
    if (jsonString.length < 1) {
        if (jsonString) {
            return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        }
        return nil;;
    }
    
    NSString * str2 = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    str2 = [str2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    str2 = [str2 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str2 = [str2 stringByReplacingOccurrencesOfString:@"\0" withString:@""];
    str2 = [str2 stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    
    NSData *jsonData = [str2 dataUsingEncoding:NSUTF8StringEncoding];
    
    return jsonData;
}


/**
 json data (NSDictionary or NSArray) 转 JSON String
 
 @param data 被转换数据
 @return 转换结果
 */
+ (NSString *)jsonStringWithJsonData:(id)data
{
    NSError *error = nil;
    id jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                  options:NSJSONWritingPrettyPrinted
                                                    error:&error];
    
    NSString *jsonString = nil;
    if (! jsonData) {
        NSLog(@"Json String error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}

//是否为整数
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

@end
