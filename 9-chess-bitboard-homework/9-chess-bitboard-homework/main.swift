//
//  main.swift
//  9-chess-bitboard-homework
//
//  Created by руслан карымов on 16.11.2021.
//

import Foundation

class Chess: iTask {
    
    enum Direction {
        case up, right, down, left
        case upRight, downRight, downLeft, upLeft
        
        static let allVertical: Set<Direction> = [.up, .right, .down, .left]
        static let allDiagonal: Set<Direction> = [.upRight, .downRight, .downLeft, .upLeft]
        static let all: Set<Direction> = allVertical.union(allDiagonal)
    }
    
    let noA: UInt = 0xfefefefefefefefe
    let noH: UInt = 0x7f7f7f7f7f7f7f7f
    let noAB: UInt = 0xfcfcfcfcfcfcfcfc
    let noGH: UInt = 0x3f3f3f3f3f3f3f3f
    let bbSize: Int = 8
    
    var position: Int = 0
    var bb: UInt { 1 << position }

    func run(_ data: [String]) -> [String] {
        guard let position = Int(data[0]) else {
            return []
        }
        self.position = position
        //let result = kingMove()
        let result = horseMove()
        //let result = rookMove()
        //let result = elepMove()
        //let result = queenMove()
        return packResult(result)
    }
    
    func kingMove() -> UInt {
        return move(Direction.all, 1)
    }
    
    func rookMove() -> UInt {
        return move(Direction.allVertical, bbSize)
    }
    
    func elepMove() -> UInt {
        return move(Direction.allDiagonal, bbSize)
    }
    
    func queenMove() -> UInt {
        return move(Direction.all, bbSize)
    }
    
    func horseMove() -> UInt {
        let left = (bb & noAB) >> 2
        let right = (bb & noGH) << 2
        let horiz = left << bbSize | left >> bbSize | right << bbSize | right >> bbSize
        let up = bb << 16
        let down = bb >> 16
        let vert = (up & noH) << 1 | (up & noA) >> 1 | (down & noH) << 1 | (down & noA) >> 1
        return horiz | vert
    }

    func packResult(_ mask: UInt) -> [String] {
        var cnt = Int()
        var _mask = mask
        while _mask > 0 {
            _mask &= _mask - 1
            cnt += 1
        }
        return [String(cnt), String(mask)]
    }

    func step(_ mask: UInt, _ dir: Direction) -> UInt {
        let maskA: UInt = mask & noA
        let maskH: UInt = mask & noH
        var result: UInt = 0
        switch dir {
        case .up:
            result = mask << bbSize
        case .right:
            result = maskH << 1
        case .down:
            result = mask >> bbSize
        case .left:
            result = maskA >> 1
        case .upRight:
            result = (maskH << bbSize) << 1
        case .downRight:
            result = (maskH >> bbSize) << 1
        case .downLeft:
            result = (maskA >> bbSize) >> 1
        case .upLeft:
            result = (maskA << bbSize) >> 1
        }
        return result
    }
    
    func move(_ dirs: Set<Direction>, _ cnt: Int) -> UInt {
        return dirs.reduce(into: 0) { $0 |= moveNext(bb, $1, cnt) ^ bb }
    }
    
    func moveNext(_ mask: UInt, _ dir: Direction, _ cnt: Int) -> UInt {
        if cnt < 0 {
            return 0
        }
        let step = step(mask, dir)
        return mask | moveNext(step, dir, cnt - 1)
    }

}

let chess = Chess()
let tester = Tester(path: "/Users/ruslankarymov/Desktop/0.BITS/2.Bitboard", task: chess)
tester.runTests()
