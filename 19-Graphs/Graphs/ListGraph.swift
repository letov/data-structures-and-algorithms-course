//
//  ListGraph.swift
//  Graphs
//
//  Created by руслан карымов on 27.01.2022.
//

import Foundation

protocol Linked {
    var next: Self? { get set }
}

final class EdgeListGraph: Linked {
    var edge: Edge
    var vertex: VertexListGraph
    var next: EdgeListGraph?
    init(edge: Edge, vertex: VertexListGraph) {
        self.edge = edge
        self.vertex = vertex
    }
}

final class VertexListGraph: Linked {
    var name: String
    var edgeHead: EdgeListGraph?
    var next: VertexListGraph?
    init(name: String) {
        self.name = name
    }
}

struct ListGraph: Graph {
    var head: VertexListGraph?
    func getLast<T: Linked>(from: T) -> T {
        var next = from
        while next.next != nil {
            next = next.next!
        }
        return next
    }
    func enumLinked<T: Linked>(from: T?, f: (Any) -> ()) {
        var next = from
        while next != nil {
            f(next!)
            next = next!.next
        }
    }
    mutating func addVertex(vertex: String) {
        guard !hasVertex(vertex: vertex) else {
            return
        }
        guard let head = head else {
            head = VertexListGraph(name: vertex)
            return
        }
        getLast(from: head).next = VertexListGraph(name: vertex)
    }
    func findVertex(vertex: String, from: VertexListGraph?) -> VertexListGraph? {
        var next = from
        while next != nil {
            if next!.name == vertex {
                return next
            }
            next = next!.next
        }
        return nil
    }
    func hasVertex(vertex: String) -> Bool {
        return findVertex(vertex: vertex, from: head) != nil
    }
    func findVertexes(vertex1: String, vertex2: String) -> (VertexListGraph,VertexListGraph)? {
        var firstVertex: VertexListGraph?
        var terminateVertex: VertexListGraph?
        var next = head
        while next != nil {
            if next!.name == vertex1 {
                firstVertex = next
                if terminateVertex != nil {
                    return (firstVertex!, terminateVertex!)
                }
            } else if next!.name == vertex2 {
                terminateVertex = next
                if firstVertex != nil {
                    return (firstVertex!, terminateVertex!)
                }
            }
            next = next!.next
        }
        return nil
    }
    mutating func addEdge(vertex1: String, vertex2: String, edge: Edge) {
        _addEdge(vertex1: vertex1, vertex2: vertex2, edge: edge)
        _addEdge(vertex1: vertex2, vertex2: vertex1, edge: edge)
    }
    mutating func _addEdge(vertex1: String, vertex2: String, edge: Edge) {
        addVertex(vertex: vertex1)
        addVertex(vertex: vertex2)
        let (firstVertex, terminateVertex) = findVertexes(vertex1: vertex1, vertex2: vertex2)!
        let newEdge = EdgeListGraph(edge: edge, vertex: terminateVertex)
        if firstVertex.edgeHead == nil {
            firstVertex.edgeHead = newEdge
        } else {
            getLast(from: firstVertex.edgeHead!).next = newEdge
        }
    }
    func findEdge(vertexName: String, from: EdgeListGraph?) -> EdgeListGraph? {
        var next = from
        while next != nil {
            if next!.vertex.name == vertexName {
                return next
            }
            next = next!.next
        }
        return nil
    }
    func hasEdge(vertex1: String, vertex2: String) -> Bool {
        guard let (firstVertex, terminateVertex) = findVertexes(vertex1: vertex1, vertex2: vertex2) else {
            return false
        }
        return  findEdge(vertexName: vertex2, from: firstVertex.edgeHead) != nil ||
                findEdge(vertexName: vertex1, from: terminateVertex.edgeHead) != nil
    }
    func vertexDegree(vertex: String) -> Int {
        guard let vertex = findVertex(vertex: vertex, from: head) else {
            return 0
        }
        var result = 0
        enumLinked(from: vertex.edgeHead) { _ in
            result += 1
        }
        return result
    }
    func getAdjacentEdge(vertex: String) -> [Edge] {
        guard let vertex = findVertex(vertex: vertex, from: head) else {
            return []
        }
        var result = [Edge]()
        enumLinked(from: vertex.edgeHead) { next in
            result.append((next as! EdgeListGraph).edge)
        }
        return result
    }
    func getAdjacentVertex(vertex: String) -> [String] {
        guard let vertex = findVertex(vertex: vertex, from: head) else {
            return []
        }
        var result = [String]()
        enumLinked(from: vertex.edgeHead) { next in
            result.append((next as! EdgeListGraph).vertex.name)
        }
        return result
    }
    func printTable() {
        var next = head
        while next != nil {
            var nextEdge = next!.edgeHead
            var rowEdge = ""
            while nextEdge != nil {
                rowEdge += "[\(nextEdge!.vertex.name)] -> "
                nextEdge = nextEdge!.next
            }
            print("\(next!.name) -> \(rowEdge)")
            next = next!.next
        }
        
    }
    mutating func removeVertex(vertex: String) {
        
    }
    mutating func removeEdge(vertex1: String, vertex2: String) {
        
    }
}
