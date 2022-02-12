//
//  main.swift
//  KMP
//
//  Created by руслан карымов on 12.02.2022.
//

import Foundation

class KMP {

    func getAlphabet(pattern: String) -> [Character] {
        return pattern.reduce(into: []) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }.sorted(by: <)
    }

    // O(n) = n^4
    func createDelta(pattern: String) -> [[Int]] {
        let alphabet = getAlphabet(pattern: pattern)
        var result = [[Int]].init(repeating: [Int].init(repeating: 0, count: alphabet.count), count: pattern.count)
        for i in 0..<pattern.count {
            for letter in alphabet.enumerated() {
                let line = pattern.prefix(i) + String(letter.element) // state 4 -> aaba + [ a | b ]
                var j = i + 1
                while pattern.prefix(j) != line.suffix(j) { // aabaa == aabaa -> next state 5
                    j -= 1
                }
                result[i][letter.offset] = j
            }
        }
        return result
    }
    
    // O(n) = n^3
    func createPiSlow(pattern: String) -> [Int] {
        var result = [Int].init(repeating: 0, count: pattern.count + 1)
        for i in 1...pattern.count {
            let line = pattern.prefix(i) // aabaaba -> 4
            for j in 1..<line.count {
                if line.prefix(j) == line.suffix(j) {
                    result[i] = j
                }
            }
        }
        return result
    }
    
    // O(n) = < n^2
    func createPi(pattern: String) -> [Int] {
        let pattern: Array<Character> = pattern.reduce(into: []) {
            $0.append($1)
        }
        var result = [Int].init(repeating: 0, count: pattern.count + 1)
        for i in 1..<pattern.count {
            var len = result[i]
            while len > 0 && pattern[len] != pattern[i] {
                len = result[len]
            }
            if pattern[len] == pattern[i] {
                len += 1
            }
            result[i + 1] = len
        }
        return result
    }
}
