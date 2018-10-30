//
//  JLPayNetworkConfig.h
//  JLPayNetwork
//
//  Created by Canbing Zhen on 2018/10/26.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AFSecurityPolicy;

@interface JLPayNetworkConfig : NSObject

+ (JLPayNetworkConfig *)sharedConfig;

@property (nonatomic, strong) NSString                  *baseUrl;
@property (nonatomic, strong) AFSecurityPolicy          *securityPolicy;
@property (nonatomic        ) BOOL                      debugLogEnabled;
@property (nonatomic, assign) int                       timeOut;//接口超时时间

@end

NS_ASSUME_NONNULL_END
