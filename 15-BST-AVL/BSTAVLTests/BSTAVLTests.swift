//
//  BSTAVLTests.swift
//  BSTAVLTests
//
//  Created by руслан карымов on 13.12.2021.
//

import XCTest
@testable import BSTAVL
var sut: BST!

class BSTAVLTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = BST()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
