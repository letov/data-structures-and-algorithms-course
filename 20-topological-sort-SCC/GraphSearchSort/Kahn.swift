//
//  Kahn.swift
//  GraphSearchSort
//
//  Created by руслан карымов on 27.01.2022.
//

import Foundation

class EdgeListKhan: EdgeListDirectGraph {
    var khanTopologicalSort = Array<String>()
    func khanSort() {
        if edgeVectors.isEmpty {
            return
        }
        for edge in edgeVectors {
            let vertex = edge.vector.vertex1
            if isSourceVertex(vertex: vertex) {
                khanTopologicalSort.append(vertex)
                // проверка на изолированные вершины перед удалением
                for av in getAdjacentVertex(vertex: vertex) {
                    if vertexInDegree(vertex: av) == 1 && isSinkVertex(vertex: av) {
                        khanTopologicalSort.append(av)
                    }
                }
                removeVertex(vertex: vertex)
                break
            }
        }
        khanSort()
    }
}

