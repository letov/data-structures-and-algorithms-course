//
//  GraphsTests.swift
//  GraphsTests
//
//  Created by руслан карымов on 25.01.2022.
//

import XCTest
@testable import Graphs

class GraphsTests: XCTestCase {
    
    var bbGraph: BitboardGraph!
    var amGraph: AdjacencyMatrix!
    var lGraph: ListGraph!

    override func setUpWithError() throws {
        try super.setUpWithError()
        bbGraph = BitboardGraph()
        amGraph = AdjacencyMatrix()
        lGraph = ListGraph()
    }

    override func tearDownWithError() throws {
        bbGraph = nil
        amGraph = nil
        lGraph = nil
        try super.tearDownWithError()
    }
    
    // BitboardGraph
    
    func testBbArrayAxisSize() throws {
        bbGraph.vertexCount = 24
        XCTAssertEqual(bbGraph.bbArrayAxisSize, 3)
        bbGraph.vertexCount = 9678
        XCTAssertEqual(bbGraph.bbArrayAxisSize, 1210)
    }
    
    func testbbArrayResize() throws {
        bbGraph.bbArray = Array<BitboardGraph.BbArrayRow>.init(repeating: Array<UInt>.init(repeating: 0, count: 2), count: 2)
        bbGraph.vertexCount = 25
        XCTAssertEqual(bbGraph.bbArray.count, 2)
        bbGraph.bbArrayResize()
        XCTAssertEqual(bbGraph.bbArray.count, 3)
        XCTAssertEqual(bbGraph.bbArray.first!.count, 3)
    }
    
    func testGetBBCoord() throws {
        let coord = bbGraph.getBBCoord(vertex: 15)
        XCTAssertEqual(coord.bbArrayOffset, 1)
        XCTAssertEqual(coord.bbOffset, 7)
    }
    
    func testGenBitMask() throws {
        XCTAssertEqual(bbGraph.genBitMask(bbX: 0, bbY: 0), 1)
        XCTAssertEqual(bbGraph.genBitMask(bbX: 2, bbY: 4), 17179869184)
    }
    
    func testSetBit() throws {
        bbGraph.bbArray = Array<BitboardGraph.BbArrayRow>.init(repeating: Array<UInt>.init(repeating: 0, count: 5), count: 5)
        bbGraph.setBit(bbArrayX: 1, bbArrayY: 2, bbX: 4, bbY: 6)
        XCTAssertEqual(bbGraph.bbArray[2][1], 4503599627370496)
    }

    func testHasEdge() throws {
        (0...25).forEach {
            bbGraph.addVertex(vertex: $0)
        }
        bbGraph.addEdge(vertex1: 10, vertex2: 5)
        XCTAssertEqual(bbGraph.hasEdge(vertex1: 5, vertex2: 10), true)
        XCTAssertEqual(bbGraph.hasEdge(vertex1: 10, vertex2: 5), true)
    }
    
    //  (0)-0-(1)--
    //   |\    |   |
    //   1  2  3   |
    //   |   \ |   |
    //  (2)   (3)  4
    //     \       |
    //      5     /
    //       \   /
    //  (4)   (5)
    
    func testBitboardGraph() throws {
        bbGraph.addEdge(vertex1: 0, vertex2: 1)
        bbGraph.addEdge(vertex1: 0, vertex2: 2)
        bbGraph.addEdge(vertex1: 0, vertex2: 3)
        bbGraph.addEdge(vertex1: 1, vertex2: 3)
        bbGraph.addEdge(vertex1: 1, vertex2: 5)
        bbGraph.addEdge(vertex1: 2, vertex2: 5)
        bbGraph.printTable()
        XCTAssertEqual(bbGraph.vertexDegree(vertex: 0), 3)
        XCTAssertEqual(bbGraph.vertexDegree(vertex: 2), 2)
        XCTAssertEqual(bbGraph.vertexDegree(vertex: 4), 0)
        XCTAssertEqual(bbGraph.getAdjacentVertex(vertex: 3), [0,1])
    }
    
    func fillFullBBGraph(vertexCount: Int) -> BitboardGraph {
        var bbGraph = BitboardGraph()
        (0...(vertexCount - 1)).forEach { bbGraph.addVertex(vertex: $0) }
        for i in 0...(vertexCount - 1) {
            for j in i...(vertexCount - 1) {
                if i == j {
                    continue
                }
                bbGraph.addEdge(vertex1: i, vertex2: j)
            }
        }
        return bbGraph
    }
    
