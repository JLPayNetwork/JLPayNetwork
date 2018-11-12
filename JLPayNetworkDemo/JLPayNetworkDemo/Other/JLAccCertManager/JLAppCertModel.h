//
//  JLAppCertModel.h
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/8.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLAppCertModel : NSObject

@property (nonatomic, copy) NSString *ret_code;
@property (nonatomic, copy) NSString *ret_msg;
@property (nonatomic, strong) NSString *app_key;
@property (nonatomic, strong) NSString *sdk_key;

@end

NS_ASSUME_NONNULL_END
