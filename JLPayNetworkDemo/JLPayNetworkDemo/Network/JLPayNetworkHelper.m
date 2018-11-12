//
//  JLPayNetworkHelper.m
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/1.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import "JLPayNetworkHelper.h"
#import <JLPayNetwork/JLPayNetworkClient.h>
#import <JLPayNetwork/JLPayNetworkConfig.h>

#import "JLApiOpera+Accert.h"
#import <YYKit/YYKit.h>

#import "JLAppCertModel.h"

#import "JLApiError.h"
#import "JLTicketManager.h"
#import "JLApiParamModel.h"
#import "JLApiTools.h"

@interface JLPayNetworkHelper ()
{
    //网络重试
    NSInteger retryCount;
}

//刷新ticket时，等待请求的数组
@property (nonatomic, strong) NSMutableArray *waitRequestArray;
//ticket是否正在请求
@property (nonatomic, assign) BOOL isTicketLoading;
//ticket重新请求次数
@property (nonatomic, assign) NSInteger ticktRetartCount;

@end

@implementation JLPayNetworkHelper

+ (instancetype)share{
    
    static JLPayNetworkHelper *helper = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        helper = [JLPayNetworkHelper new];
    });
    
    return helper;
}

/**
 POST
 
 @param params 请求参数
 @param success 请求成功的回调
 @param failure 请求失败的回调
 */
+ (void)postWithParams:(NSDictionary *)params
               success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, JsonResult * _Nullable jsonResult))success
               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure
{
    if ([JLTicketManager isExpireDateOfTicket]) {
        
        JLApiParamModel *paramModel = [[JLPayNetworkHelper share] modelWithURLString:[JLPayNetworkConfig sharedConfig].baseUrl
                                                      timeouts:[JLPayNetworkConfig sharedConfig].timeOut
                                                    parameters:params
                                                       success:success
                                                       failure:failure];
        
        [[JLPayNetworkHelper share].waitRequestArray addObject:paramModel];
        
        if ([JLPayNetworkHelper share].isTicketLoading == NO) {
            [JLPayNetworkHelper share].isTicketLoading = YES;
            
            [JLTicketManager requestTicketWithBlock:^(BOOL success,id obj) {
                
                [JLPayNetworkHelper share].isTicketLoading = NO;
                //请求成功，重新操作
                [[JLPayNetworkHelper share] restartRequestWithIsSuccess:success obj:obj];
            }];
        }
        
    }else {
        [JLPayNetworkHelper share].ticktRetartCount = 0;
        [[JLPayNetworkHelper share] startWithURLString:[JLPayNetworkConfig sharedConfig].baseUrl timeouts:[JLPayNetworkConfig sharedConfig].timeOut parameters:params success:success failure:failure];
    }
}

/**
 请求sdk_key和app_key
 
 @param params 请求参数
 @param success 请求成功回调
 @param failure 请求失败回调
 */
+ (void)accCertPostWithParams:(NSDictionary *)params
                      success:(void (^) (NSURLSessionDataTask *_Nullable dataTask, JLAppCertModel *certModel))success
                      failure:(void(^)(NSURLSessionDataTask *_Nullable dataTask, NSError *error))failure
{
    NSString *baseUrl = @"";
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    
    [JLPayNetworkClient requestWithMethod:JLPayRequestMethodPOST url:baseUrl params:jsonData cachePolicy:JLPayCachePolicyNetworkOnly success:^(NSURLSessionDataTask * _Nullable dataTask, id  _Nonnull responseObject) {
//        1.数据解密
        NSData *data = [JLApiOpera accertRSADataDecryWith:dataTask.response reponseData:responseObject];
//        2.数据解析
        JLAppCertModel *result = [JLAppCertModel modelWithJSON:data];
        if ([result.ret_code isEqualToString:@"00"]) {
//            3.回调成功
            success ?success(dataTask, result):nil;
        }else {
            JLApiError *error = [JLApiError errorWithCode:[result.ret_code intValue] errorMessage:result.ret_msg];
            failure? failure(dataTask, error): nil;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
        if (failure) {
//            1.错误处理
            [JLPayNetworkHelper accCertErrorDeal:dataTask.response];
//            2.错误回调
            failure(dataTask, error);
        }
    }];
}

#pragma mark - errorDeal

+ (void)accCertErrorDeal:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = nil;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        httpResponse = (NSHTTPURLResponse *)response;
    }
    if (httpResponse && httpResponse.statusCode) {
        //重新获取app_key和sdk_key
    }
}

