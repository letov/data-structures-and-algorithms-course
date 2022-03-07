//
//  Nod.swift
//  Dynamic
//
//  Created by руслан карымов on 07.03.2022.
//

import Foundation

// nod(2a,2b) = 2 * nod(a,b)
// nod(2a,2b+1) = nod(a,2b+1)
// nod(2a+1,2b+1) a>b => nod(2a+1-(2b+1),2b+1) = nod(2(a-b),2b+1) = nod(a-b,2b+1)

class Nod {
    static func nodDyn(_ a: Int, _ b: Int) -> Int {
        return nodDyn(a, b, 0)
    }
    
    static func nodDyn(_ a: Int, _ b: Int, _ acc: Int) -> Int {
        var a = a
        var b = b
        if a < b {
            swap(&a, &b)
        }
        guard a != b else {
            return a << acc
        }
        let aEven = a & 1 == 0
        let bEven = b & 1 == 0
        if aEven && bEven {
            return nodDyn(a >> 1, b >> 1, acc + 1)
        } else if !aEven && !bEven {
            return nodDyn(a - b, b, acc)
        } else if aEven {
            return nodDyn(a >> 1, b, acc)
        } else {
            return nodDyn(a, b >> 1, acc)
        }
    }
    
    static func nodEvklid(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b
        while a != b {
            if a > b {
                a = a - b
            } else {
                b = b - a
            }
        }
        return a
    }
    
    static func nodMod(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b
        while a != 0 && b != 0 {
            if a > b {
                a = a % b
            } else {
                b = b % a
            }
        }
        return abs(a - b)
    }
}
