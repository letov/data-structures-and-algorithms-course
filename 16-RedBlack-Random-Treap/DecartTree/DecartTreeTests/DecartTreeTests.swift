//
//  DecartTreeTests.swift
//  DecartTreeTests
//
//  Created by руслан карымов on 15.12.2021.
//

import XCTest
@testable import DecartTree

class DecartTreeTests: XCTestCase {

    var sut: DT!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DT()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    
    func getBaseState1() -> DT {
        let baseState = DT()
        let n8_8 = Node(key: 8, y: 8)
        let n6_7 = Node(key: 6, y: 7)
        let n15_6 = Node(key: 15, y: 6)
        let n12_4 = Node(key: 12, y: 4)
        let n20_5 = Node(key: 20, y: 5)
        let n10_2 = Node(key: 10, y: 2)
        let n14_1 = Node(key: 14, y: 1)
        n12_4.L = n10_2
        n12_4.R = n14_1
        n15_6.L = n12_4
        n15_6.R = n20_5
        n8_8.L = n6_7
        n8_8.R = n15_6
        baseState.root = n8_8
        return baseState
    }
    
    func getBaseState2() -> (Node?, Node?) {
        let n8_8 = Node(key: 8, y: 8)
        let n6_7 = Node(key: 6, y: 7)
        let n15_6 = Node(key: 15, y: 6)
        let n12_4 = Node(key: 12, y: 4)
        let n20_5 = Node(key: 20, y: 5)
        let n10_2 = Node(key: 10, y: 2)
        let n14_1 = Node(key: 14, y: 1)
        n12_4.L = n10_2
        n8_8.L = n6_7
        n8_8.R = n12_4
        n15_6.L = n14_1
        n15_6.R = n20_5
        return (n8_8, n15_6)
    }
    
    func getBaseState3() -> DT {
        let baseState = DT()
        let n8_8 = Node(key: 8, y: 8)
        let n6_7 = Node(key: 6, y: 7)
        let n15_6 = Node(key: 15, y: 6)
        let n12_4 = Node(key: 12, y: 4)
        let n20_5 = Node(key: 20, y: 5)
        let n10_2 = Node(key: 10, y: 2)
        let n14_1 = Node(key: 14, y: 1)
        let n13_5 = Node(key: 13, y: 5)
        n12_4.L = n10_2
        n13_5.L = n12_4
        n13_5.R = n14_1
        n15_6.L = n13_5
        n15_6.R = n20_5
        n8_8.L = n6_7
        n8_8.R = n15_6
        baseState.root = n8_8
        return baseState
    }
    
    func testSplitMerge(){
        sut = getBaseState1()
        let (L, R) = getBaseState2()
        let (splitL, splitR) = sut.split(key: 13, node: sut.root)
        XCTAssertEqual(L, splitL)
        XCTAssertEqual(R, splitR)
        sut = DT()
        sut.root = sut.merge(node1: L, node2: Node(key: 13, y: 5))
        sut.root = sut.merge(node1: sut.root, node2: R)
        XCTAssertEqual(sut, getBaseState3())
    }

}
