//
//  JsonResult.h
//  lishua
//
//  Created by Zeng on 2017/4/5.
//  Copyright © 2017年 嘉联支付有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonResult : NSObject

@property (nonatomic, strong) id Body;

@property (nonatomic, assign) NSInteger BuildVersion;

@property (nonatomic, copy) NSString *CertNO;

@property (nonatomic, copy) NSString *CommandID;

@property (nonatomic, copy) NSString *DeviceUUID;

@property (nonatomic, copy) NSString *ErrorMsg;

@property (nonatomic, copy) NSString *Machine;

@property (nonatomic, copy) NSString *NodeID;

@property (nonatomic, copy) NSString *NodeType;

/**
   10  登录过期
   0   成功
   其余的提示错误信息
 */
@property (nonatomic, copy) NSString *RetCode;


@property (nonatomic, copy) NSString *SeqID;

@property (nonatomic, copy) NSString *Sign;

@property (nonatomic, copy) NSString *SysNum;

@property (nonatomic, copy) NSString *TokenID;

@property (nonatomic, copy) NSString *Version;
@end
