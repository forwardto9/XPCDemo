//
//  ViewController.swift
//  XPCClient
//
//  Created by uwei on 2018/7/26.
//  Copyright © 2018 TEG of Tencent. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func crashButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "XPC Demo", message: "click button to crash XPC", preferredStyle: .alert)
        let crashAction = UIAlertAction(title: "Crash", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
            if #available(iOS 11, *) {
                XPCManager.default().listener(with: XPCClientProxy())
            } else {
                    // Fallback on earlier versions
            }
            (XPCManager.default().proxy(with: XPCLogicProtocol.self) as? XPCLogicProtocol)? .upperCaseString("hello") { [unowned self] (result:String?) in
                guard (result != nil) else {
                    print("result is nil")
                    return
                }
                print(NSXPCConnection.current()?.processIdentifier ?? "0000")
                print("XPC callback:\(result ?? " result is nil")")
                DispatchQueue.main.async {
                    sender.setTitle("change me \(Int.random(in: 1...5))", for: .normal)
                }
            }
            
            (XPCManager.default().proxy(with: XPCLogicProtocol.self) as? XPCLogicProtocol)?.custom(dataReply: { data in
                print(data?.sex ?? "")
                print(data?.name ?? "")
                print(data?.extInfo ?? "")
            })
            
            let data = XPCCustomData()
            data.name = "app";
            data.sex = false;
            data.extInfo = ["k":"v"]
            (XPCManager.default().proxy(with: XPCLogicProtocol.self) as? XPCLogicProtocol)?.custom(with: data, reply: { result in
                print(result?.sex ?? "")
                print(result?.name ?? "")
            })
        }
        alert.addAction(crashAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
