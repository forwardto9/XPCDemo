//
//  ViewController.swift
//  XPCClient
//
//  Created by uwei on 2018/7/26.
//  Copyright © 2018 TEG of Tencent. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var connectionToService:NSXPCConnection?
    override func viewDidLoad() {
        super.viewDidLoad()
        let endpoint =  (UIApplication.shared.delegate as! AppDelegate).endpoint!
        self.connectionToService = NSXPCConnection.init(listenerEndpoint:endpoint)
        self.connectionToService!.remoteObjectInterface = NSXPCInterface(with: XPCProtocol.self)
        self.connectionToService?.resume()
        

        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let proxy:XPCProtocol = self.connectionToService!.remoteObjectProxy as! XPCProtocol
        proxy.upperCaseString("hello") { (result) in
            print(result ?? "is nil")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

