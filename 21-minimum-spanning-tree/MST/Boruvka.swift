//
//  Boruvka.swift
//  MST
//
//  Created by руслан карымов on 09.02.2022.
//

import Foundation

class EdgeListBoruvka: EdgeListKruskal {
    var parent = [String: String]()
    func initParent() {
        for vertex in vertexSet {
            parent[vertex] = vertex
        }
    }
    func findParent(vertex: String) -> String {
        if parent[vertex] == vertex {
            return vertex
        }
        parent[vertex] = findParent(vertex: parent[vertex]!)
        return parent[vertex]!
    }
    func merge(vertex1: String, vertex2: String) {
        let root1 = findParent(vertex: vertex1)
        let root2 = findParent(vertex: vertex2)
        if root1 == root2 {
            return
        }
        parent[root1] = root2
    }
    func boruvkaMST() -> EdgeList {
        initParent()
        let graph = EdgeList()
        let edgeList = getEdgeListSorted()
        for edge in edgeList {
            let vertex1 = edge.0
            let vertex2 = edge.1
            let weight = edge.2
            if findParent(vertex: vertex1) == findParent(vertex: vertex2) {
                continue
            }
            merge(vertex1: vertex1, vertex2: vertex2)
            graph.addEdge(vertex1: vertex1, vertex2: vertex2, edge: EdgeWieght(weight: weight))
        }
        return graph
    }
}
