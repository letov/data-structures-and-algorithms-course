//
//  HashmapTests.swift
//  HashmapTests
//
//  Created by руслан карымов on 24.12.2021.
//

import XCTest
@testable import HashMap

class HashtableTests: XCTestCase {
    
    var sutChaining: HashMapChaining<Int>!
    var sutOpen: HashMapOpenAddress<Int>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sutChaining = HashMapChaining<Int>()
        sutOpen = HashMapOpenAddress<Int>()
    }

    override func tearDownWithError() throws {
        sutChaining = nil
        sutOpen = nil
        try super.tearDownWithError()
    }
    
    func generateRandomString(size: Int) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<size).map { _ in base.randomElement()!})
    }
    
    func testPearsonCollisions() throws {
        var unicHash = Set<UInt>()
        let testCnt = 100000
        //measure {
            for _ in 1...testCnt {
                let key = generateRandomString(size: 10)
                let hash = HashFunc.pearson(key: key)
                unicHash.insert(hash)
            }
        //}
        let collisions = Double(testCnt - unicHash.count) / Double(testCnt)
        XCTAssertLessThan(collisions, 0.00001)
    }
    
    func testDivisionCollisions() throws {
        var unicHash = Set<Int>()
        let testCnt = 100000
        var M = 10
        //measure {
            for i in 1...testCnt {
                let key = generateRandomString(size: 10)
                let hashCode = HashFunc.pearson(key: key)
                if i * 2 >= M {
                    M = HashFunc.maxPrimeErast(M * 10)
                }
                let hash = HashFunc.division(key: hashCode, M: M)
                unicHash.insert(hash)
            }
        //}
        let collisions = (Double(testCnt - unicHash.count) / Double(testCnt)) * 100
        print(collisions)
        XCTAssertLessThan(collisions, 15)
    }
    
    func testMultiplicationCollisions() throws {
        var unicHash = Set<Int>()
        let testCnt = 100000
        //measure {
            var P = 2
            var maxBound = 4
            for i in 1...testCnt {
                let key = generateRandomString(size: 10)
                let hashCode = HashFunc.pearson(key: key)
                let hash = HashFunc.multiplication(key: hashCode, P: P)
                if i * 2 >= maxBound {
                    P += 1
                    maxBound += maxBound
                }
                unicHash.insert(hash)
            }
        //}
        let collisions = (Double(testCnt - unicHash.count) / Double(testCnt)) * 100
        XCTAssertLessThan(collisions, 0.00001)
    }
    
    func testUniversalCollisions() throws {
        var collisionsCnt = 0
        let testCnt = 100000
        //measure {
            for _ in 1...testCnt {
                let key = generateRandomString(size: 10)
                let hashCode = HashFunc.pearson(key: key, maxByte: 4)
                let hash1 = HashFunc.universal(hashCode: hashCode, hashTableCount: testCnt, randSet: 0)
                let hash2 = HashFunc.universal(hashCode: hashCode, hashTableCount: testCnt, randSet: 1)
                if hash1 == hash2 {
                    collisionsCnt += 1
                }
            }
        //}
        let collisions = (Double(collisionsCnt) / Double(testCnt)) * 100.0
        XCTAssertLessThan(collisions, 0.01)
    }
    
    func testChainingHashRange() throws {
        for _ in 1...1000 {
            let hash = sutChaining.hash(key: generateRandomString(size: 10))
            XCTAssertGreaterThanOrEqual(hash, 0)
            XCTAssertLessThan(hash, sutChaining.hashTable.count)
        }
    }
    
    func fillRandomKey(count: Int) {
        for _ in 0..<count {
            sutChaining.insert(key: generateRandomString(size: 10), value: 66)
        }
    }
    
    func testChainingInsertSame() throws {
        sutChaining.insert(key: "c", value: 66)
        sutChaining.insert(key: "c", value: 77)
        XCTAssertEqual(sutChaining.maxDepth, 1)
        XCTAssertEqual(sutChaining.size, 1)
    }
    
    func testChainingRehash() throws {
        fillRandomKey(count: 10000)
        XCTAssertLessThan(sutChaining.maxDepth, 10)
    }
    
    func realChainingSize() -> Int {
        var result = 0
        for map in sutChaining.hashTable {
            var map = map
            while (map != nil) {
                result += 1
                map = map!.next
            }
        }
        return result
    }
    
    func testChainingSize() throws {
        sutChaining.insert(key: "KEY_77", value: 77)
        sutChaining.insert(key: "K77_EY", value: 99)
        sutChaining.rehash()
        XCTAssertEqual(realChainingSize(), sutChaining.size)
    }
    
    func testChainingSearch() throws {
        sutChaining.insert(key: "SEARCH_KEY", value: 77)
        fillRandomKey(count: 10000)
        //measure {
            let value = sutChaining.search(key: "SEARCH_KEY") ?? 0
            XCTAssertEqual(value, 77)
        //}
    }
    
    func testOpenInsertSame() throws {
        sutOpen.insert(key: "a", value: 66)
        sutOpen.insert(key: "a", value: 77)
        XCTAssertEqual(sutOpen.size, 1)
    }
    
    func fillOpenKey(count: Int) {
        for _ in 0..<count {
            sutOpen.insert(key: generateRandomString(size: 10), value: 66)
        }
    }
    
    func testOpenSearch() throws {
        sutOpen.insert(key: "SEARCH_KEY", value: 77)
        fillOpenKey(count: 10000)
        //measure {
            let value = sutOpen.search(key: "SEARCH_KEY") ?? 0
            XCTAssertEqual(value, 77)
        //}
    }
}
