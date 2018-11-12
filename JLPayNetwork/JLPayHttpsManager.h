//
//  JLHttpsManager.h
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/1.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AFHTTPSessionManager;

@interface JLPayHttpsManager : NSObject

/**
 双向认证配置

 @param manager AFHTTPSessionManager 对象
 @param p12Name p12 文件名
 @param cerName cer 文件名
 @param password p12 证书密码
 */
+ (void)httpsAuth:(AFHTTPSessionManager *)manager p12:(NSString *)p12Name cer:(NSString *)cerName p12Password:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
