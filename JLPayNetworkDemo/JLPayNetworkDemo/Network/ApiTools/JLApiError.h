//
//  JLApiError.h
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/7.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

//错误类型
typedef NS_ENUM(NSUInteger, JLApiErrorType)
{
    JLLoginOutTimeError = 10,   //登录过期
    JLForceUpdateVersionError = 11,   //强制更新
};

NS_ASSUME_NONNULL_BEGIN

@interface JLApiError : NSError

/**
 返回指定错误类型对应的错误信息

 @param errorType 错误类型
 @return 错误类型对应的错误信息
 */
+ (NSString *)errorMessageForErrorType:(JLApiErrorType)errorType;

/**
 根据给定错误类型和信息创建JLApiError实例

 @param errorType 错误类型
 @param errorMessage 错误描述信息
 @return JLApiError实例
 */
+ (id)errorWithCode:(NSUInteger)errorType errorMessage:(NSString *)errorMessage;

/**
 根据给定错误类型和信息创建JLApiError实例

 @param errorType 错误类型
 @param errorMessage 错误描述信息
 @param button_msg button_msg
 @return JLApiError实例
 */
- (id)initWithCode:(NSUInteger)errorType errorMessage:(NSString *)errorMessage  buttonMsg:(NSString *)button_msg;

/**
 根据 NSError 的实例生成 JLApiError实例

 @param error NSError 的实例
 @return JLApiError实例
 */
+ (id)errorWithError:(NSError *)error;

/**
 根据 NSError 的实例生成 JLApiError实例

 @param error NSError 的实例
 @return JLApiError实例
 */
- (id)initWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
