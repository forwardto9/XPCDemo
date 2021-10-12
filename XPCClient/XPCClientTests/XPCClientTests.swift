//
//  XPCClientTests.swift
//  XPCClientTests
//
//  Created by uweiyuan on 2021/10/12.
//  Copyright © 2021 TEG of Tencent. All rights reserved.
//

import XCTest
import XPCClient

class XPCClientTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLogic() {
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
            print("XPC callback:\(result ?? " result is nil")")
        }
    }

}
