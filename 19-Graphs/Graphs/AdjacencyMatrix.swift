//
//  AdjacencyMatrix.swift
//  Graphs
//
//  Created by руслан карымов on 27.01.2022.
//

import Foundation

struct AdjacencyMatrix: Graph {
    var vertexTable = Dictionary<String, Int>()
    typealias EdgeTableRow = Array<Edge?>
    var edgeTable = Array<EdgeTableRow>()
    mutating func addVertex(vertex: String) {
        if hasVertex(vertex: vertex) {
            return
        }
        defer {
            vertexTable[vertex] = edgeTable.count - 1
        }
        guard !edgeTable.isEmpty else {
            edgeTable.append(
                EdgeTableRow.init(repeating: nil, count: 1)
            )
            return
        }
        for edgeRow in edgeTable.enumerated() {
            edgeTable[edgeRow.offset].append(nil)
        }
        edgeTable.append(
            EdgeTableRow.init(repeating: nil, count: edgeTable.first!.count)
        )
    }
    func hasVertex(vertex: String) -> Bool {
        return vertexTable[vertex] != nil
    }
    mutating func addEdge(vertex1: String, vertex2: String, edge: Edge) {
        guard !hasEdge(vertex1: vertex1, vertex2: vertex2) else {
            return
        }
        addVertex(vertex: vertex1)
        addVertex(vertex: vertex2)
        let vertexIndex1 = vertexTable[vertex1]!
        let vertexIndex2 = vertexTable[vertex2]!
        edgeTable[vertexIndex1][vertexIndex2] = edge
        edgeTable[vertexIndex2][vertexIndex1] = edge
    }
    func hasEdge(vertex1: String, vertex2: String) -> Bool {
        guard let vertexIndex1 = vertexTable[vertex1],
              let vertexIndex2 = vertexTable[vertex2] else {
                  return false
              }
        return edgeTable[vertexIndex1][vertexIndex2] != nil
    }
    func vertexDegree(vertex: String) -> Int {
        return getAdjacentEdge(vertex: vertex).count
    }
    func getAdjacentEdge(vertex: String) -> [Edge] {
        guard let vertexIndex = vertexTable[vertex] else {
            return []
        }
        return edgeTable[vertexIndex].filter( { $0 != nil } ).compactMap { $0 }
    }
    func getAdjacentVertex(vertex: String) -> [String] {
        guard let vertexIndex = vertexTable[vertex] else {
            return []
        }
        return zip(edgeTable[vertexIndex],
                   vertexTable.sorted(by: { $0.value < $1.value } ))
            .filter { $0.0 != nil }
            .map { $0.1.key }
    }
    func printTable() {
        let halfOffset = "   "
        let head = vertexTable.sorted(by: { $0.value < $1.value } ).reduce("") { acc, arg in
            let (vertex, _) = arg
            let cell = "|\(halfOffset)\(vertex)\(halfOffset)"
            return acc + cell
        }
        print("|\(halfOffset) \(halfOffset)\(head)|")
        let headDel = (0...vertexTable.count).reduce("") { acc, vertex in
            let cell = "|\(halfOffset)-\(halfOffset)"
            return acc + cell
        }
        print("\(headDel)|")
        edgeTable.enumerated().forEach { (edgeIndex1, row) in
            let result = row.enumerated().reduce("") { acc, arg in
                let (edgeIndex2, edge) = arg
                var edgeExist = edge != nil ? "+" : " "
                edgeExist = edgeIndex1 == edgeIndex2 ? "X" : edgeExist
                let cell = "|\(halfOffset)\(edgeExist)\(halfOffset)"
                return acc + cell
            }
            let vertexName = vertexTable.filter { $0.value == edgeIndex1 }.first?.key ?? ""
            print("|\(halfOffset)\(vertexName)\(halfOffset)\(result)|")
        }
    }
    mutating func removeVertex(vertex: String) {
        
    }
    mutating func removeEdge(vertex1: String, vertex2: String) {
        
    }
}
