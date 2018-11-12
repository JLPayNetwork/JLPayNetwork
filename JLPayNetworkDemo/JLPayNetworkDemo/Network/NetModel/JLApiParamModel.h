//
//  JLApiParamModel.h
//  lishuaPro
//
//  Created by Jack Luo on 2018/10/16.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

/****
 请求参数model
 ****/


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class NSURLSessionTask;
@class JsonResult;

@interface JLApiParamModel : NSObject

//请求链接
@property (nonatomic, copy) NSString *urlString;
//超时时间
@property (nonatomic, assign) NSTimeInterval timeouts;
//请求参数
@property (nonatomic, strong) id param;
//成功回调
@property (nonatomic, copy) void (^successBlock)(NSURLSessionDataTask * _Nullable task, JsonResult * _Nullable jsonResult);
//失败会掉
@property (nonatomic, copy) void (^failurlBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error);


@end

NS_ASSUME_NONNULL_END
