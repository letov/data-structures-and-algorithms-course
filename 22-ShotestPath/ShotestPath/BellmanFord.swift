//
//  BellmanFord.swift
//  ShotestPath
//
//  Created by руслан карымов on 09.02.2022.
//

import Foundation

class BellmanFordGraph: EdgeListDirectGraph {
    func bellmanFordShotPaths(vertex: String) -> [String: Int] {
        var result = [String: Int]()
        for _vertex in vertexSet {
            if vertex == _vertex {
                result[_vertex] = 0
            } else {
                result[_vertex] = 999
            }
        }
        for _ in vertexSet {
            for edge in edgeVectors {
                if result[edge.vector.vertex2]! > result[edge.vector.vertex1]! + (edge.edge as! EdgeWieght).weight {
                    result[edge.vector.vertex2] = result[edge.vector.vertex1]! + (edge.edge as! EdgeWieght).weight
                }
            }
        }
        return result
    }
}
