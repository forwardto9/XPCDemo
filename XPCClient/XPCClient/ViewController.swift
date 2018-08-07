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
        
        let endpoint =  (UIApplication.shared.delegate as! AppDelegate).listener.endpoint
        self.connectionToService = NSXPCConnection.init(listenerEndpoint:endpoint)
        self.connectionToService!.remoteObjectInterface = NSXPCInterface(with: XPCProtocol.self)
        
        self.connectionToService?.resume()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func crashButton(_ sender: Any) {
        let alert = UIAlertController(title: "XPC Demo", message: "click button to crash XPC", preferredStyle: .alert)
        let crashAction = UIAlertAction(title: "Crash", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            // 不带回调去获取Proxy
            //        let proxy:XPCProtocol = self.connectionToService!.remoteObjectProxy as! XPCProtocol
            
            /// 带回调去获取Proxy
            let proxy:XPCProtocol = self.connectionToService?.remoteObjectProxyWithErrorHandler({ (error) in
                // 这里可以用来处理proxy执行的异常
                print(error)
            }) as! XPCProtocol
            proxy.upperCaseString("hello") { [unowned self] (result:String?) in
                guard (result != nil) else {
                    print("result is nil")
                    self.connectionToService?.invalidate()
                    return
                }
                print(result!)
                self.connectionToService?.invalidate()
            }
            
        }
        alert.addAction(crashAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
