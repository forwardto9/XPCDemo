//
//  XPC.m
//  XPC
//
//  Created by uwei on 2018/7/26.
//  Copyright © 2018 TEG of Tencent. All rights reserved.
//

#import "XPCLogic.h"
#import <objc/runtime.h>

@implementation XPCCustomData

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeBool:self.sex forKey:@"sex"];
    [coder encodeObject:self.extInfo forKey:@"extInfo"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    if (self = [super init]) {
        self.name = [coder decodeObjectForKey:@"name"];
        self.sex = [coder decodeBoolForKey:@"sex"];
        self.extInfo = [coder decodeObjectForKey:@"extInfo"];
    }
    return self;
}

@end

@implementation XPCLogic

// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
- (void)upperCaseString:(NSString *)aString withReply:(void (^)(NSString *))reply {
    // XPC会将逻辑处理放在自有线程
    NSLog(@"%s in thread:%@", __FUNCTION__, [NSThread currentThread]);
    
    // data logic
    reply([aString uppercaseString]);
    
    // 如果在自有线程中还有自建线程的处理，类似以下的话，crash就会导致app退出
//    [NSThread detachNewThreadWithBlock:^{
//        NSLog(@"sub thread");
        NSArray *a = @[@1];
//        id b = a[9];
//        NSLog(@"%@", b);
//    }];
}

- (void)customWithDataReply:(void (^)(XPCCustomData *))reply {
    XPCCustomData *data = [[XPCCustomData alloc] init];
    data.name = @"test";
    data.sex = YES;
    data.extInfo = @{@"key":@"value"};
    reply(data);
}

- (void)customWithData:(XPCCustomData *)data reply:(void (^)(XPCCustomData *))reply {
    NSLog(@"%s, %@", __FUNCTION__, data.extInfo);
    XPCCustomData *newData = [[XPCCustomData alloc] init];
    if ([data.name isEqualToString:@"app"]) {
        newData.name = @"Hi, app!";
    }
    reply(newData);
}

@end
