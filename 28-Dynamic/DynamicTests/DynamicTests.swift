//
//  DynamicTests.swift
//  DynamicTests
//
//  Created by руслан карымов on 07.03.2022.
//

import XCTest
@testable import Dynamic

class Timer {
    static var share = Timer()
    private var startTime = DispatchTime.now()
    
    func start() {
        startTime = DispatchTime.now()
    }
    
    func stop(_ label: String = "") {
        let stopTime = (DispatchTime.now().uptimeNanoseconds - startTime.uptimeNanoseconds) / 1000000
        print("\(label) - \(stopTime) ms")
    }
    
    func timer(label: String = "", _ f: () -> ()) {
        start()
        f()
        stop(label)
    }
}

class DynamicTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func testNod() throws {
        XCTAssertEqual(Nod.nodEvklid(24, 16), 8)
        XCTAssertEqual(Nod.nodMod(24, 16), 8)
        XCTAssertEqual(Nod.nodDyn(24, 16), 8)
        for _ in 1...10000 {
            let a = Int.random(in: 1000...10000)
            let b = Int.random(in: 1000...10000)
            var result = Set<Int>()
            result.insert(Nod.nodEvklid(a, b))
            result.insert(Nod.nodMod(a, b))
            result.insert(Nod.nodDyn(a, b))
            XCTAssertEqual(result.count, 1)
        }
    }
    
    func testNodEvklidPerfom() throws {
        // Time: 0.064 sec
        measure {
            _ = Nod.nodEvklid(10000000, 1)
        }
    }
    
    func testNodModPerfom() throws {
        // Time: 0.000 sec
        measure {
            _ = Nod.nodMod(10000000, 1)
        }
    }
    
    func testNodDynPerfom() throws {
        // Time: 0.000 sec
        measure {
            _ = Nod.nodDyn(10000000, 1)
        }
    }
    
    func testElka() throws {
        let elka = Elka(n: 11)
        print(elka.tree)
        print(elka.maxPathSum())
    }
    
    func testFiveEight() throws {
        let fiveEight = FiveEight()
        XCTAssertEqual(fiveEight.calc(5), 16)
    }
    
    func testIslands() throws {
        let islands = Islands(10)
        islands.show()
        print(islands.calc())
    }
}
