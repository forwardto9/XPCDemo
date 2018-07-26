//
//  XPC.h
//  XPC
//
//  Created by uwei on 2018/7/26.
//  Copyright © 2018 TEG of Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XPCProtocol.h"

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface XPC : NSObject <XPCProtocol, NSXPCProxyCreating>
@end
