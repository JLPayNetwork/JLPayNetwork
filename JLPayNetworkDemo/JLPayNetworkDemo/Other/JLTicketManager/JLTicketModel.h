//
//  JLTicketModel.h
//  lishuaPro
//
//  Created by LZ on 2018/10/8.
//  Copyright © 2018年 嘉联支付有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLTicketModel : NSObject

@property (nonatomic, strong) NSString *ticket;
@property (nonatomic, strong) NSDate   *saveDate;

@end

NS_ASSUME_NONNULL_END
