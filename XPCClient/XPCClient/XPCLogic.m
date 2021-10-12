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
    // XPC会将逻辑处理放在自有线程
    NSLog(@"%s in thread:%@", __FUNCTION__, [NSThread currentThread]);
    // 如果在自有线程中还有自建线程的处理，类似以下的话，crash就会导致app退出
//    [NSThread detachNewThreadWithBlock:^{
//        NSLog(@"sub thread");
//        NSArray *a = @[];
//        id b = a[9];
//    }];
//    NSArray *a = @[];
//    id b = a[9];
    reply([aString uppercaseString]);
}

@end
