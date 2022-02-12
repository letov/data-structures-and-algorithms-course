//
//  KMPTests.swift
//  KMPTests
//
//  Created by руслан карымов on 12.02.2022.
//

import XCTest
@testable import KMP

class KMPTests: XCTestCase {

    var sut: KMP!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = KMP()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testCreateDelta() throws {
        let delta = sut.createDelta(pattern: "aabaabaaab")
        XCTAssertEqual(delta[2], [2, 3])
        XCTAssertEqual(delta[5], [2, 6])
        XCTAssertEqual(delta[7], [8, 0])
    }
    
    func testCreatePiSlow() throws {
        let pi = sut.createPiSlow(pattern: "aabaabaaab")
        XCTAssertEqual(pi, [0, 0, 1, 0, 1, 2, 3, 4, 5, 2, 3])
    }
    
    func testCreatePi() throws {
        let pi = sut.createPi(pattern: "aabaabaaab")
        XCTAssertEqual(pi, [0, 0, 1, 0, 1, 2, 3, 4, 5, 2, 3])
    }

    func testKMP() throws {
        let pattern = "ABC"
        let text = "ABBACABCABCCABCADDABC"
        //               ^  ^   ^     ^
        let pi = sut.createPi(pattern: pattern + "@" + text)
        XCTAssertEqual(pi.filter { $0 == pattern.count } .count, 4)
    }
}
