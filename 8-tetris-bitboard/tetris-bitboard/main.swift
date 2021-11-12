//
//  main.swift
//  tetris-bitboard
//
//  Created by руслан карымов on 11.11.2021.
//

import Foundation
import ANSITerminal

class RotateFigure {
    
    static func flipBBDiagonal(_ inBb: UInt64) -> UInt64 {
        var t: UInt64
        let k1: UInt64 = 0x5500550055005500
        let k2: UInt64 = 0x3333000033330000
        let k4: UInt64 = 0x0f0f0f0f00000000
        var bb = inBb
        t  = k4 & (bb ^ (bb << 28));
        bb ^=       t ^ (t >> 28) ;
        t  = k2 & (bb ^ (bb << 14));
        bb ^=       t ^ (t >> 14) ;
        t  = k1 & (bb ^ (bb <<  7));
        bb ^=       t ^ (t >>  7) ;
        return bb
    }

    static func flipBBVertical(_ inBb: UInt64) -> UInt64 {
        return  ( (inBb << 56)                      ) |
                ( (inBb << 40) & 0x00ff000000000000 ) |
                ( (inBb << 24) & 0x0000ff0000000000 ) |
                ( (inBb <<  8) & 0x000000ff00000000 ) |
                ( (inBb >>  8) & 0x00000000ff000000 ) |
                ( (inBb >> 24) & 0x0000000000ff0000 ) |
                ( (inBb >> 40) & 0x000000000000ff00 ) |
                ( (inBb >> 56) );
    }

    static func rotate(_ inBb: UInt64) -> UInt64 {
        return flipBBVertical(flipBBDiagonal(inBb))
    }
}

class Game {
    var key: ANSIKeyCode = .none
    let timeout = 500
    
    // BIN DATA
    let size = 8
    let buttomRow: UInt64 = 0xff00000000000000
    let rightCol: UInt64 = 0x8080808080808080
    let leftCol: UInt64 = 0x101010101010101
    let upRow: UInt64 = 0x00000000000000ff
    let defaultRotateCenterBB: UInt64 = 8
    let figures: [UInt64] = [2076,2072,1052,28]
    // BIN DATA

    // BITBOARDS
    var mainBB: UInt64 = 0
    var actionBB: UInt64 = 0
    var actionRotateCenterBB: UInt64 = 0
    // BITBOARDS
    
    var time = DispatchTime.now()
    
    enum Direction {
        case leftDir, rightDir, downDir
    }
    
    init() {
        newGame()
        
        //
        var pause = true
        
        while true {
            (key, _) = readKey()
            switch key {
            //
            case .f2:
                pause = false
            case .f1:
                exit(0)
            case .up:
                rotate()
            case .down:
                move(.downDir)
            case .left:
                move(.leftDir)
            case .right:
                move(.rightDir)
            default:
                break
            }
            //
            if pause {
                continue
            }
            if Int((DispatchTime.now().uptimeNanoseconds - time.uptimeNanoseconds) / 1000000) > timeout {
                time = DispatchTime.now()
                move(.downDir)
            }
        }
    }

    func rotate() {
        var newActionBB = RotateFigure.rotate(actionBB)
        let newActionRotateCenterBB = RotateFigure.rotate(actionRotateCenterBB)
        let centerOffset = String(newActionRotateCenterBB, radix: 2).count - String(actionRotateCenterBB, radix: 2).count
        newActionBB = centerOffset < 0 ?
        newActionBB << abs(centerOffset) :
        newActionBB >> abs(centerOffset)
        if (!checkCollisionRotate(newActionBB)) {
            drawBitboard(actionBB, .black)
            actionBB = newActionBB
            updateScreen()
        }
    }
    
    func popCnt(_ bb: UInt64) -> Int {
        var cnt = Int()
        var mask = bb
        while mask > 0 {
            mask &= mask - 1
            cnt += 1
        }
        return cnt
    }
    
    func checkCollisionRotate(_ futureActionBB: UInt64) -> Bool {
        return (futureActionBB & mainBB) > 0
        || ((futureActionBB & leftCol) > 0 && (futureActionBB & rightCol) > 0)
        || ((futureActionBB & upRow) > 0 && popCnt(futureActionBB) != popCnt(actionBB))
        || ((futureActionBB & buttomRow) > 0 && popCnt(futureActionBB) != popCnt(actionBB))
    }
    
    func step(_ dir: Direction, _ from: inout UInt64) {
        switch dir {
        case .downDir:
            from <<= size
        case .leftDir:
            from >>= 1
        case .rightDir:
            from <<= 1
        }
    }
    
    func burnRow() {
        var checkLine = buttomRow
        for _ in 1...size {
            if (popCnt(checkLine & mainBB) == size) {
                drawBitboard(mainBB, .black)
                mainBB <<= size
            }
            checkLine >>= size
        }
    }
    
    func move(_ dir: Direction) {
        if checkCollisionMove(dir) {
            if (dir == .downDir) {
                mainBB |= actionBB
                burnRow()
                if !newFigure() {
                    newGame()
                }
            }
        } else {
            drawBitboard(actionBB, .black)
            step(dir, &actionBB)
            step(dir, &actionRotateCenterBB)
            updateScreen()
        }
    }
    
    func newGame() {
        mainBB = 0
        actionBB = 0
        initScreen()
        _ = newFigure()
        time = DispatchTime.now()
    }

    func checkCollisionMove(_ dir: Direction) -> Bool {
        var futureActionBB = actionBB
        step(dir, &futureActionBB)
        var result = (futureActionBB & mainBB) > 0
        switch dir {
        case .downDir:
            result = result || (actionBB & buttomRow) > 0
        case .leftDir:
            result = result || (actionBB & leftCol) > 0
            break
        case .rightDir:
            result = result || (actionBB & rightCol) > 0
            break
        }
        return result
    }

    func newFigure() -> Bool {
        actionBB = figures.randomElement()!
        actionRotateCenterBB = defaultRotateCenterBB
        updateScreen()
        return (actionBB & mainBB) == 0
    }

    func updateScreen() {
        drawBitboard(actionBB, .green)
        drawBitboard(mainBB, .red)
    }
    
    func drawBitboard(_ bitboard: UInt64, _ clr: ANSIAttr = .default) {
        var display = [[Int]].init(repeating: [Int].init(repeating: 0, count: size), count: size)
        var iterator = String(bitboard, radix: 2).reversed().makeIterator()
        display = display.map { $0.compactMap { _ in Int(String(iterator.next() ?? "0")) } }
        display.enumerated().forEach { rowIndex, row in
            row.enumerated().forEach { colIndex, pixel in
                if (pixel == 1) {
                    drawPoint(rowIndex + 2, colIndex + 2, "0", clr)
                }
            }
        }
    }
    
    func drawPoint(_ row: Int, _ col: Int, _ val: String, _ clr: ANSIAttr = .default) {
        setColor(fore: clr)
        moveTo(row, col)
        write(val)
    }
    
    func initScreen() {
        cursorOff()
        clearScreen()
        drawGameZone()
    }
    
    func drawGameZone() {
        for i in 1...(size + 2) {
            for j in 1...(size + 2) {
                drawPoint(i, j, "0", .black)
            }
        }
        for i in 1...(size + 2) {
            drawPoint(1, i, "#", .yellow)
            drawPoint(size + 2, i, "#", .yellow)
            drawPoint(i, 1, "#", .yellow)
            drawPoint(i, size + 2, "#", .yellow)
        }
        drawPoint(1, size + 4, "arrows - control", .white)
        drawPoint(2, size + 4, "f1 - exit", .white)
    }
}

_ = Game()
