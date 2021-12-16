//
//  RandomTreeTests.swift
//  RandomTreeTests
//
//  Created by руслан карымов on 15.12.2021.
//

import XCTest
@testable import RandomTree

class RandomTreeTests: XCTestCase {
    
    var sut: RT!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = RT()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func getBaseState1() -> RT {
        let baseState = RT()
        baseState.insert(key: 100)
        
        baseState.insert(key: 90)
        baseState.insert(key: 200)
        
        baseState.insert(key: 80)
        baseState.insert(key: 95)
        baseState.insert(key: 195)
        baseState.insert(key: 300)
        return baseState
    }
    
    func getBaseState2() -> RT {
        let baseState = RT()
        baseState.insert(key: 100)
        
        baseState.insert(key: 90)
        baseState.insert(key: 200)
        
        baseState.insert(key: 95)
        return baseState
    }

    func testLeftRotate() {
        sut = getBaseState1()
        sut.root = sut.leftRotate(node: sut.search(key: 100)!)
        let checkState = RT()
        checkState.insert(key: 200)
        
        checkState.insert(key: 100)
        checkState.insert(key: 300)
        
        checkState.insert(key: 90)
        checkState.insert(key: 195)
        
        checkState.insert(key: 80)
        checkState.insert(key: 95)
        XCTAssertEqual(sut, checkState)
    }
    
    func testRightRotate() {
        sut = getBaseState1()
        sut.root = sut.rightRotate(node: sut.search(key: 100)!)
        let checkState = RT()
        checkState.insert(key: 90)
        
        checkState.insert(key: 80)
        checkState.insert(key: 100)
        
        checkState.insert(key: 95)
        checkState.insert(key: 200)
        
        checkState.insert(key: 195)
        checkState.insert(key: 300)
        XCTAssertEqual(sut, checkState)
    }

    func testRootInsert() {
        sut = getBaseState2()
        sut.root = sut.rootInsert(key: 93, node: sut.root)
        let checkState = RT()
        checkState.insert(key: 93)
        
        checkState.insert(key: 90)
        checkState.insert(key: 100)
        
        checkState.insert(key: 95)
        checkState.insert(key: 200)

        XCTAssertEqual(sut, checkState)
    }
}
