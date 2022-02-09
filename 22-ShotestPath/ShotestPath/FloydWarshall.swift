//
//  FloydWarshall.swift
//  ShotestPath
//
//  Created by руслан карымов on 09.02.2022.
//

import Foundation

class FloydWarshallGraph: EdgeListDirectGraph {
    func initMatrix(_ result: inout [[Int]]) {
        for (i, vertex1) in vertexSet.enumerated() {
            for (j, vertex2) in vertexSet.enumerated() {
                if i == j {
                    result[i][j] = 0
                }
                if let edge = getEdge(vertex1: vertex1, vertex2: vertex2) {
                    result[i][j] = (edge as! EdgeWieght).weight
                }
             }
        }
    }
    func printMatrix(_ result: [[Int]]) {
        let halfOffset = "   "
        var head = "\(halfOffset)      \(halfOffset)"
        vertexSet.forEach {
            head += "|\(halfOffset)\($0.padding(toLength: 5, withPad: " ", startingAt: 0))\(halfOffset)"
        }
        print("\(head)|")
        for (i, vertex1) in vertexSet.enumerated() {
            var row = "|\(halfOffset)\(vertex1.padding(toLength: 5, withPad: " ", startingAt: 0))\(halfOffset)"
            for (j, _) in vertexSet.enumerated() {
                row += "|\(halfOffset)\(String(result[i][j]).padding(toLength: 5, withPad: " ", startingAt: 0))\(halfOffset)"
            }
            print("\(row)|")
        }
        
    }
    func floydWarshallShotPaths() -> [[Int]] {
        var result = [[Int]].init(repeating: [Int].init(repeating: 999, count: vertexSet.count), count: vertexSet.count)
        initMatrix(&result)
        for (k, _) in vertexSet.enumerated() {
            for (i, _) in vertexSet.enumerated() {
                if k == i {
                    continue
                }
                for (j, _) in vertexSet.enumerated() {
                    if k == j || i == j {
                        continue
                    }
                    result[i][j] = min(result[i][k] + result[k][j],result[i][j])
                }
            }
        }
        return result
    }
}

