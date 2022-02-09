//
//  ShotestPathTests.swift
//  ShotestPathTests
//
//  Created by руслан карымов on 09.02.2022.
//

import XCTest
@testable import ShotestPath

class ShotestPathTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testFloydWarshall() throws {
        let graph = FloydWarshallGraph()
        "ABCD".forEach {
            graph.addVertex(vertex: String($0))
        }
        ["AB:-2","BD:6","AD:5","DA:-1","CD:-4","BC:8","CB:3","AC:7"].forEach { edge in
            let a = edge.components(separatedBy: ":")
            let vertex1 = String(a[0].first!)
            let vertex2 = String(a[0].last!)
            let weight = Int(a[1])!
            graph.addEdge(vertex1: vertex1, vertex2: vertex2, edge: EdgeWieght(weight: weight))
        }
        graph.printTable()
        graph.printMatrix(graph.floydWarshallShotPaths())
    }
    
    func testBellmanFord() throws {
        let graph = BellmanFordGraph()
        "ABCD".forEach {
            graph.addVertex(vertex: String($0))
        }
        ["AB:-2","BD:6","AD:5","DA:-1","CD:-4","BC:8","CB:3","AC:7"].forEach { edge in
            let a = edge.components(separatedBy: ":")
            let vertex1 = String(a[0].first!)
            let vertex2 = String(a[0].last!)
            let weight = Int(a[1])!
            graph.addEdge(vertex1: vertex1, vertex2: vertex2, edge: EdgeWieght(weight: weight))
        }
        graph.printTable()
        print(graph.bellmanFordShotPaths(vertex: "A"))
    }
    
    func testDijkstra() throws {
        let graph = DijkstraGraph()
        "ABCDEFG".forEach {
            graph.addVertex(vertex: String($0))
        }
        ["AB:2","BE:9","EG:5","GF:8","FD:4","DA:6","AC:3","BC:4","EC:7","EF:1","FC:6","DC:1"].forEach { edge in
            let a = edge.components(separatedBy: ":")
            let vertex1 = String(a[0].first!)
            let vertex2 = String(a[0].last!)
            let weight = Int(a[1])!
            graph.addEdge(vertex1: vertex1, vertex2: vertex2, edge: EdgeWieght(weight: weight))
        }
        graph.printTable()
        print(graph.dijkstraShotPaths(vertex: "A"))
    }

}
