//
//  BarnTests.swift
//  BarnTests
//
//  Created by руслан карымов on 08.03.2022.
//

import XCTest
@testable import Barn

class BarnTests: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()

    }

    override func tearDownWithError() throws {
        
        try super.tearDownWithError()
    }
    
    func testGetHeightAt4() throws {
        let barn = Barn(N: 10, M: 10, prob: 0.1)
        barn.show()
        XCTAssertEqual(5, barn.getHeightAt4(xZero: 1, yZero: 0, minHeight: 10))
        XCTAssertEqual(0, barn.getHeightAt4(xZero: 2, yZero: 3, minHeight: 10))
        XCTAssertEqual(4, barn.getHeightAt4(xZero: 2, yZero: 4, minHeight: 10))
        XCTAssertEqual(7, barn.getHeightAt4(xZero: 0, yZero: 3, minHeight: 10))
    }
    
    func testGetSquareAt4() throws {
        let barn = Barn(N: 10, M: 10, prob: 0.1)
        barn.show()
        XCTAssertEqual(18, barn.getSquareAt4(xZero: 7, yZero: 0))
        XCTAssertEqual(7, barn.getSquareAt4(xZero: 0, yZero: 3))
    }
    
    func testPerfomance4() throws {
        let Ns = [100]
        let probs = [0.1, 0.2, 0.5]
        for N in Ns {
            for prob in probs {
                let barn = Barn(N: N, M: N, prob: prob)
                let startTime = DispatchTime.now()
                let result = barn.maxSquare2()
                let stopTime = (DispatchTime.now().uptimeNanoseconds - startTime.uptimeNanoseconds) / 1000000
                print("N = \(N), prob = \(prob), result = \(result), time = \(stopTime) ms")
            }
        }
    }
}
