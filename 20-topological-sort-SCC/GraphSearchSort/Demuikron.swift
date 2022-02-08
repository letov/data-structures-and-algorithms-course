//
//  Demuikron.swift
//  GraphSearchSort
//
//  Created by руслан карымов on 31.01.2022.
//

import Foundation

class AdjacencyVectorDemuikron: AdjacencyVectorDirectGraph {
    func inDegreeArray() -> [Int] {
        return (0..<vertexVertors.count).reduce(into: []) { result, vertex in
            result.append(vertexInDegree(vertex: vertex))
        }
    }
    func demuikronSort() -> [[Int]] {
        var result  = [[Int]]()
        var inArray: [Int] = inDegreeArray()
        var inZeroVertexes = [Int]()
        repeat {
            inZeroVertexes = inArray.enumerated().reduce(into: [Int]()) { acc, elem in
                if elem.element == 0 {
                    acc.append(elem.offset)
                    inArray[elem.offset] -= 1
                }
            }
            inZeroVertexes.forEach { inZeroVertex in
                vertexVertors[inZeroVertex].forEach { excludeVertex in
                    inArray[excludeVertex] -= 1
                }
            }
            result.append(inZeroVertexes)
        } while inZeroVertexes.count > 0
        return result
    }
}

