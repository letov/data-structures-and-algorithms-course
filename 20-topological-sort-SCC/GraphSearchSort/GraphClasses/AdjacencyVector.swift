//
//  AdjacencyVector.swift
//  GraphSearchSort
//
//  Created by руслан карымов on 31.01.2022.
//
import Foundation

class AdjacencyVector: GraphInt {
    var vertexVertors = [[Int]]()
    func addVertex(vertex: Int) {
        vertexVertors.append([])
    }
    func hasVertex(vertex: Int) -> Bool {
        return vertexVertors.count > vertex
    }
    func addEdge(vertex1: Int, vertex2: Int) {
        if !hasVertex(vertex: vertex1) {
            addVertex(vertex: vertex1)
        }
        if !hasVertex(vertex: vertex2) {
            addVertex(vertex: vertex2)
        }
        vertexVertors[vertex1].append(vertex2)
        vertexVertors[vertex2].append(vertex1)
    }
    func hasEdge(vertex1: Int, vertex2: Int) -> Bool {
        return hasVertex(vertex: vertex1) && hasVertex(vertex: vertex2)
        && vertexVertors[vertex1].contains(vertex2)
    }
    func vertexDegree(vertex: Int) -> Int {
        guard hasVertex(vertex: vertex) else {
            return 0
        }
        return vertexVertors[vertex].count
    }
    func getAdjacentVertex(vertex: Int) -> [Int] {
        guard hasVertex(vertex: vertex) else {
            return []
        }
        return vertexVertors[vertex]
    }
    func printTable() {
        let halfOffset = "   "
        vertexVertors.enumerated().forEach { vertex, vectors in
            let row = vectors.reduce(into: "") {
                $0 += "\(halfOffset)\(String($1))\(halfOffset)|"
            }
            print("|\(halfOffset)\(vertex)\(halfOffset)|\(row)")
            
        }
    }
    func removeVertex(vertex: Int) {
        
    }
    func removeEdge(vertex1: Int, vertex2: Int) {
        
    }
}

class AdjacencyVectorDirectGraph: AdjacencyVector & DirectedGraphInt {
    override func addEdge(vertex1: Int, vertex2: Int) {
        if !hasVertex(vertex: vertex1) {
            addVertex(vertex: vertex1)
        }
        vertexVertors[vertex1].append(vertex2)
    }
    func vertexInDegree(vertex: Int) -> Int {
        if !hasVertex(vertex: vertex) {
            return 0
        }
        return vertexVertors.reduce(0) {
            $0 + $1.reduce(0) {
                $0 + ($1 == vertex ? 1 : 0)
            }
        }
    }
    func vertexOutDegree(vertex: Int) -> Int {
        if !hasVertex(vertex: vertex) {
            return 0
        }
        return vertexVertors[vertex].count
    }
    func isSourceVertex(vertex: Int) -> Bool {
        if !hasVertex(vertex: vertex) {
            return false
        }
        return vertexInDegree(vertex: vertex) == 0
    }
    func isSinkVertex(vertex: Int) -> Bool {
        if !hasVertex(vertex: vertex) {
            return false
        }
        return vertexOutDegree(vertex: vertex) == 0
    }
}
