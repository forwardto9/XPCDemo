//
//  ViewController.swift
//  XPCClient
//
//  Created by uwei on 2018/7/26.
//  Copyright © 2018 TEG of Tencent. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let connection = XPCManager.default().connection(with: XPCProtocol.self)
    override func viewDidLoad() {
        super.viewDidLoad()
        connection.resume()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func crashButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "XPC Demo", message: "click button to crash XPC", preferredStyle: .alert)
        let crashAction = UIAlertAction(title: "Crash", style: .default) { (action) in
            // The process name is used to register application defaults and is used in error messages. It does not uniquely identify the process.
//            let uiProcessName = ProcessInfo.processInfo.processName
            print("\(#function) in thread : \(Thread.current)   \(pthread_mach_thread_np(pthread_self())) ")
            alert.dismiss(animated: true, completion: nil)
            
            // 不带回调去获取Proxy
            //        let proxy:XPCProtocol = self.connectionToService!.remoteObjectProxy as! XPCProtocol
            
            /// 带回调去获取Proxy
            let proxy:XPCProtocol = self.connection.remoteObjectProxyWithErrorHandler({ (error) in
                // 这里可以用来处理proxy执行的异常
                print(error)
            }) as! XPCProtocol
            
            proxy.upperCaseString("hello") { [unowned self] (result:String?) in
                print("upperCaseString() in thread : \(Thread.current)  \(pthread_mach_thread_np(pthread_self()))")
                
                guard (result != nil) else {
                    print("result is nil")
                    self.connection.invalidate()
                    return
                }
                print(result!)
                
                // background thread cannot call UI API
//                sender.isHidden = false
                DispatchQueue.main.async {
                    sender.setTitle("change me", for: .normal)
                }
//                self.connectionToService?.invalidate()
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
