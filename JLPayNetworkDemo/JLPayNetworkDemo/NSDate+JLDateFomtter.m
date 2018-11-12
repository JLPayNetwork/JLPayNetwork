//
//  NSDate+JLDateFomtter.m
//  JLSDK
//
//  Created by LZ on 2018/8/1.
//  Copyright © 2018年 JLPAY. All rights reserved.
//

#import "NSDate+JLDateFomtter.h"

@implementation NSDate (JLDateFomtter)

+ (NSDateFormatter *)jlFormatter{
    
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    });
    return formatter;
}


- (NSString *)yyyyMMddHHmmss{
    return [[NSDate jlFormatter] stringFromDate:self];
}

@end
