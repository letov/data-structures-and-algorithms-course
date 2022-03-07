//
//  Elka.swift
//  Dynamic
//
//  Created by руслан карымов on 07.03.2022.
//

import Foundation

class Elka {
    var tree: [[Int]]
    var n: Int
    init(n: Int) {
        tree = [[Int]].init(repeating: [Int].init(repeating: 0, count: n), count: n)
        for i in 0..<n {
            for j in 0...i {
                tree[i][j] = Int.random(in: 1...n)
            }
        }
        self.n = n
    }
    func maxPathSum() -> Int {
        for i in (0...(n - 2)).reversed() {
            for j in 0...i {
                tree[i][j] += max(tree[i + 1][j], tree[i + 1][j + 1])
            }
            print(tree)
        }
        return tree[0][0]
    }
}