- (NSMutableArray *)waitRequestArray{
    
    if (!_waitRequestArray) {
        _waitRequestArray = [NSMutableArray new];
    }
    return _waitRequestArray;
}

- (JLApiParamModel *)modelWithURLString:(NSString *)URLString
                               timeouts:(NSTimeInterval)timeouts
                             parameters:(id)parameters
                                success:(void (^)(NSURLSessionDataTask * _Nullable, JsonResult * _Nullable))success
                                failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nullable))failure{
    
    JLApiParamModel *model = [JLApiParamModel new];
    
    model.urlString = URLString;
    model.timeouts  = timeouts;
    model.param     = parameters;
    model.successBlock = success;
    model.failurlBlock = failure;
    
    return model;
}

- (void)restartRequestWithIsSuccess:(BOOL)success obj:(id)obj{
    
    
    NSError *error = nil;
    
    for (JLApiParamModel *model in self.waitRequestArray) {
        
        if (success) {
            //ticket 请求成功重新请求
            [[JLPayNetworkHelper share] startWithURLString:model.urlString timeouts:model.timeouts parameters:[JLApiOpera addTicketValueInParameters:model.param] success:model.successBlock failure:model.failurlBlock];
        }
        else{
            
            if (model.failurlBlock) {
                model.failurlBlock(nil, error);
            }
        }
    }
    
}

//开始请求
- (void)startWithURLString:(NSString *)URLString
                  timeouts:(NSTimeInterval)timeouts
                parameters:(id)parameters
                   success:(void (^)(NSURLSessionDataTask * _Nullable, JsonResult * _Nullable))success
                   failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nullable))failure
{
    
    NSData *encryData = [JLApiOpera encryptParameters:parameters];
    
    [JLPayNetworkClient requestWithMethod:JLPayRequestMethodPOST url:URLString params:encryData cachePolicy:JLPayCachePolicyNetworkOnly success:^(NSURLSessionDataTask * _Nullable dataTask, id  _Nonnull responseObject) {
        
        //请求成功后，网络中断重试的请求设置为初始状态
        self->retryCount = 0;
        //数据请求成功，解密数据
        NSData *data = [JLApiOpera apiDataDecryWith:dataTask.response reponseData:responseObject];
        JsonResult *result = [JsonResult modelWithJSON:data];
        if (result.CommandID == nil && result.Body == nil && data != nil) {
            
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (jsonDict) {
                NSString *ret_msg  = jsonDict[@"ret_msg"];
                
                result = [[JsonResult alloc] init];
                result.RetCode  = @"-9999";
                result.ErrorMsg = ret_msg;
            }
        }
        
        NSString *reponseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",reponseStr);
        
        NSString *retCode = result.RetCode;
        //是否是整数
        BOOL isInt = [JLApiTools isPureInt:retCode];
        
        if (isInt && [retCode intValue] == 10) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //登录过期取错误信息
            });
        }
        else if (isInt && [retCode intValue] == 0){
            if (success) {success(dataTask, result);}
        }
        else if([retCode isEqualToString:@"TE"]){
            //ticket过期
            //删除保存的ticket
            [JLTicketManager clearTicketData];
            
            if (self.ticktRetartCount <= 5) {
                
                self.ticktRetartCount++;
                //重新请求
                [[JLPayNetworkHelper share] startWithURLString:URLString timeouts:timeouts parameters:parameters success:success failure:failure];
                
            }
            else{
                
                JLApiError *error = [JLApiError errorWithCode:-19998 errorMessage:result.ErrorMsg];
                if (failure) {
                    failure(dataTask, error);
                }
            }
        }
        else{
            //请求数据成功，状态异常
            NSInteger code = 0;
            if (isInt) {
                code = [retCode integerValue];
            }
            else{
                code = -19999;
            }
            JLApiError *error = [JLApiError errorWithCode:code errorMessage:result.ErrorMsg];
            if (failure) {
                failure(dataTask, error);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
        
        if (error) {
            
            NSInteger code = error.code;
            if (code == NSURLErrorNetworkConnectionLost && self->retryCount < 3) {
                //网络连接已中断
                NSLog(@"网络中断，重新请求");
                self->retryCount ++;
                [[JLPayNetworkHelper share] startWithURLString:URLString timeouts:timeouts parameters:parameters success:success failure:failure];
            }
            else{
                
                if (failure) {
                    failure(dataTask, error);
                }
            }
        }
    }];
}

@end
