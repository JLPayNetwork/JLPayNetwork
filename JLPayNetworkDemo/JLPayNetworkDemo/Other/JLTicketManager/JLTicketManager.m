//
//  JLTicketManager.m
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/8.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import "JLTicketManager.h"
#import "NSDate+JLDateFomtter.h"
#import "JLTicketModel.h"
#import "JLAccCertManager.h"
#import "JLApiOpera.h"
#import "JLPayNetworkHelper.h"
#import "JLApiError.h"

static NSString *const JLTicketModelKey = @"JLTicketModelKey";

//两个小时过期，设置过期时间为110分钟
const int ticketExpireDate = 110*60;

@interface JLTicketManager ()

@property (nonatomic, strong) JLTicketModel *ticketModel;
//请求次数
@property (nonatomic, assign) NSInteger requestCount;
@end

@implementation JLTicketManager

+ (instancetype)share{
    
    static JLTicketManager *ticketManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        ticketManager = [JLTicketManager new];
    });
    
    return ticketManager;
}

- (id)init{
    
    self = [super init];
    
    if (self) {
        [self addObserver];
    }
    return self;
}

- (void)addObserver{
    
#if isDevelopment
    
    [[JLSetting share] addObserver:self
                        forKeyPath:@"domainSelectedIndex"
                           options:NSKeyValueObservingOptionNew
                           context:nil];
    
#endif
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"domainSelectedIndex"]) {
        [JLTicketManager clearTicketData];
    }
}

//清空ticket数据
+ (void)clearTicketData{
    
    [[NSUserDefaults standardUserDefaults]  removeObjectForKey:JLTicketModelKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [JLTicketManager share].ticketModel = nil;
}


#pragma mark -
- (JLTicketModel *)ticketModel{
    if (!_ticketModel) {
        
        _ticketModel = [JLTicketManager readTicketFromLocal];
        if (!_ticketModel) {
            _ticketModel = [JLTicketModel new];
        }
    }
    
    return _ticketModel;
}

#pragma mark - 公有方法
#pragma mark - 数据请求
+ (void)requestTicketWithBlock:(void(^)(BOOL success,id obj))block{
    
    [JLTicketManager share].requestCount = 0;
    [self beignRequestWithBlock:block];
}

+ (void)beignRequestWithBlock:(void(^)(BOOL success,id obj))resultblock{
    
    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
    bodyDict[@"app_key"]    = [JLAccCertManager appKey];
    bodyDict[@"timestamp"]  = [[NSDate date] yyyyMMddHHmmss];
    
    NSDictionary *paramters = [JLApiOpera parametersBody:bodyDict commandID:5001];
    
    [JLPayNetworkHelper postWithParams:paramters success:^(NSURLSessionDataTask * _Nullable task, JsonResult * _Nullable jsonResult) {
        NSString *ticket = jsonResult.Body[@"TICKET"];
        if (ticket.length > 0) {
            NSDate *saveDate = [NSDate date];
            
            JLTicketModel *ticketModel = [JLTicketModel new];
            ticketModel.ticket   = ticket;
            ticketModel.saveDate = saveDate;
            
            [JLTicketManager share].ticketModel = ticketModel;
            
            if (resultblock) {
                resultblock(YES,nil);
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self saveTiketWithModel:ticketModel];
            });
        }else{
            
            NSLog(@"ticket 长度为0");
            JLApiError *error = [JLApiError errorWithCode:-19999 errorMessage:@"Ticket为空"];
            
            if (resultblock) {
                resultblock(NO,error);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        
        NSLog(@"%@",error.localizedDescription);
        
        if([JLTicketManager share].requestCount < 2){
            
            [JLTicketManager share].requestCount++;
            [self beignRequestWithBlock:resultblock];
        }
        else{
            
            if (resultblock) {
                resultblock(NO,error);
            }
        }
        
    }];
}

+ (BOOL)isExpireDateOfTicket{
    
    NSString *ticket = [JLTicketManager share].ticketModel.ticket;
    NSDate *saveDate = [JLTicketManager share].ticketModel.saveDate;
    
    if (ticket == nil || saveDate == nil) {
        return YES;
    }
    else{
        
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:saveDate];
        if (interval >= 0 && interval < ticketExpireDate) {
            return NO;
        }
    }
    
    return YES;
}

+ (NSString *)ticket{
    return [JLTicketManager share].ticketModel.ticket;
}

#pragma mark - 私有方法
#pragma mark - 数据处理
+ (void)saveTiketWithModel:(JLTicketModel *)model{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"ticket"]    = model.ticket;
    dict[@"saveDate"]  = model.saveDate;
    
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    [defaults setObject:dict forKey:JLTicketModelKey];
    BOOL success = [defaults synchronize];
    if (success) {
        NSLog(@"保存ticket成功");
    }
}

+ (JLTicketModel *)readTicketFromLocal{
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:JLTicketModelKey];
    
    if ([dict allKeys].count > 0) {
        
        NSLog(@"读取ticket成功");
        
        JLTicketModel *ticketModel = [JLTicketModel new];
        ticketModel.ticket    = dict[@"ticket"];
        ticketModel.saveDate  = dict[@"saveDate"];
        
        return ticketModel;
    }
    
    return nil;
}

@end
