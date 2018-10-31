//
//  JLPayNetworkConfig.m
//  JLPayNetwork
//
//  Created by Canbing Zhen on 2018/10/26.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import "JLPayNetworkConfig.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

#define kTimeout  20.f

@implementation JLPayNetworkConfig

+ (JLPayNetworkConfig *)sharedConfig {
    static id shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.baseUrl         = @"";
        self.securityPolicy  = [AFSecurityPolicy defaultPolicy];
        self.debugLogEnabled = NO;
        self.timeOut = self.timeOut > 0? self.timeOut: kTimeout;
    }
    return self;
}

#pragma mark - other
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p>{ baseURL: %@ } ",NSStringFromClass([self class]), self, self.baseUrl];
}

@end
