//
//  main.swift
//  7-primes-homework
//
//  Created by руслан карымов on 11.11.2021.
//

import Foundation

class Primes: iTask {

    var opCnt = 0
    
    func run(_ data: [String]) -> String {
        guard let N = UInt(data[0]) else {
            return ""
        }
        if (N == 1) {
            return "0"
        }
        let res = eratosphen2(Int(N))
        return String(res)
    }
    
    // Через перебор делителей
    func primes1(_ N: UInt) -> UInt {
        var primeCnt: UInt = 0
        for i in 2...N {
            if isPrime5(i) {
                primeCnt += 1
            }
        }
        return primeCnt
    }
    
    // A1
    func isPrime1(_ p: UInt) -> Bool {
        var cnt = 0
        for j in 1...p {
            if p % j == 0 {
                cnt += 1
                opCnt += 1
            }
        }
        return cnt == 2
    }
    
    // A2
    func isPrime2(_ p: UInt) -> Bool {
        for j in 2..<p {
            if p % j == 0 {
                return false
            }
        }
        return true
    }
    
    // A3
    func isPrime3(_ p: UInt) -> Bool {
        switch p {
        case 1:
            return false
        case 2:
            return true
        case 3:
            return true
        case 4:
            return false
        default:
            let hp = p / 2
            for j in 2..<hp {
                if p % j == 0 {
                    return false
                }
            }
            return true
        }
    }
    
    // A4
    func isPrime4(_ p: UInt) -> Bool {
        switch p {
        case 1:
            return false
        case 2:
            return true
        case 3:
            return true
        case 4:
            return false
        default:
            let sp = UInt(sqrt(Double(p)))
            for j in 2...sp {
                if p % j == 0 {
                    return false
                }
            }
            return true
        }
    }
    
    // A5
    func isPrime5(_ p: UInt) -> Bool {
        switch p {
        case 1:
            return false
        case 2:
            return true
        case 3:
            return true
        case 4:
            return false
        default:
            var j: UInt = 2
            while j * j <= p {
                if p % j == 0 {
                    return false
                }
                j += 1
            }
            return true
        }
    }
    
    // Решето Эратосфена со сложностью O(n log log n)
    func eratosphen1(_ N: Int) -> Int {
        var divs = [Bool].init(repeating: false, count: Int(N) + 1)
        var cnt = 0
        for p in 2...N {
            if (!divs[p]) {
                cnt += 1
                var i = p * p
                while i <= N {
                    divs[i] = true
                    i += p
                }
            }
        }
        return cnt
    }
    
    //  Решето Эратосфена со сложностью O(n)
    func eratosphen2(_ N: Int) -> Int {
        var pr = [Int]()
        var lp = [Int].init(repeating: 0, count: N + 1)
        for i in 2...N {
            if lp[i] == 0 {
                lp[i] = i
                pr.append(i)
            }
            var j = 0
            while j < pr.count && pr[j] <= lp[i] && i * pr[j] <= N {
                lp[i * pr[j]] = pr[j]
                j += 1
            }
        }
        return pr.count
    }
}

let primes = Primes()
let tester = Tester(path: "/Users/ruslankarymov/Desktop/5.Primes", task: primes)
tester.runTests()