    func testBitboardAdjacencyMatrixFullGraph() throws {
        let bbGraph = fillFullBBGraph(vertexCount: 100)
        XCTAssertEqual(bbGraph.vertexDegree(vertex: 50), 99)
    }
    
    // fills
    
    func fillGraph(graph: inout Graph) {
        graph.addEdge(vertex1: "A", vertex2: "B", edge: EdgeMock())
        graph.addEdge(vertex1: "A", vertex2: "C", edge: EdgeMock())
        graph.addEdge(vertex1: "A", vertex2: "D", edge: EdgeMock())
        graph.addEdge(vertex1: "B", vertex2: "D", edge: EdgeMock())
        graph.addEdge(vertex1: "B", vertex2: "F", edge: EdgeMock())
        graph.addEdge(vertex1: "C", vertex2: "F", edge: EdgeMock())
    }
    
    func fillFullGraph(graph: inout Graph, vertexCount: Int) {
        for i in 0...(vertexCount - 1) {
            graph.addVertex(vertex: String(i))
        }
        for i in 0...(vertexCount - 1) {
            for j in i...(vertexCount - 1) {
                if i == j {
                    continue
                }
                graph.addEdge(vertex1: String(i), vertex2: String(j), edge: EdgeMock())
            }
        }
    }

    // AdjacencyMatrix
    
    func testAdjacencyMatrixAdd() throws {
        XCTAssertEqual(amGraph.hasVertex(vertex: "A"), false)
        amGraph.addVertex(vertex: "A")
        XCTAssertEqual(amGraph.hasVertex(vertex: "A"), true)
        amGraph.addVertex(vertex: "A")
        amGraph.addVertex(vertex: "B")
        XCTAssertEqual(amGraph.hasEdge(vertex1: "A", vertex2: "B"), false)
        amGraph.addEdge(vertex1: "A", vertex2: "B", edge: EdgeMock())
        XCTAssertEqual(amGraph.hasEdge(vertex1: "A", vertex2: "B"), true)
    }
    
    func testAdjacencyMatrix() throws {
        var amGraph: Graph = amGraph
        fillGraph(graph: &amGraph)
        amGraph.printTable()
        XCTAssertEqual(amGraph.vertexDegree(vertex: "A"), 3)
        XCTAssertEqual(amGraph.vertexDegree(vertex: "C"), 2)
        XCTAssertEqual(amGraph.vertexDegree(vertex: "E"), 0)
        XCTAssertEqual(amGraph.getAdjacentEdge(vertex: "F").count, 2)
        XCTAssertEqual(amGraph.getAdjacentVertex(vertex: "D"), ["A","B"])
    }
    
    func testFullAdjacencyMatrix() throws {
        var amGraph: Graph = amGraph
        fillFullGraph(graph: &amGraph, vertexCount: 100)
        XCTAssertEqual(amGraph.vertexDegree(vertex: "50"), 99)
    }
    
    // ListGraph
    
    func testListGraphAdd() throws {
        XCTAssertEqual(lGraph.hasVertex(vertex: "A"), false)
        lGraph.addVertex(vertex: "A")
        XCTAssertEqual(lGraph.hasVertex(vertex: "A"), true)
        lGraph.addVertex(vertex: "A")
        lGraph.addVertex(vertex: "B")
        XCTAssertEqual(lGraph.hasEdge(vertex1: "A", vertex2: "B"), false)
        lGraph.addEdge(vertex1: "A", vertex2: "B", edge: EdgeMock())
        XCTAssertEqual(lGraph.hasEdge(vertex1: "A", vertex2: "B"), true)
    }
    
    func testListGraph() throws {
        var lGraph: Graph = lGraph
        fillGraph(graph: &lGraph)
        lGraph.printTable()
        XCTAssertEqual(lGraph.vertexDegree(vertex: "A"), 3)
        XCTAssertEqual(lGraph.vertexDegree(vertex: "C"), 2)
        XCTAssertEqual(lGraph.vertexDegree(vertex: "E"), 0)
        XCTAssertEqual(lGraph.getAdjacentEdge(vertex: "F").count, 2)
        XCTAssertEqual(lGraph.getAdjacentVertex(vertex: "D"), ["A","B"])
    }
    
    func testFullListGraph() throws {
        var lGraph: Graph = lGraph
        fillFullGraph(graph: &lGraph, vertexCount: 100)
        XCTAssertEqual(lGraph.vertexDegree(vertex: "50"), 99)
    }
}
