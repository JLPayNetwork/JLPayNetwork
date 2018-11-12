//
//  JLTicketManager.h
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/8.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLTicketManager : NSObject

/**
 ticket 请求
 */
+ (void)requestTicketWithBlock:(void(^)(BOOL success,id obj))block;


/**
 ticket 是否过期;YES 已过期,NO 未过期
 
 @return <#return value description#>
 */
+ (BOOL)isExpireDateOfTicket;


/**
 获取ticket
 
 @return <#return value description#>
 */
+ (NSString *)ticket;


/**
 清空ticket
 */
+ (void)clearTicketData;

@end

NS_ASSUME_NONNULL_END
