//
//  XPCManager.m
//  XPCClient
//
//  Created by uweiyuan on 2021/10/11.
//  Copyright © 2021 TEG of Tencent. All rights reserved.
//

#import <objc/message.h>
#import "XPCManager.h"
#import "XPCLogicProtocol.h"
#import "XPCLogic.h"

static void *key = &key;
static void *key1 = &key1;
static void *key2 = &key2;

@implementation XPCManager

+ (id)defaultManager {
    static XPCManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (NSXPCListener *)listenerWithDelegate:(id<NSXPCListenerDelegate>)delegate {
    NSXPCListener *listener = self.listener;
    listener.delegate = delegate;
    // avoid for being released, because of the delegate is weak
    // 这个动态技术的使用，破坏了delegate的weak修饰，是否需要使用其他存放方式？比如放在另外一块开辟的内存中
    objc_setAssociatedObject(listener, &key1, delegate, OBJC_ASSOCIATION_RETAIN);
    return listener;
}

- (NSXPCConnection *)connectionWithProtocol:(Protocol *)protocol {
    NSXPCConnection *conn = self.connection;
    NSXPCInterface *interface = [NSXPCInterface interfaceWithProtocol:protocol];
    
    // 声明接口支持的数据类型
    // 自定义数据类型是必须的
    // 成员变量的类型是可选的，如果某一个成员变量的类型不会被使用到，则对应的数据类型可以不声明
    NSSet *expectedClasses = [NSSet setWithObjects:[XPCCustomData class],[NSString class], [NSDictionary class], nil];
    [interface setClasses:expectedClasses forSelector:@selector(customWithDataReply:) argumentIndex:0 ofReply:YES];
    
    [interface setClasses:expectedClasses forSelector:@selector(customWithData:reply:) argumentIndex:0 ofReply:YES];
    conn.remoteObjectInterface = interface;
    return conn;
}

- (NSXPCListener *)listener {
    // 连接器需要指定的监听者
    // 不同的接口逻辑处理，使用不同的监听者，那就需要将接口名与监听者关联对应上；这里是否需要使用字典的方式存储其映射关系？
    id object = objc_getAssociatedObject(self, &key);
    NSXPCListener *listener;
    if (object) {
        listener = (NSXPCListener *)object;
    } else {
        listener =  [NSXPCListener anonymousListener];
        objc_setAssociatedObject(self, &key, listener, OBJC_ASSOCIATION_RETAIN);
        [listener resume];
    }
    return listener;
}

- (NSXPCConnection *)connection {
    NSXPCListenerEndpoint *endpoint = self.listener.endpoint;
    
    id object = objc_getAssociatedObject(self, &key2);
    NSXPCConnection *conn;
    if (object) {
        conn = (NSXPCConnection *)object;
    } else {
        conn = [[NSXPCConnection alloc] initWithListenerEndpoint:endpoint];;
        objc_setAssociatedObject(self, &key2, conn, OBJC_ASSOCIATION_RETAIN);
        // 监听远程进程的 exit or crash
        conn.interruptionHandler = ^{
            // TODO: -
            // to provide enough contextual information—perhaps a pending operation queue and the connection object itself—so that your handler code can do something sensible, such as retrying pending operations, tearing down the connection, displaying an error dialog, or whatever other actions make sense in your particular app.
            

            NSLog(@"%s crashed or exited", __FUNCTION__);
        };
        
        // resume失败或者是向connection发送invalid消息
        conn.invalidationHandler = ^{
            // TODO: -
            // to provide enough contextual information—perhaps a pending operation queue and the connection object itself—so that your handler code can do something sensible, such as retrying pending operations, tearing down the connection, displaying an error dialog, or whatever other actions make sense in your particular app.
            

            NSLog(@"connection is invalidate");
        };
        [conn resume];
    }
    NSLog(@"%s pid = %d service name:%@", __FUNCTION__, conn.processIdentifier, conn.serviceName);
    return  conn;
}

- (id)proxyWithProtocol:(Protocol *)protocol {
    id p;
    if (@available(iOS 11, *)) {
        NSXPCConnection *conn = [self connectionWithProtocol:protocol];
        p = [conn remoteObjectProxyWithErrorHandler:^(NSError * _Nonnull error) {
            // 如果此对象在执行接口逻辑时遇到错误，比如crash，则error回调就会被调用，否则不会被触发
        }];
    } else {
        p = [[XPCLogic alloc] init];
    }
    
    return p?:nil;
}


@end
