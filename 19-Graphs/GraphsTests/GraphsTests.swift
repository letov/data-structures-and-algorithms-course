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
    var lGraph: LinkedGraph!
    var avGraph: AdjacencyVector!
    var elGraph: EdgeList!

    override func setUpWithError() throws {
        try super.setUpWithError()
        bbGraph = BitboardGraph()
        amGraph = AdjacencyMatrix()
        lGraph = LinkedGraph()
        avGraph = AdjacencyVector()
        elGraph = EdgeList()
    }

    override func tearDownWithError() throws {
        bbGraph = nil
        amGraph = nil
        lGraph = nil
        avGraph = nil
        elGraph = nil
        try super.tearDownWithError()
    }
    
    // fills
    
    func fillGraphInt(graph: inout GraphInt) {
        graph.addEdge(vertex1: 0, vertex2: 1)
        graph.addEdge(vertex1: 0, vertex2: 2)
        graph.addEdge(vertex1: 0, vertex2: 3)
        graph.addEdge(vertex1: 1, vertex2: 3)
        graph.addVertex(vertex: 4)
        graph.addEdge(vertex1: 1, vertex2: 5)
        graph.addEdge(vertex1: 2, vertex2: 5)
    }
    
    func fillFullGraphInt(graph: inout GraphInt, vertexCount: Int) {
        (0...(vertexCount - 1)).forEach { graph.addVertex(vertex: $0) }
        for i in 0...(vertexCount - 1) {
            for j in i...(vertexCount - 1) {
                if i == j {
                    continue
                }
                graph.addEdge(vertex1: i, vertex2: j)
            }
        }
    }
    
    func fillGraph(graph: inout Graph) {
        graph.addEdge(vertex1: "A", vertex2: "B", edge: EdgeMock())
        graph.addEdge(vertex1: "A", vertex2: "C", edge: EdgeMock())
        graph.addEdge(vertex1: "A", vertex2: "D", edge: EdgeMock())
        graph.addEdge(vertex1: "B", vertex2: "D", edge: EdgeMock())
        graph.addVertex(vertex: "E")
        graph.addEdge(vertex1: "B", vertex2: "F", edge: EdgeMock())
        graph.addEdge(vertex1: "C", vertex2: "F", edge: EdgeMock())
    }
    
    func fillFullGraph(graph: inout Graph, vertexCount: Int) {
        for i in 0...(vertexCount - 1) {
            for j in i...(vertexCount - 1) {
                if i == j {
                    continue
                }
                graph.addEdge(vertex1: String(i), vertex2: String(j), edge: EdgeMock())
            }
        }
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

    func testBitboardGraph() throws {
        var bbGraph: GraphInt = bbGraph
        fillGraphInt(graph: &bbGraph)
        bbGraph.printTable()
        XCTAssertEqual(bbGraph.vertexDegree(vertex: 0), 3)
        XCTAssertEqual(bbGraph.vertexDegree(vertex: 2), 2)
        XCTAssertEqual(bbGraph.vertexDegree(vertex: 4), 0)
        XCTAssertEqual(bbGraph.getAdjacentVertex(vertex: 3), [0,1])
    }
    
    func testBitboardFullGraph() throws {
        var bbGraph: GraphInt = bbGraph
        fillFullGraphInt(graph: &bbGraph, vertexCount: 100)
        XCTAssertEqual(bbGraph.vertexDegree(vertex: 50), 99)
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
    
    // LinkedGraph
    
    func testLinkedGraphAdd() throws {
        XCTAssertEqual(lGraph.hasVertex(vertex: "A"), false)
        lGraph.addVertex(vertex: "A")
        XCTAssertEqual(lGraph.hasVertex(vertex: "A"), true)
        lGraph.addVertex(vertex: "A")
        lGraph.addVertex(vertex: "B")
        XCTAssertEqual(lGraph.hasEdge(vertex1: "A", vertex2: "B"), false)
        lGraph.addEdge(vertex1: "A", vertex2: "B", edge: EdgeMock())
        XCTAssertEqual(lGraph.hasEdge(vertex1: "A", vertex2: "B"), true)
    }
    
    func testLinkedGraph() throws {
        var lGraph: Graph = lGraph
        fillGraph(graph: &lGraph)
        lGraph.printTable()
        XCTAssertEqual(lGraph.vertexDegree(vertex: "A"), 3)
        XCTAssertEqual(lGraph.vertexDegree(vertex: "C"), 2)
        XCTAssertEqual(lGraph.vertexDegree(vertex: "E"), 0)
        XCTAssertEqual(lGraph.getAdjacentEdge(vertex: "F").count, 2)
        XCTAssertEqual(lGraph.getAdjacentVertex(vertex: "D"), ["A","B"])
    }
    
    func testFullLinkedGraph() throws {
        var lGraph: Graph = lGraph
        fillFullGraph(graph: &lGraph, vertexCount: 100)
        XCTAssertEqual(lGraph.vertexDegree(vertex: "50"), 99)
    }
    
    // AdjacencyVector
    
    
    
    func testAdjacencyVectorAdd() throws {
        XCTAssertEqual(avGraph.hasVertex(vertex: 0), false)
        avGraph.addVertex(vertex: 0)
        XCTAssertEqual(avGraph.hasVertex(vertex: 0), true)
        avGraph.addVertex(vertex: 0)
        avGraph.addVertex(vertex: 1)
        XCTAssertEqual(avGraph.hasEdge(vertex1: 0, vertex2: 1), false)
        avGraph.addEdge(vertex1: 0, vertex2: 1)
        XCTAssertEqual(avGraph.hasEdge(vertex1: 0, vertex2: 1), true)
    }
    
    func testAdjacencyVector() throws {
        var avGraph: GraphInt = avGraph
        fillGraphInt(graph: &avGraph)
        avGraph.printTable()
        XCTAssertEqual(avGraph.vertexDegree(vertex: 0), 3)
        XCTAssertEqual(avGraph.vertexDegree(vertex: 2), 2)
        XCTAssertEqual(avGraph.vertexDegree(vertex: 4), 0)
        XCTAssertEqual(avGraph.getAdjacentVertex(vertex: 3), [0,1])
    }
    
    /*func testFullAdjacencyVector() throws {
        var avGraph: Graph = avGraph
        fillFullGraph(graph: &avGraph, vertexCount: 100)
        XCTAssertEqual(avGraph.vertexDegree(vertex: "50"), 99)
    }*/
    
    // EdgeList
    
    func testEdgeListAdd() throws {
        XCTAssertEqual(elGraph.hasVertex(vertex: "A"), false)
        elGraph.addVertex(vertex: "A")
        XCTAssertEqual(elGraph.hasVertex(vertex: "A"), true)
        elGraph.addVertex(vertex: "A")
        elGraph.addVertex(vertex: "B")
        XCTAssertEqual(elGraph.hasEdge(vertex1: "A", vertex2: "B"), false)
        elGraph.addEdge(vertex1: "A", vertex2: "B", edge: EdgeMock())
        XCTAssertEqual(elGraph.hasEdge(vertex1: "A", vertex2: "B"), true)
    }
    
    func testEdgeList() throws {
        var elGraph: Graph = elGraph
        fillGraph(graph: &elGraph)
        elGraph.printTable()
        XCTAssertEqual(elGraph.vertexDegree(vertex: "A"), 3)
        XCTAssertEqual(elGraph.vertexDegree(vertex: "C"), 2)
        XCTAssertEqual(elGraph.vertexDegree(vertex: "E"), 0)
        XCTAssertEqual(elGraph.getAdjacentEdge(vertex: "F").count, 2)
        XCTAssertEqual(elGraph.getAdjacentVertex(vertex: "D"), ["A","B"])
    }
    
    func testFullEdgeList() throws {
        var elGraph: Graph = elGraph
        fillFullGraph(graph: &elGraph, vertexCount: 100)
        XCTAssertEqual(elGraph.vertexDegree(vertex: "50"), 99)
    }
}
