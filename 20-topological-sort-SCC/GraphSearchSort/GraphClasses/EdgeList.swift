//
//  AdjacencyVector.swift
//  GraphSearchSort
//
//  Created by руслан карымов on 31.01.2022.
//

import Foundation

class EdgeList: Graph {
    var vertexSet = Set<String>()
    typealias EdgeVector = (vector: (vertex1: String, vertex2: String), edge: Edge)
    var edgeVectors = Array<EdgeVector>()
    func addVertex(vertex: String) {
        if hasVertex(vertex: vertex) {
            return
        }
        vertexSet.insert(vertex)
    }
    func hasVertex(vertex: String) -> Bool {
        return vertexSet.contains(vertex)
    }
    func addEdge(vertex1: String, vertex2: String, edge: Edge) {
        guard !hasEdge(vertex1: vertex1, vertex2: vertex2) else {
            return
        }
        addVertex(vertex: vertex1)
        addVertex(vertex: vertex2)
        edgeVectors.append(((vertex1, vertex2), edge))
    }
    func edgeContain(vertex: String, edgeVector: EdgeVector) -> Bool {
        return edgeVector.vector.vertex1 == vertex || edgeVector.vector.vertex2 == vertex
    }
    func edgeContainBoth(vertex1: String, vertex2: String, edgeVector: EdgeVector) -> Bool {
        return (edgeVector.vector.vertex1 == vertex1 && edgeVector.vector.vertex2 == vertex2) ||
                (edgeVector.vector.vertex1 == vertex2 && edgeVector.vector.vertex2 == vertex1)
    }
    func cycleEdges(vertex: String, f: (Any) -> ()) {
        for edgeVector in edgeVectors {
            if edgeContain(vertex: vertex, edgeVector: edgeVector) {
                f(edgeVector)
            }
        }
    }
    func hasEdge(vertex1: String, vertex2: String) -> Bool {
        for edgeVector in edgeVectors {
            if edgeContainBoth(vertex1: vertex1, vertex2: vertex2, edgeVector: edgeVector) {
                return true
            }
        }
        return false
    }
    func vertexDegree(vertex: String) -> Int {
        var degree = 0
        cycleEdges(vertex: vertex) { edge in
            degree += 1
        }
        return degree
    }
    func getAdjacentEdge(vertex: String) -> [Edge] {
        var result = [Edge]()
        cycleEdges(vertex: vertex) { edge in
            let edge = edge as! EdgeVector
            result.append(edge.edge)
        }
        return result
    }
    func getAdjacentVertex(vertex: String) -> [String] {
        var result = [String]()
        cycleEdges(vertex: vertex) { edge in
            let edge = edge as! EdgeVector
            if edge.vector.vertex1 == vertex {
                result.append(edge.vector.vertex2)
            } else {
                result.append(edge.vector.vertex1)
            }
        }
        return result
    }
    func printTable() {
        let halfOffset = "   "
        edgeVectors.enumerated().forEach { (edgeNum, arg) in
            let ((vertex1, vertex2), _) = arg
            print("|\(halfOffset)\(edgeNum)\(halfOffset)|\(halfOffset)\(vertex1)\(halfOffset)|\(halfOffset)\(vertex2)\(halfOffset)|")
        }
    }
    func removeVertex(vertex: String) {
        edgeVectors = edgeVectors.filter { arg in
            let ((vertex1, vertex2), _) = arg
            return vertex != vertex1 && vertex != vertex2
        }
    }
    func removeEdge(vertex1: String, vertex2: String) {
        
    }
}

class EdgeListDirectGraph: EdgeList & DirectedGraph {
    override func addEdge(vertex1: String, vertex2: String, edge: Edge) {
        guard !hasEdge(vertex1: vertex1, vertex2: vertex2) else {
            return
        }
        addVertex(vertex: vertex1)
        edgeVectors.append(((vertex1, vertex2), edge))
    }
    func vertexInDegree(vertex: String) -> Int {
        return edgeVectors.reduce(0) {
            $0 + ($1.vector.vertex2 == vertex ? 1 : 0)
        }
    }
    func vertexOutDegree(vertex: String) -> Int {
        return edgeVectors.reduce(0) {
            $0 + ($1.vector.vertex1 == vertex ? 1 : 0)
        }
    }
    func isSourceVertex(vertex: String) -> Bool {
        return vertexInDegree(vertex: vertex) == 0
    }
    func isSinkVertex(vertex: String) -> Bool {
        return vertexOutDegree(vertex: vertex) == 0
    }
}
