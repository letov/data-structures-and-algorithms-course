//
//  main.swift
//  1-recursion-BFS-DLS
//
//  Created by руслан карымов on 29.10.2021.
//

import Foundation
import ANSITerminal

class Paint {
    var map: [[Int]]
    let w, h: Int
    struct symbols {
        static let shared = symbols()
        let chars = [" ","#","<",">","^","v","x"]
        let colors = [
            ANSIAttr.white,
            ANSIAttr.blue,
            ANSIAttr.yellow,
            ANSIAttr.yellow,
            ANSIAttr.yellow,
            ANSIAttr.yellow,
            ANSIAttr.cyan
        ]
    }
    
    init(_ w: Int, _ h: Int) {
        self.w = w
        self.h = h
        map = [[Int]].init(repeating: [Int].init(repeating: 0, count: h), count: w)
    }
    
    func addRandomPixels(_ cnt: Int) {
        for _ in 0..<cnt {
            setMap(Int.random(in: 0..<w), Int.random(in: 0..<h), 1)
        }
    }
    
    func fillLine() {
        for x in 0..<self.w {
            setMap(x, 0, 1)
        }
    }
    
    func fillBox() {
        for x in 0..<self.w {
            for y in 0..<self.h {
                setMap(x, y, 1)
            }
        }
    }
    
    func fillLineR(_ x: Int) {
        if x >= w {
            return
        }
        setMap(x, 0, 1)
        fillLineR(x + 1)
    }
    
    // Depth-first search, DFS, Поиск в глубину через рекурсию
    func fillBoxR(_ x: Int, _ y: Int, _ v: Int) {
        if !isEmpty(x, y) {
            return
        }
        setMap(x, y, v)
        _ = readLine()
        //Thread.sleep(forTimeInterval: 0.5)
        fillBoxR(x - 1, y, 2)
        fillBoxR(x + 1, y, 3)
        fillBoxR(x, y + 1, 5)
        fillBoxR(x, y - 1, 4)
        setMap(x, y, 6)
    }
    
    
    // Depth-first search, DFS, Поиск в глубину через Stack
    struct CoordStack {
        private var coords: [(Int, Int)] = []

        mutating func push(_ coord: (Int, Int)) {
            coords.append(coord)
        }
        
        mutating func pop() -> (Int, Int)? {
            return coords.popLast()
        }
    }
    
    func fillBoxStack(_ x: Int, _ y: Int) {
        var coordStack = CoordStack()
        coordStack.push((x, y))
        
        func push(_ a: Int, _ b: Int, _ c: Int) {
            if !isEmpty(a, b) {
                return
            }
            setMap(a, b, c)
            coordStack.push((a, b))
        }
        
        while let coord = coordStack.pop() {
            setMap(coord.0, coord.1, 6)
            push(coord.0 - 1, coord.1, 2)
            push(coord.0 + 1, coord.1, 3)
            push(coord.0, coord.1 - 1, 4)
            push(coord.0, coord.1 + 1, 5)
            _ = readLine()
        }
    }
    
    // Breadth-first search, BFS, Поиск в ширину через очередь
    struct CoordQueue {
        private var coords: [(Int, Int)] = []

        mutating func enqueue(_ coord: (Int, Int)) {
            coords.append(coord)
        }
        
        mutating func dequeue() -> (Int, Int)? {
            return coords.removeFirst()
        }
    }
    
    func fillBoxQueue(_ x: Int, _ y: Int) {
        var coordQueue = CoordQueue()
        coordQueue.enqueue((x, y))
        
        func enqueue(_ a: Int, _ b: Int, _ c: Int) {
            if !isEmpty(a, b) {
                return
            }
            setMap(a, b, c)
            coordQueue.enqueue((a, b))
        }
        
        while let coord = coordQueue.dequeue() {
            setMap(coord.0, coord.1, 6)
            enqueue(coord.0 - 1, coord.1, 2)
            enqueue(coord.0 + 1, coord.1, 3)
            enqueue(coord.0, coord.1 - 1, 4)
            enqueue(coord.0, coord.1 + 1, 5)
            _ = readLine()
        }
    }
    
    func isEmpty(_ x: Int, _ y: Int) -> Bool {
        if x < 0 || x >= w {
            return false
        }
        if y < 0 || y >= h {
            return false
        }
        return map[x][y] == 0
    }
    
    func setMap(_ x: Int, _ y: Int, _ v: Int) {
        map[x][y] = v
        moveTo(y + 1, x + 1)
        write(String(symbols.shared.chars[v]))
        setColor(fore: symbols.shared.colors[v])
    }
}

clearScreen()
var paint = Paint(50, 20)
paint.addRandomPixels(200)
//paint.fillBoxR(25, 10, 2)
paint.fillBoxStack(25, 10)
//paint.fillBoxQueue(25, 10)
_ = readCode()
