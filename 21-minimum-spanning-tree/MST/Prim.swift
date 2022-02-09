//
//  Prim.swift
//  MST
//
//  Created by руслан карымов on 08.02.2022.
//

import Foundation

class LinkedGraphPrim: LinkedGraph {
    func getAdjacentEdgeAndVertex(vertex: String) -> [(String, Edge)] {
        guard let vertex = findVertex(vertex: vertex, from: head) else {
            return []
        }
        var result = [(String, Edge)]()
        enumLinked(from: vertex.edgeHead) { next in
            result.append(((next as! EdgeListGraph).vertex.name, (next as! EdgeListGraph).edge))
        }
        return result
    }
    func addVertexTopPrimMST(graph: LinkedGraph) {
        var minWeight = Int.max
        var startVertex = ""
        var endVertex = ""
        enumLinked(from: graph.head) { next in
            let vertex = (next as! VertexListGraph).name
            let edges = getAdjacentEdgeAndVertex(vertex: vertex)
            for (_vertex, edge) in edges {
                if graph.hasVertex(vertex: _vertex) {
                    continue
                }
                if minWeight > (edge as! EdgeWieght).weight {
                    minWeight = (edge as! EdgeWieght).weight
                    startVertex = (next as! VertexListGraph).name
                    endVertex = _vertex
                }
            }
        }
        if endVertex == "" {
            return
        }
        graph.addEdge(vertex1: startVertex, vertex2: endVertex, edge: EdgeWieght(weight: minWeight))
        addVertexTopPrimMST(graph: graph)
    }
    func primMST(vertex: String) -> LinkedGraph {
        let graph = LinkedGraph()
        graph.addVertex(vertex: vertex)
        addVertexTopPrimMST(graph: graph)
        return graph
    }
}
