//
//  JLHttpsManager.m
//  JLPayNetworkDemo
//
//  Created by Canbing Zhen on 2018/11/1.
//  Copyright © 2018 嘉联支付有限公司. All rights reserved.
//

#import "JLPayHttpsManager.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

@implementation JLPayHttpsManager

/**
 双向认证配置
 
 @param manager AFHTTPSessionManager 对象
 @param p12Name p12 文件名
 @param cerName cer 文件名
 @param password p12 证书密码
 */
+ (void)httpsAuth:(AFHTTPSessionManager *)manager p12:(NSString *)p12Name cer:(NSString *)cerName p12Password:(NSString *)password
{
    __weak typeof(self)weakSelf = self;
    
    __block AFHTTPSessionManager *weakManager = manager;
    
    manager.securityPolicy = [JLPayHttpsManager customSecurityPolicy:cerName];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    [manager setSessionDidBecomeInvalidBlock:^(NSURLSession * _Nonnull session, NSError * _Nonnull error) {
        NSLog(@"setSessionDidBecomeInvalidBlock");
    }];
    
    [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession*session,NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing*_credential) {
        
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        __autoreleasing NSURLCredential *credential      = nil;
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            
            if ([weakManager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                
                if (credential) {
                    disposition = NSURLSessionAuthChallengeUseCredential;
                }else {
                    disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                }
                
            }else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        }else {
            // client authentication
            SecIdentityRef identity    = NULL;
            SecTrustRef trust          = NULL;
            NSString *p12              = [[NSBundle mainBundle] pathForResource:p12Name ofType:@"p12"];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            if (![fileManager fileExistsAtPath:p12]) {
                NSLog(@"%@.p12:not exist",p12Name);
            }else {
                NSData *PKCS12Data = [NSData dataWithContentsOfFile:p12];
                if ([[weakSelf class] extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data p12Password:password]) {
                    
                    SecCertificateRef certificate = NULL;
                    SecIdentityCopyCertificate(identity, &certificate);
                    const void *certs[]           = {certificate};
                    CFArrayRef certArray          = CFArrayCreate(kCFAllocatorDefault, certs,1,NULL);
                    credential =[NSURLCredential credentialWithIdentity:identity certificates:(__bridge NSArray*)certArray persistence:NSURLCredentialPersistencePermanent];
                    disposition                   = NSURLSessionAuthChallengeUseCredential;
                    
                }
            }
        }
        *_credential = credential;
        return disposition;
    }];
}

+(BOOL) extractIdentity:(SecIdentityRef*)outIdentity andTrust:(SecTrustRef *)outTrust fromPKCS12Data:(NSData *)inPKCS12Data p12Password:(NSString *)password {
    OSStatus securityError = errSecSuccess;
    //client certificate password
    NSDictionary*optionsDictionary = [NSDictionary dictionaryWithObject:password
                                                                 forKey:(__bridge id)kSecImportExportPassphrase];
    
    CFArrayRef items               = CFArrayCreate(NULL, 0, 0, NULL);
    securityError                  = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,(__bridge CFDictionaryRef)optionsDictionary,&items);
    
    if (securityError == 0){
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(items,0);
        const void*tempIdentity            = NULL;
        tempIdentity                       = CFDictionaryGetValue (myIdentityAndTrust,kSecImportItemIdentity);
        *outIdentity                       = (SecIdentityRef)tempIdentity;
        const void*tempTrust               = NULL;
        tempTrust                          = CFDictionaryGetValue(myIdentityAndTrust,kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    }else {
        NSLog(@"Failedwith error code %d",(int)securityError);
        return NO;
    }
    return YES;
}

+ (AFSecurityPolicy *)customSecurityPolicy:(NSString *)cerName
{
    // 先导入证书 证书由服务端生成，具体由服务端人员操作
    NSString *cerPath                       = [[NSBundle mainBundle] pathForResource:cerName ofType:@"cer"];//证书的路径
    NSData *cerData                         = [NSData dataWithContentsOfFile:cerPath];
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy        = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = NO;
    
    //validatesDomainName 是否需要验证域名，默认为YES;
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName      = YES;
    securityPolicy.pinnedCertificates       = [[NSSet alloc] initWithObjects:cerData, nil];
    return securityPolicy;
}

@end
