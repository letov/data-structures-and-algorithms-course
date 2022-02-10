//
//  main.swift
//  BoyerMooreStringSearch
//
//  Created by руслан карымов on 10.02.2022.
//

import Foundation

class Search {
    // STRONGSTRING
    // ^
    // STRING
    // ^
    func findFullScan(text: String, pattern: String) -> Int {
        let text: Array<Character> = text.reduce(into: []) {
            $0.append($1)
        }
        let pattern: Array<Character> = pattern.reduce(into: []) {
            $0.append($1)
        }
        var t = 0
        while t <= text.count - pattern.count {
            var p = 0
            while p < pattern.count && text[t + p] == pattern[p] {
                p += 1
            }
            if p == pattern.count {
                return t
            }
            t += 1
        }
        return -1
    }
    
    // ABC
    //
    // ...  3
    // A    2
    // B    1
    // C    3
    // ...  3
    
    func createShift(pattern: Array<Character>) -> [Int] {
        var shift = [Int].init(repeating: pattern.count, count: 128)
        for (p, v) in pattern.enumerated() {
            if p == pattern.count - 1 {
                continue
            }
            shift[Int(v.asciiValue!)] = pattern.count - p - 1
        }
        return shift
    }
    // 0123456789
    // STRONGSTRING
    //      ^
    // STRING
    //      ^
    // 54321-
    // Бойера-Мура-Хорспула
    func findJump(text: String, pattern: String) -> Int {
        let text: Array<Character> = text.reduce(into: []) {
            $0.append($1)
        }
        let pattern: Array<Character> = pattern.reduce(into: []) {
            $0.append($1)
        }
        let shift = createShift(pattern: pattern)
        var t = 0
        while t <= text.count - pattern.count {
            var p = pattern.count - 1
            while p >= 0 {
                print("==" ,text[t + p], pattern[p])
                if text[t + p] != pattern[p] {
                    break
                }
                p -= 1
            }
            if p < 0 {
                return t
            }
            print("shift symbol", text[t + pattern.count - 1])
            let addT = shift[Int(text[t + pattern.count - 1].asciiValue!)]
            print("t += ", addT)
            t += addT
        }
        return -1
    }
    // Бойера-Мура
    //
    // ADDFSDFSFWEFVBCVBVCADD
    //                    ^ -> true
    func isPrefix(pattern: Array<Character>, p: Int) -> Bool {
        if p == pattern.count {
            return false
        }
        var j = 0
        for i in p..<pattern.count {
            if pattern[i] != pattern[j] {
                return false
            }
            j += 1
        }
        return true
    }
    // 012345678
    // SAFADSDFA
    //        ^ (count - 2 = 7)  -> FA -> 5
    //         ^ pattern.count - 1 - j
    //       ^   i
    func suffixLength(pattern: Array<Character>, p: Int) -> Int {
        var j = 0
        for i in (0..<p).reversed() {
            if pattern[i] == pattern[pattern.count - 1 - j] {
                j += 1
            } else {
                j = 0
            }
            if j == pattern.count - p {
                return p - i
            }
        }
        return 0
    }
    //  9876543210
    // ......xc...xAGAGSCAGAG..........
    //    GAGAGSCAGAG
    //
    //
    //  0          G  2
    //  1         AG  2
    //  2        GAG  8
    //  3       AGAG  8
    //          ...   8
    
    //  SADSS
    /*
     
        S
       SS
      DSS
     ADSS
    SADSS
     
    */
    //
    func createShift2(pattern: Array<Character>) -> [String: Int] {
        var k = pattern.count - 1
        var result = [Int].init(repeating: 1, count: pattern.count)
        for i in (0..<pattern.count).reversed() {
            if isPrefix(pattern: pattern, p: pattern.count - i) {
                k = i - 1
                for j in (i - 1)..<pattern.count {
                    result[j] = pattern.count - i
                }
                break
            }
        }
        for i in 0..<k {
            result[i] = suffixLength(pattern: pattern, p: pattern.count - 1 - i)
        }
        var res = [String: Int]()
        for p in 0..<pattern.count {
            let s = pattern.reversed().enumerated().reduce(into: "") {
                $0 = $1.offset <= p ? String($1.element) + $0 : $0
            }
            res[s] = result[p]
        }
        return res
    }
    func bm(text: String, pattern: String) -> [Int] {
        var result = [Int]()
        let text: Array<Character> = text.reduce(into: []) {
            $0.append($1)
        }
        let pattern: Array<Character> = pattern.reduce(into: []) {
            $0.append($1)
        }
        let shift = createShift(pattern: pattern)
        let shift2 = createShift2(pattern: pattern)
        print(shift)
        print(shift2)
        var t = 0
        var curSuffix = ""
        while t <= text.count - pattern.count {
            var p = pattern.count - 1
            while p >= 0 {
                print("==" ,text[t + p], pattern[p])
                if text[t + p] != pattern[p] {
                    break
                }
                curSuffix = String(pattern[p]) + curSuffix
                p -= 1
            }
            if p < 0 {
                result.append(t)
            }
            print("shift symbol", text[t + pattern.count - 1])
            let s1 = shift[Int(text[t + pattern.count - 1].asciiValue!)]
            print("shift1", s1)
            print("curSuffix", curSuffix)
            let s2 = shift2[curSuffix] ?? 0
            print("shift2", s2)
            let addT = max(s1, s2)
            print("t += ", addT)
            t += addT
            curSuffix = ""
        }
        return result
    }
}
