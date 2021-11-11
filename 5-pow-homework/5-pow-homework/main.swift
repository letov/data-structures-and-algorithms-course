//
//  main.swift
//  5-pow-homework
//
//  Created by руслан карымов on 09.11.2021.
//

import Foundation

class Pow: iTask {
    
    func run(_ data: [String]) -> String {
        guard let A = Double(data[0]) else {
            return ""
        }
        guard let N = Int(data[1]) else {
            return ""
        }
        return String(pow3(A, N))
    }
    
    // итерации N
    func pow1(_ A: Double, _ N: Int) -> Double {
        var result = 1.0
        var opCnt = 0
        if N != 0 {
            for _ in 1...N {
                result *= A
                opCnt += 1
            }
        }
        print(opCnt)
        return result
    }
    
    // степень двойки с домножением  logN + N/2
    func pow2(_ A: Double, _ N: Int) -> Double {
        var result = 1.0
        var opCnt = 0
        if N != 0 {
            result = A
            var degree = 2
            while degree < N {
                result *= result
                opCnt += 1
                degree *= 2
            }
            for _ in (degree / 2)..<N {
                result *= A
                opCnt += 1
            }
        }
        print(opCnt)
        return result
    }
    
    // двоичное разложение 2logN
    func pow3(_ A: Double, _ N: Int) -> Double {
        var opCnt = 0
        let degreeBin = String(N, radix: 2).reversed()
        var result = 1.0
        var degree2 = 1.0
        for byte in degreeBin {
            if byte == "1" {
                result *= degree2
            }
            degree2 *= 2
            opCnt += 1
        }
        print(opCnt)
        return result
    }
}

let pow = Pow()
let tester = Tester(path: "/Users/ruslankarymov/Desktop/3.Power", task: pow)
tester.runTests()
