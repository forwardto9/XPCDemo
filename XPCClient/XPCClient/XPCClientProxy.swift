//
//  XPCClientProxy.swift
//  XPCClient
//
//  Created by uwei on 2018/7/26.
//  Copyright © 2018 TEG of Tencent. All rights reserved.
//

import Foundation
class XPCClientProxy: NSObject,NSXPCListenerDelegate {
    @objc func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        // This attribute may be used by the listener delegate to accept or reject connections.
        // but what is the condition?
        print("\(#function) pid = \(newConnection.processIdentifier)")
        // 因为用serviceName初始化监听者的接口是macOS的
        print("service name:\(String(describing: newConnection.serviceName))")
        newConnection.exportedInterface = NSXPCInterface(with: XPCLogicProtocol.self)
        let exportedObject = XPCLogic()
        newConnection.exportedObject = exportedObject
        newConnection.resume()
        return true
    }
}
