//
//  AdjacencyVector.swift
//  Graphs
//
//  Created by руслан карымов on 27.01.2022.
//

import Foundation

struct AdjacencyVector: Graph {
    var vertexSet = Set<String>()
    typealias EdgeVector = (vector: (vertex1: String, vertex2: String), edge: Edge)
    var edgeVectors = Array<EdgeVector>()
    mutating func addVertex(vertex: String) {
        if hasVertex(vertex: vertex) {
            return
        }
        vertexSet.insert(vertex)
    }
    func hasVertex(vertex: String) -> Bool {
        return vertexSet.contains(vertex)
    }
    mutating func addEdge(vertex1: String, vertex2: String, edge: Edge) {
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
    mutating func removeVertex(vertex: String) {
        
    }
    mutating func removeEdge(vertex1: String, vertex2: String) {
        
    }
}
