//
//  XPCManager.h
//  XPCClient
//
//  Created by uweiyuan on 2021/10/11.
//  Copyright © 2021 TEG of Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


    /// XPC管理实现类
@interface XPCManager : NSObject

    /// XPC管理者单例
+ (nonnull instancetype)defaultManager;

    /// 根据实际逻辑执行的代理创建监听者
    /// @param delegate 监听的代理对象，负责将逻辑执行者与连接器关联
- (nonnull NSXPCListener *)listenerWithDelegate:(nullable id<NSXPCListenerDelegate>)delegate;

    /// 根据实际逻辑接口创建连接器
    /// @param protocol 实际代码逻辑接口
- (nonnull NSXPCConnection *)connectionWithProtocol:(nullable Protocol *)protocol;

@end

NS_ASSUME_NONNULL_END
