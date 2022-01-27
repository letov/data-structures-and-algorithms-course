//
//  BitboardGraph.swift
//  Graphs
//
//  Created by руслан карымов on 26.01.2022.
//

import Foundation

// Y bb                Y bbArray
// 2                   2 BB[2][0] BB[2][1] BB[2][2]
// 1 8 9 . . .         1 BB[1][0] BB[1][1] BB[1][2]
// 0 0 1 2 3 4 5 6 7   0 BB[0][0] BB[0][1] BB[0][2] bbArrayRow
//   0 1 2 3 4 5 6 7 X         0        1        2  X 
// bidirection edge without name

// O(Mem) = ceil(N / 8) ^ 2 Uint64

struct BitboardGraph {
    var vertexCount = Int()
    typealias BbArrayRow = Array<UInt>
    var bbArray = Array<BbArrayRow>()
    var bbArrayAxisSize: Int {
        return Int(ceil(Double(vertexCount) / 8.0))
    }
    mutating func bbArrayResize() {
        if bbArrayAxisSize > bbArray.count {
            bbArray.enumerated().forEach {
                bbArray[$0.offset].append(0)
            }
            bbArray.append(BbArrayRow.init(repeating: 0, count: bbArray.count + 1))
        }
    }
    func getBBCoord(vertex: Int) -> (bbArrayOffset: Int, bbOffset: Int) {
        let bbArrayOffset = Int(floor(Double(vertex) / 8.0))
        let bbOffset = vertex % 8
        return (bbArrayOffset: bbArrayOffset, bbOffset: bbOffset)
    }
    func genBitMask(bbX: Int, bbY: Int) -> UInt {
        return (UInt(1) << bbX) << (8 * bbY)
    }
    mutating func setBit(bbArrayX: Int, bbArrayY: Int, bbX: Int, bbY: Int) {
        let mask = genBitMask(bbX: bbX, bbY: bbY)
        bbArray[bbArrayY][bbArrayX] |= mask
    }
    mutating func addVertex(vertex: Int) {
        guard !hasVertex(vertex: vertex) else {
            return
        }
        vertexCount += 1
        bbArrayResize()
    }
    func hasVertex(vertex: Int) -> Bool {
        return vertexCount > vertex
    }
    mutating func addEdge(vertex1: Int, vertex2: Int) {
        guard !hasEdge(vertex1: vertex1, vertex2: vertex2) else {
            return
        }
        addVertex(vertex: vertex1)
        addVertex(vertex: vertex2)
        let getBBCoord1 = getBBCoord(vertex: vertex1)
        let getBBCoord2 = getBBCoord(vertex: vertex2)
        setBit(bbArrayX: getBBCoord1.bbArrayOffset, bbArrayY: getBBCoord2.bbArrayOffset, bbX: getBBCoord1.bbOffset, bbY: getBBCoord2.bbOffset)
        setBit(bbArrayX: getBBCoord2.bbArrayOffset, bbArrayY: getBBCoord1.bbArrayOffset, bbX: getBBCoord2.bbOffset, bbY: getBBCoord1.bbOffset)
    }
    func hasEdge(vertex1: Int, vertex2: Int) -> Bool {
        let getBBCoord1 = getBBCoord(vertex: vertex1)
        let getBBCoord2 = getBBCoord(vertex: vertex2)
        guard bbArray.count > getBBCoord1.bbArrayOffset else {
            return false
        }
        let bb1 = bbArray[getBBCoord2.bbArrayOffset][getBBCoord1.bbArrayOffset]
        let bb2 = bbArray[getBBCoord1.bbArrayOffset][getBBCoord2.bbArrayOffset]
        let mask1 = UInt(1) << (getBBCoord1.bbOffset + (8 * getBBCoord2.bbOffset))
        let mask2 = UInt(1) << (getBBCoord2.bbOffset + (8 * getBBCoord1.bbOffset))
        return (bb1 & mask1 > 0) && (bb2 & mask2 > 0)
    }
    func printTable() {
        let head = (0...(vertexCount - 1)).reduce("") { acc, vertex in
            let cell = "|   \(vertex)   |"
            return acc + cell
        }
        print("  |\(head)|")
        (0...(vertexCount - 1)).forEach { vertex1 in
            var row = ""
            (0...(vertexCount - 1)).forEach { vertex2 in
                var cell = hasEdge(vertex1: vertex1, vertex2: vertex2) ? "+" : " "
                cell = vertex1 == vertex2 ? "X" : cell
                row += "|   \(cell)   |"
            }
            print("\(vertex1) |\(row)| \(vertex1)")
        }
        print("  |\(head)|")
    }
    func bitCnt(bb: UInt) -> Int {
        var cnt = Int()
        var mask = bb
        while mask > 0 {
            mask &= mask - 1
            cnt += 1
        }
        return cnt
    }
    func vertexDegree(vertex: Int) -> Int? {
        guard vertexCount > vertex else {
            return nil
        }
        let getBBCoord = getBBCoord(vertex: vertex)
        let bbRows = bbArray[getBBCoord.bbArrayOffset]
        let mask: UInt = 0xFF << (getBBCoord.bbOffset * 8)
        var vertexCount = 0
        for bbRow in bbRows {
            let edgeBits = bbRow & mask
            vertexCount += bitCnt(bb: edgeBits)
        }
        return vertexCount
    }
    func getAdjacentVertex(vertex: Int) -> [Int] {
        guard vertexCount > vertex else {
            return []
        }
        let getBBCoord = getBBCoord(vertex: vertex)
        let bbRows = bbArray[getBBCoord.bbArrayOffset]
        let horMask: UInt = 0xFF << (getBBCoord.bbOffset * 8)
        let vertMask: UInt = 0x101010101010101
        var result = [Int]()
        for bbRow in bbRows.enumerated() {
            let edgeBits = bbRow.element & horMask
            for i in 0...7 {
                if edgeBits & (vertMask << i) > 0 {
                    let vertex = i + (bbRow.offset * 7)
                    result.append(vertex)
                }
            }
        }
        return result
    }
    mutating func removeVertex(vertex: Int) {
        
    }
    mutating func removeEdge(vertex1: Int, vertex2: Int) {
        
    }
}

