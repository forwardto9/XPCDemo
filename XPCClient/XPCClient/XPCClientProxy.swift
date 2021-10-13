//
//  XPCClientProxy.swift
//  XPCClient
//
//  Created by uwei on 2018/7/26.
//  Copyright © 2018 TEG of Tencent. All rights reserved.
//

import Foundation
/**
 代理实现类
 [Creating XPC Services](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingXPCServices.html)
 */
class XPCClientProxy: NSObject,NSXPCListenerDelegate {
    @objc func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        // This attribute may be used by the listener delegate to accept or reject connections.
        // but what is the condition?
        print("\(#function) pid = \(newConnection.processIdentifier)")
        
        // 因为用serviceName初始化监听者的接口是macOS的
        print("service name:\(String(describing: newConnection.serviceName))")
        
        let interface = NSXPCInterface(with: XPCLogicProtocol.self)
        // 因为app通过接口向logic传递了自定义数据类型，就需要通过此接口声明接口支持的数据类型
        let outClasses = NSSet(objects: XPCCustomData.self, NSString.self, NSDictionary.self)
        interface.setClasses(outClasses as! Set<AnyHashable>, for: #selector(XPCLogicProtocol.custom(with:reply:)), argumentIndex: 0, ofReply: false)
        newConnection.exportedInterface = interface
        
        let exportedObject = XPCLogic()
        newConnection.exportedObject = exportedObject
        newConnection.resume()
        
        return true
    }
}
