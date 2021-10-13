//
//  XPC.h
//  XPC
//
//  Created by uwei on 2018/7/26.
//  Copyright © 2018 TEG of Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XPCLogicProtocol.h"

    /// 自定义数据类型
    /// 为了能够通过Connection传递，需要遵循NSSecureCoding协议
@interface XPCCustomData : NSObject<NSSecureCoding>

@property (nullable, nonatomic, copy) NSString *name;
@property (assign) BOOL sex;
@property (nullable, nonatomic, strong) NSDictionary *extInfo;

@end

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface XPCLogic : NSObject <XPCLogicProtocol>
@end
