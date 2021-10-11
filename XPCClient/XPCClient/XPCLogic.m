//
//  XPC.m
//  XPC
//
//  Created by uwei on 2018/7/26.
//  Copyright © 2018 TEG of Tencent. All rights reserved.
//

#import "XPCLogic.h"

@implementation XPCLogic

// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
- (void)upperCaseString:(NSString *)aString withReply:(void (^)(NSString *))reply {
//    NSArray *a = @[];
//    id b = a[9];
    // 逻辑处理放在子线程
    [NSThread detachNewThreadWithBlock:^{
        NSLog(@"sub thread");
    }];
    
    reply([aString uppercaseString]);
}

@end
