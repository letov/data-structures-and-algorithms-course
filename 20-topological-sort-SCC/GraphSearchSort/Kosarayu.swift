//
//  Kosarayu.swift
//  GraphSearchSort
//
//  Created by руслан карымов on 07.02.2022.
//

import Foundation

class AdjacencyVectorKosarayu: AdjacencyVectorTarjan {
    func invertDirection() {
        let old = vertexVertors
        vertexVertors = [[Int]].init(repeating: [], count: old.count)
        for (vertex, outVertexes) in old.enumerated() {
            for outVertex in outVertexes {
                vertexVertors[outVertex].append(vertex)
            }
        }
    }
    func kosarayuSCC() -> [[Int]] {
        invertDirection()
        let tarjanList = tarjanSort()
        invertDirection()
        black = [Int]()
        gray = [Int]()
        var result = [[Int]]()
        for vertex in tarjanList {
            let oldBlack = black
            DFS(vertex: vertex)
            if oldBlack.count != black.count {
                result.append(Array(black[oldBlack.count..<black.count]))
            }
        }
        return result
    }
}
