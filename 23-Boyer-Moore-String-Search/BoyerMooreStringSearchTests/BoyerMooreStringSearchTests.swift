//
//  BoyerMooreStringSearchTests.swift
//  BoyerMooreStringSearchTests
//
//  Created by руслан карымов on 10.02.2022.
//

import XCTest
@testable import BoyerMooreStringSearch

class BoyerMooreStringSearchTests: XCTestCase {
    
    var sut: Search!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = Search()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testFindFullScan() throws {
        XCTAssertEqual(sut.findFullScan(text: "STRONGSTRING", pattern: "STRING"), 6)
    }
    
    func testShift() throws {
        // BBCABC
        // ABC
        // 21-
        let a: Array<Character> = "ABC".reduce(into: []) {
            $0.append($1)
        }
        let shift = sut.createShift(pattern: a)
        XCTAssertEqual(shift[Int(Character("C").asciiValue!)],3)
        XCTAssertEqual(shift[Int(Character("B").asciiValue!)],1)
        XCTAssertEqual(shift[Int(Character("A").asciiValue!)],2)
    }

    func testFindJump() throws {
        XCTAssertEqual(sut.findJump(text: "STRONGSTRING", pattern: "STRING"), 6)
    }
    
    func testIsPrefix() throws {
        let a: Array<Character> = "AFDasdAFD".reduce(into: []) {
            $0.append($1)
        }
        XCTAssertEqual(sut.isPrefix(pattern: a, p: a.count - 3), true)
    }
    //     %AFAxFAdfDSDFA
    //            SAFAxFAdfDSDFA
    func testSuffixLength() throws {
        let a: Array<Character> = "SAFAdfDSDFA".reduce(into: []) {
            $0.append($1)
        }
        XCTAssertEqual(sut.suffixLength(pattern: a, p: a.count - 2), 7)
    }
    func testShift2() throws {
        let a: Array<Character> = "SADSS".reduce(into: []) {
            $0.append($1)
        }
        print(sut.createShift2(pattern: a))
    }
    // FASSyADADSESADASADSASdfDSSADADSESADADSADSAASDFA
    //     
    // SADADSESAD
    func testBm() throws {
        print(sut.bm(text: "FASSyADADSESADASADSASdfDSSADADSESADADSADSAASDFA", pattern: "SADADSESAD"))
    }
    
    func generateRandomString(size: Int) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<size).map { _ in base.randomElement()!})
    }
    
    func testPerfomance() throws {
        let pattern = "SADADSESAD"
        let size = 30000
        let text = generateRandomString(size: size) + pattern
        // Time: 0.431 sec
        /*measure {
            XCTAssertEqual(sut.bm(text: text, pattern: pattern), [size])
        }*/
        // Time: 0.240 sec
        /*measure {
            XCTAssertEqual(sut.findJump(text: text, pattern: pattern), size)
        }*/
        // Time: 0.016 sec
        measure {
            XCTAssertEqual(sut.findFullScan(text: text, pattern: pattern), size)
        }
    }
}
    
    
