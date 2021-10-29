//
//  main.swift
//  1-recursion-BFS-DLS
//
//  Created by руслан карымов on 29.10.2021.
//

import Foundation

class Paint {
    var map: [[Int]]
    let w, h: Int
    
    init(_ w: Int, _ h: Int) {
        self.w = w
        self.h = h
        map = [[Int]].init(repeating: [Int].init(repeating: 0, count: w), count: h)
    }
    
    func fillLine(){
        setMap(1, 0, 1)
    }
    
    func setMap(_ x: Int, _ y: Int, _ v: Int) {
        map[x][y] = v
    }
}

print(1)
_ = readLine()
