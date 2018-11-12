//
//  JLAES128Helper.h
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/2.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLAES128Helper : NSObject

+(NSData *)AES128Encrypt:(NSData *)plainData key:(NSString *)key;

+(NSData *)AES128Decrypt:(NSData *)encryptData key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
