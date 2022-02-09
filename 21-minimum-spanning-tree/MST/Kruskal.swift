//
//  Kruskal.swift
//  MST
//
//  Created by руслан карымов on 09.02.2022.
//

import Foundation

class EdgeListDFS: EdgeList {
    var connectivity = [String]()
    func DFS(vertex: String) {
        if connectivity.contains(vertex) {
            return
        }
        connectivity.append(vertex)
        let vertexes = getAdjacentVertex(vertex: vertex)
        for vertex in vertexes {
            DFS(vertex: vertex)
        }
       
    }
}

class EdgeListKruskal: EdgeList {
    func getEdgeListSorted() -> [(String, String, Int)] {
        var _edgeVectors = edgeVectors
        var result = [(String, String, Int)]()
        while _edgeVectors.count > 0 {
            var minWeight = Int.max
            var i = 0
            for (index, edge) in _edgeVectors.enumerated() {
                let weight = (edge.edge as! EdgeWieght).weight
                if minWeight >= weight {
                    minWeight = weight
                    i = index
                }
            }
            result.append((_edgeVectors[i].vector.vertex1, _edgeVectors[i].vector.vertex2, minWeight))
            _edgeVectors.remove(at: i)
        }
        return result
    }
    func kruskalMST() -> EdgeList {
        let graph = EdgeListDFS()
        let edgeList = getEdgeListSorted()
        for edge in edgeList {
            let vertex1 = edge.0
            let vertex2 = edge.1
            let weight = edge.2
            graph.connectivity = []
            graph.DFS(vertex: vertex1)
            if !graph.connectivity.contains(vertex2) {
                graph.addEdge(vertex1: vertex1, vertex2: vertex2, edge: EdgeWieght(weight: weight))
            }
        }
        return graph
    }
}
