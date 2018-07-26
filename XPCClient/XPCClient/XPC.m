//
//  XPC.m
//  XPC
//
//  Created by uwei on 2018/7/26.
//  Copyright © 2018 TEG of Tencent. All rights reserved.
//

#import "XPC.h"

@implementation XPC

// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
- (void)upperCaseString:(NSString *)aString withReply:(void (^)(NSString *))reply {
    NSString *response = [aString uppercaseString];
    reply(response);
}

- (nonnull id)remoteObjectProxy {
    return self;
}

- (nonnull id)remoteObjectProxyWithErrorHandler:(nonnull void (^)(NSError * _Nonnull))handler {
    return self;
}

@end
