//
//  RedBlackTreeTests.swift
//  RedBlackTreeTests
//
//  Created by руслан карымов on 14.12.2021.
//

import XCTest
@testable import RedBlackTree

class RedBlackTreeTests: XCTestCase {

    var sut: RBT!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = RBT()
        let arr = Array(1...1000).shuffled()
        arr.forEach {
            sut.insert(key: $0)
        }
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func checkRedHasBlackChild(node: Node?) -> Bool {
        guard let node = node else {
            return true
        }
        if node.color == .red {
            guard node.L?.color ?? .black == .black
                    && node.R?.color ?? .black == .black else {
                return false
            }
        }
        return checkRedHasBlackChild(node: node.L)
        && checkRedHasBlackChild(node: node.R)
    }
    
    func getLeftBlackCount(node: Node?, acc: Int) -> Int {
        guard let node = node else {
            return acc
        }
        return getLeftBlackCount(node: node.L, acc: node.color == .black ? acc + 1 : acc)
    }
    
    func isLeaf(node: Node) -> Bool {
        return node.L == nil && node.R == nil
    }
     
    func checkAllPathBlackCount(node: Node?, acc: Int, origBC: Int) -> Bool {
        guard let node = node else {
            return true
        }
        let acc = node.color == .black ? acc + 1 : acc
        if isLeaf(node: node) {
            return acc == origBC
        }
        return checkAllPathBlackCount(node: node.L, acc: acc, origBC: origBC)
        && checkAllPathBlackCount(node: node.R, acc: acc, origBC: origBC)
    }
    
    func allPathContainSameBlackCount(node: Node?) -> Bool {
        let bc = getLeftBlackCount(node: node, acc: 0)
        return checkAllPathBlackCount(node: node, acc: 0, origBC: bc)
    }

    func testRBTRules() throws {
        // 1
        XCTAssertEqual(sut.root?.color, .black)
        // 2
        XCTAssertEqual(checkRedHasBlackChild(node: sut.root), true)
        // 3
        XCTAssertEqual(allPathContainSameBlackCount(node: sut.root), true)
    }

}
