//
//  JLAccCertManager.m
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/8.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import "JLAccCertManager.h"
#import "JLAppCertModel.h"
#import "JLPayNetworkHelper.h"
#import "JLApiOpera+Accert.h"
#import "JLApiOpera+Encrypt.h"
#import "JLApiTools.h"

//数据本地保存的key
static NSString *const JLCertSaveKey = @"JLCSAVEKEY";
//加密保存的key
static NSString *const JLCertAESKey  = @"2018110916304865";

//AppId
static NSString *const JLAppId = @"LS201809181824";

@interface JLAccCertManager ()

@property (nonatomic, strong) JLAppCertModel *certModel;
@end

@implementation JLAccCertManager

+ (instancetype)share{
    
    static JLAccCertManager *certManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        certManager = [JLAccCertManager new];
    });
    
    return certManager;
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
        [JLAccCertManager clearCertData];
    }
}

//清空证书数据
+ (void)clearCertData{
    
    [[NSUserDefaults standardUserDefaults]  removeObjectForKey:JLCertSaveKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [JLAccCertManager share].certModel = nil;
    
}

/**
 请求Cert 包含app_key sdk_key
 
 @param block 回调
 */
+ (void)getAccCert:(void(^)(BOOL success, id data))block
{
    NSDictionary *dic = [JLApiOpera accertParamaters];
    
    [JLPayNetworkHelper accCertPostWithParams:dic success:^(NSURLSessionDataTask * _Nullable dataTask, JLAppCertModel * _Nonnull certModel) {
//        1.保存数据
        [JLAccCertManager share].certModel = certModel;
        [[JLAccCertManager share] saveCertModel:certModel];
        
        if (block) {
            block(YES, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
        
        if (block) {
            block(NO, error);
        }
    }];
}


#pragma mark -
+ (BOOL)isHaveAppCert{
    
    return ([JLAccCertManager share].certModel.app_key.length > 0 &&
            [JLAccCertManager share].certModel.sdk_key.length > 0);
}

+ (NSString *)appKey{
    return [JLAccCertManager share].certModel.app_key;
}

+ (NSString *)sdkKey{
    return [JLAccCertManager share].certModel.sdk_key;
}


#pragma mark -
- (void)saveCertModel:(JLAppCertModel *)certModel{
    
    if (certModel) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"sdk_key"] = certModel.sdk_key;
        dict[@"app_key"] = certModel.app_key;
        NSString *jsonString = [JLApiTools jsonStringWithJsonData:dict];
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        if (data) {
            NSData *encryptData = [JLApiOpera AESDecryptData:data key:JLCertAESKey];
            if (encryptData) {
                [[NSUserDefaults standardUserDefaults] setObject:encryptData forKey:JLCertSaveKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else {
                
                NSLog(@"数据加密失败");
            }
        }
    }
}

- (JLAppCertModel *)readCertModelFromLocal{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:JLCertSaveKey];
    
    JLAppCertModel *appCertModel = nil;
    if (data) {
        
        NSData *decryptData = [JLApiOpera AESDecryptData:data key:JLCertAESKey];
        if (decryptData) {
            
            NSString *jsonStr = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
            NSData *operData = [JLApiTools operationJsonString:jsonStr];
            
            if (operData) {
                
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:nil];
                
                appCertModel = [JLAppCertModel new];
                appCertModel.sdk_key = dict[@"sdk_key"];
                appCertModel.app_key = dict[@"app_key"];
            }
        }
        else{
            NSLog(@"cert解密出错");
        }
    }
    
    return appCertModel;
}

#pragma mark - Getter
- (JLAppCertModel *)certModel{
    if (!_certModel) {
        _certModel = [self readCertModelFromLocal];
        if (!_certModel) {
            _certModel = [JLAppCertModel new];
        }
    }
    
    return _certModel;
}

@end
