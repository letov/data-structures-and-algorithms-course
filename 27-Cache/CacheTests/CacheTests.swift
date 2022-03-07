//
//  CacheTests.swift
//  CacheTests
//
//  Created by руслан карымов on 07.03.2022.
//

import XCTest
@testable import Cache

class CacheTests: XCTestCase {
    
    var lru: LRU<String, Int>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        lru = LRU<String, Int>()
    }

    override func tearDownWithError() throws {
        lru = nil
        try super.tearDownWithError()
    }

    func testAdd() throws {
        let cnt = 10000
        for i in 0..<cnt {
            lru.add(key: String(i), value: i)
        }
        XCTAssertEqual(lru.count, lru.maxCacheSize)
    }
    
    func testGet() throws {
        let cnt = 10
        for i in 0..<cnt {
            lru.add(key: String(i), value: i)
        }
        let half = Int(cnt / 2)
        XCTAssertEqual(lru.get(key: String(half)), half)
        XCTAssertEqual(lru.storage.head!.value.value, half)
        
    }

    
}
