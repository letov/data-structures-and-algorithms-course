//
//  GraphSearchSortTests.swift
//  GraphSearchSortTests
//
//  Created by руслан карымов on 27.01.2022.
//

import XCTest
@testable import GraphSearchSort

class EdgeMock: Edge {

}

class GraphSearchSortTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()

    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testDFSBFS() throws {
        let graph = LinkedGraphDFSBFS()
        ["AB","BC","CF","FJ","EJ","BE","HJ","HG","EG","DE","FE","AD","DG","XY"].forEach {
            graph.addEdge(vertex1: String($0.first!), vertex2: String($0.last!), edge: EdgeMock())
        }
        graph.printTable()
        graph.DFS(vertex: "E")
        XCTAssertEqual(graph.used.contains("J"), true)
        XCTAssertEqual(graph.used.contains("X"), false)
        graph.used = []
        graph.DFSStack(vertex: "E")
        XCTAssertEqual(graph.used.contains("J"), true)
        XCTAssertEqual(graph.used.contains("X"), false)
        graph.used = []
        graph.BFS(vertex: "E")
        XCTAssertEqual(graph.used.contains("J"), true)
        XCTAssertEqual(graph.used.contains("X"), false)
    }
    
    func testKhan() throws {
        let graph = EdgeListKhan()
        ["AB","BC","CF","FJ","EJ","BE","HJ","HG","EG","DE","FE","AD","DG","XY"].forEach {
            graph.addEdge(vertex1: String($0.first!), vertex2: String($0.last!), edge: EdgeMock())
        }
        graph.printTable()
        graph.khanSort()
        XCTAssertEqual(graph.khanTopologicalSort, ["A", "B", "C", "F", "H", "D", "E", "J", "G", "X", "Y"])
    }
    
    func testDemuikron() throws {
        let graph = AdjacencyVectorDemuikron()
        (0...14).forEach { graph.addVertex(vertex: $0) }
        graph.addEdge(vertex1: 2, vertex2: 13)
        graph.addEdge(vertex1: 13, vertex2: 3)
        graph.addEdge(vertex1: 8, vertex2: 2)
        graph.addEdge(vertex1: 1, vertex2: 13)
        graph.addEdge(vertex1: 14, vertex2: 6)
        graph.addEdge(vertex1: 8, vertex2: 4)
        graph.addEdge(vertex1: 6, vertex2: 4)
        graph.addEdge(vertex1: 6, vertex2: 12)
        graph.addEdge(vertex1: 10, vertex2: 12)
        graph.addEdge(vertex1: 10, vertex2: 1)
        graph.addEdge(vertex1: 9, vertex2: 14)
        graph.addEdge(vertex1: 1, vertex2: 3)
        graph.addEdge(vertex1: 11, vertex2: 3)
        graph.addEdge(vertex1: 10, vertex2: 7)
        graph.addEdge(vertex1: 7, vertex2: 11)
        graph.addEdge(vertex1: 8, vertex2: 7)
        graph.addEdge(vertex1: 6, vertex2: 11)
        graph.addEdge(vertex1: 5, vertex2: 10)
        graph.addEdge(vertex1: 5, vertex2: 9)
        graph.addEdge(vertex1: 6, vertex2: 13)
        graph.printTable()
        let sorted = graph.demuikronSort()
        XCTAssertEqual(sorted.first!, [0, 5, 8])
    }
    
    func testTarjanKosarayu() throws {
        let graph = AdjacencyVectorKosarayu()
        (0...8).forEach { graph.addVertex(vertex: $0) }
        graph.addEdge(vertex1: 1, vertex2: 2)
        graph.addEdge(vertex1: 2, vertex2: 3)
        graph.addEdge(vertex1: 3, vertex2: 1)
        graph.addEdge(vertex1: 6, vertex2: 3)
        graph.addEdge(vertex1: 4, vertex2: 2)
        graph.addEdge(vertex1: 4, vertex2: 3)
        graph.addEdge(vertex1: 5, vertex2: 4)
        graph.addEdge(vertex1: 4, vertex2: 5)
        graph.addEdge(vertex1: 5, vertex2: 6)
        graph.addEdge(vertex1: 6, vertex2: 7)
        graph.addEdge(vertex1: 7, vertex2: 6)
        graph.addEdge(vertex1: 8, vertex2: 7)
        graph.addEdge(vertex1: 8, vertex2: 5)
        graph.addEdge(vertex1: 8, vertex2: 8)
        XCTAssertEqual(graph.kosarayuSCC(), [[3, 2, 1], [7, 6], [5, 4], [8], [0]])
    }
}
