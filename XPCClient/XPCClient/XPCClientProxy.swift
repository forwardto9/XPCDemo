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
        newConnection.exportedInterface = NSXPCInterface(with: XPCProtocol.self)
        let exportedObject = XPC.init()
        newConnection.exportedObject = exportedObject
        newConnection.resume()
        return true
    }
}
