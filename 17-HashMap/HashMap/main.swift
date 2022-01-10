//
//  main.swift
//  HashMap
//
//  Created by руслан карымов on 24.12.2021.
//

import Foundation

class HashFunc {
    static func pearson(key: String, maxByte: Int = 8) -> UInt {
        let table: Array<UInt8> = Array(arrayLiteral:
                   98,  6, 85,150, 36, 23,112,164,135,207,169,  5, 26, 64,165,219, //  1
                   61, 20, 68, 89,130, 63, 52,102, 24,229,132,245, 80,216,195,115, //  2
                   90,168,156,203,177,120,  2,190,188,  7,100,185,174,243,162, 10, //  3
                  237, 18,253,225,  8,208,172,244,255,126,101, 79,145,235,228,121, //  4
                  123,251, 67,250,161,  0,107, 97,241,111,181, 82,249, 33, 69, 55, //  5
                   59,153, 29,  9,213,167, 84, 93, 30, 46, 94, 75,151,114, 73,222, //  6
                  197, 96,210, 45, 16,227,248,202, 51,152,252,125, 81,206,215,186, //  7
                   39,158,178,187,131,136,  1, 49, 50, 17,141, 91, 47,129, 60, 99, //  8
                  154, 35, 86,171,105, 34, 38,200,147, 58, 77,118,173,246, 76,254, //  9
                  133,232,196,144,198,124, 53,  4,108, 74,223,234,134,230,157,139, // 10
                  189,205,199,128,176, 19,211,236,127,192,231, 70,233, 88,146, 44, // 11
                  183,201, 22, 83, 13,214,116,109,159, 32, 95,226,140,220, 57, 12, // 12
                  221, 31,209,182,143, 92,149,184,148, 62,113, 65, 37, 27,106,166, // 13
                    3, 14,204, 72, 21, 41, 56, 66, 28,193, 40,217, 25, 54,179,117, // 14
                  238, 87,240,155,180,170,242,212,191,163, 78,218,137,194,175,110, // 15
                   43,119,224, 71,122,142, 42,160,104, 48,247,103, 15, 11,138,239  // 16
        )
        var hash: UInt = 0
        for i in 0...(maxByte - 1) {
            var _hash: UInt8 = table[(Int(key.first?.asciiValue ?? 0) + i) % 256]
            for j in key {
                _hash = table[Int(_hash ^ UInt8(j.asciiValue ?? 0))]
            }
            hash += UInt(_hash) << (i * 8)
        }
        return hash
    }
    
    static func maxPrimeErast(_ N: Int) -> Int {
        var sieve = [Bool].init(repeating: true, count: N + 1)
        for i in 2...N {
            if sieve[i] {
                var j = 2
                var p = 0
                while true {
                    p = j * i
                    j += 1
                    if p > N {
                        break
                    }
                    sieve[p] = false
                }
            }
        }
        for (index, isPrime) in sieve.reversed().enumerated() {
            if isPrime {
                return N - index
            }
        }
        return 1
    }
    
    // M is prime
    static func division(key: UInt, M: Int) -> Int {
        return Int(key % UInt(M))
    }
    
    // 2^P
    static func multiplication(key: UInt, P: Int) -> Int {
        return Int((key &* 2654435769) >> (32 - P))
    }
    
    // A > 0
    // B >= 0
    // P > M && prime
    static func universal(hashCode: UInt, M : Int, A: UInt, B: UInt, P: UInt) -> Int {
        return Int(((UInt(A &* hashCode) + B) % P) % UInt(M))
    }
}

protocol HashMap {
    associatedtype Value
    associatedtype Map
    var hashTable: Array<Map?> { get set }
    var size: Int { get set }
    func getHashCode(key: String) -> UInt
    func hash(key: String) -> Int
    mutating func rehash() 
    mutating func insert(key: String, value: Value)
    mutating func delete(key: String)
    func search(key: String) -> Value?
}
