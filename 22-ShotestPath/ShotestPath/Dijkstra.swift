//
//  Dijkstra.swift
//  ShotestPath
//
//  Created by руслан карымов on 09.02.2022.
//

import Foundation

class DijkstraGraph: EdgeList {
    func minVertexPath(vertexes: [String: Int]) -> (String, Int) {
        return vertexes.reduce(into: vertexes.first!) {
            $0 = $0.value < $1.value ? $0 : $1
        }
    }
    func getAdjacentVertexAndEdge(vertex: String) -> [(String, Edge)] {
        var result = [(String, Edge)] ()
        cycleEdges(vertex: vertex) { edge in
            let edge = edge as! EdgeVector
            if edge.vector.vertex1 == vertex {
                result.append((edge.vector.vertex2, edge.edge))
            } else {
                result.append((edge.vector.vertex1, edge.edge))
            }
        }
        return result
    }
    func dijkstraShotPaths(vertex: String) -> [String: Int] {
        var result = [String: Int]()
        var matrix = [String: Int]()
        for _vertex in vertexSet {
            if vertex == _vertex {
                matrix[_vertex] = 0
            } else {
                matrix[_vertex] = 999
            }
        }
        while !matrix.isEmpty {
            let minPath = minVertexPath(vertexes: matrix)
            let currentVertex = minPath.0
            let currentWeight = minPath.1
            matrix.remove(at: matrix.index(forKey: currentVertex)!)
            result[currentVertex] = currentWeight
            let vertexes = getAdjacentVertexAndEdge(vertex: currentVertex)
            for (vertex, edge) in vertexes {
                if matrix.index(forKey: vertex) == nil {
                    continue
                }
                let weight = (edge as! EdgeWieght).weight + currentWeight
                matrix[vertex] = min(matrix[vertex]!, weight)
            }
        }
        return result
    }
}
