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
            
            (XPCManager.default().proxy(with: XPCLogicProtocol.self) as? XPCLogicProtocol)? .upperCaseString("hello") { [unowned self] (result:String?) in
                guard (result != nil) else {
                    print("result is nil")
                    return
                }
                print("XPC callback:\(result ?? " result is nil")")
                DispatchQueue.main.async {
                    sender.setTitle("change me \(Int.random(in: 1...5))", for: .normal)
                }
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
