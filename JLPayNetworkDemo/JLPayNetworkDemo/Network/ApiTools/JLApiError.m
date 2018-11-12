//
//  JLApiError.m
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/7.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import "JLApiError.h"

NSString *const kJLErrorDomain = @"cn.JLApiError";

@implementation JLApiError

/**
 返回指定错误类型对应的错误信息
 
 @param errorType 错误类型
 @return 错误类型对应的错误信息
 */
+ (NSString *)errorMessageForErrorType:(JLApiErrorType)errorType
{
    switch (errorType)
    {
        case JLLoginOutTimeError:
            return [NSString stringWithFormat:@"%@ - 错误代码:%d", @"登录过期",(int)errorType];
            break;
        default:
            return [NSString stringWithFormat:@"%@ - 错误代码:%d", @"数据异常",(int)errorType];
            break;
    }
}

/**
 根据给定错误类型和信息创建JLApiError实例
 
 @param errorType 错误类型
 @param errorMessage 错误描述信息
 @return JLApiError实例
 */
+ (id)errorWithCode:(NSUInteger)errorType errorMessage:(NSString *)errorMessage
{
    NSString *errorMessage_ = errorMessage != nil ? errorMessage : [JLApiError errorMessageForErrorType:errorType];
    NSString *button_msg = @"no button msg";
    
    return [[self alloc] initWithCode:errorType errorMessage:errorMessage_  buttonMsg:button_msg];
}

/**
 根据给定错误类型和信息创建JLApiError实例
 
 @param errorType 错误类型
 @param errorMessage 错误描述信息
 @param button_msg button_msg
 @return JLApiError实例
 */
- (id)initWithCode:(NSUInteger)errorType errorMessage:(NSString *)errorMessage  buttonMsg:(NSString *)button_msg
{
    return [self initWithDomain:kJLErrorDomain
                           code:errorType
                       userInfo:(errorMessage != nil
                                 ? [NSDictionary dictionaryWithObjectsAndKeys:
                                    [errorMessage description], NSLocalizedDescriptionKey,[button_msg description], NSLocalizedRecoverySuggestionErrorKey, nil]
                                 : nil)];
}

/**
 根据 NSError 的实例生成 JLApiError实例
 
 @param error NSError 的实例
 @return JLApiError实例
 */
+ (id)errorWithError:(NSError *)error
{
    return [[self alloc] initWithCode:error.code errorMessage:[error localizedDescription] buttonMsg:[error localizedRecoverySuggestion]];
}

/**
 根据 NSError 的实例生成 JLApiError实例
 
 @param error NSError 的实例
 @return JLApiError实例
 */
- (id)initWithError:(NSError *)error
{
    return [self initWithCode:error.code errorMessage:[error localizedDescription] buttonMsg:[error localizedRecoverySuggestion]];
}

@end
