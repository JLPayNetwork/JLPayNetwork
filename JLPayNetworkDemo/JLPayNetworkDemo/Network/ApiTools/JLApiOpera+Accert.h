//
//  JLApiOpera+Accert.h
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/6.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import "JLApiOpera.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLApiOpera (Accert)

+ (NSDictionary *)accertParamaters;

/**
 accert接口返回数据解密处理

 @param response response
 @param data data
 @return 解析后结果
 */
+ (NSData *)accertRSADataDecryWith:(NSURLResponse *)response reponseData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
