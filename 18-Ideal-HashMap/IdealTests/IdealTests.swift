//
//  IdealTests.swift
//  IdealTests
//
//  Created by руслан карымов on 09.01.2022.
//

import XCTest
@testable import Ideal

class IdealTests: XCTestCase {
    
    var sutIdealHashMap: IdealHashMap<String>!

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    // ideal A B for max 6 collisions: (126033098, 312248272)
    // memory increase: x1.626834527370105
    // 57508 words
    func testFindIdealAB() throws {
        let engRusDic = EngRusDic(fileName: "dict.xdxf").data
        var idealAB: (UInt, UInt) = (0, 0)
        var minCollision = Int.max
        var minMemIncrease = 100.0
        for _ in 1...10 {
            let A: UInt = HashFunc.randA
            let B: UInt = HashFunc.randB
            sutIdealHashMap = IdealHashMap<String>.init(hashTableCapacity: engRusDic.count, A: A, B: B)
            for i in engRusDic {
                sutIdealHashMap.add(key: i.key, value: i.value)
            }
            let maxCollision = sutIdealHashMap.collisionCounter.max()!
            let memIncrease: Double = Double(sutIdealHashMap.memCounter()) / Double(engRusDic.count)
            if maxCollision < minCollision {
                minCollision = maxCollision
                minMemIncrease = memIncrease
                idealAB = (A, B)
            } else if maxCollision == minCollision {
                minMemIncrease = memIncrease
                idealAB = (A, B)
            }
        }
        print("ideal A B for max \(minCollision) collisions: \(idealAB)")
        print("memory increase: x\(minMemIncrease)")
        XCTAssertLessThanOrEqual(minCollision, 10)
        XCTAssertLessThanOrEqual(minMemIncrease, 2.9)
    }
    
    // search time 0,00029 s
    func testSearch() throws {
        let engRusDic = EngRusDic(fileName: "dict.xdxf").data
        sutIdealHashMap = IdealHashMap<String>.init(hashTableCapacity: engRusDic.count, A: 126033098, B: 312248272)
        for i in engRusDic {
            sutIdealHashMap.add(key: i.key, value: i.value)
        }
        measure {
            let translate = sutIdealHashMap.search(key: "afternoons")!
            XCTAssertLessThanOrEqual(translate, "ДНЕМ")
        }
    }
}
