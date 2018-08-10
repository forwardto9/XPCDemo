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
//    NSArray *a = @[];
//    id b = a[9];
    reply([aString uppercaseString]);
}

@end
