//
//  Dispatch3Tests.swift
//  Dispatch3Tests
//
//  Created by Yegor Popovych on 6/20/16.
//  Copyright © 2016 Crossroad Labs. All rights reserved.
//

import XCTest
import Dispatch
@testable import Dispatch3

class Dispatch3Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        print("Attrs: \(DispatchQueueAttributes.qosUtility)")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}
