//
//  MSTTests.swift
//  MSTTests
//
//  Created by руслан карымов on 08.02.2022.
//

import XCTest
@testable import MST

class MSTTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testPrim() throws {
        let graph = LinkedGraphPrim()
        ["AB:11","BC:17","CD:4","DE:3","EF:7","FH:14","AH:13","AK:12","BK:10","KC:5","KD:2","KE:6","KG:1","KH:9","HG:15","EG:8","GF:16","EF:7","FH:14"].forEach { edge in
            let a = edge.components(separatedBy: ":")
            let vertex1 = String(a[0].first!)
            let vertex2 = String(a[0].last!)
            let weight = Int(a[1])!
            graph.addEdge(vertex1: vertex1, vertex2: vertex2, edge: EdgeWieght(weight: weight))
        }
        graph.printTable()
        let MST = graph.primMST(vertex: "G")
        MST.printTable()
    }

    func testKruskal() throws {
        let graph = EdgeListKruskal()
        ["AB:11","BC:17","CD:4","DE:3","EF:7","FH:14","AH:13","AK:12","BK:10","KC:5","KD:2","KE:6","KG:1","KH:9","HG:15","EG:8","GF:16","EF:7","FH:14"].forEach { edge in
            let a = edge.components(separatedBy: ":")
            let vertex1 = String(a[0].first!)
            let vertex2 = String(a[0].last!)
            let weight = Int(a[1])!
            graph.addEdge(vertex1: vertex1, vertex2: vertex2, edge: EdgeWieght(weight: weight))
        }
        graph.printTable()
        graph.kruskalMST().printTable()
    }
    
    func testBoruvka() throws {
        let graph = EdgeListBoruvka()
        ["AB:11","BC:17","CD:4","DE:3","EF:7","FH:14","AH:13","AK:12","BK:10","KC:5","KD:2","KE:6","KG:1","KH:9","HG:15","EG:8","GF:16","EF:7","FH:14"].forEach { edge in
            let a = edge.components(separatedBy: ":")
            let vertex1 = String(a[0].first!)
            let vertex2 = String(a[0].last!)
            let weight = Int(a[1])!
            graph.addEdge(vertex1: vertex1, vertex2: vertex2, edge: EdgeWieght(weight: weight))
        }
        graph.printTable()
        graph.boruvkaMST().printTable()
    }
}
