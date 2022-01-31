//
//  main.swift
//  Graphs
//
//  Created by руслан карымов on 24.01.2022.
//

import Foundation

protocol GraphInt {
    func addVertex(vertex: Int)
    func hasVertex(vertex: Int) -> Bool
    func addEdge(vertex1: Int, vertex2: Int)
    func hasEdge(vertex1: Int, vertex2: Int) -> Bool
    func vertexDegree(vertex: Int) -> Int
    func getAdjacentVertex(vertex: Int) -> [Int]
    func printTable()
    func removeVertex(vertex: Int)
    func removeEdge(vertex1: Int, vertex2: Int)
}

protocol DirectedGraphInt {
    func vertexInDegree(vertex: Int) -> Int
    func vertexOutDegree(vertex: Int) -> Int
    func isSourceVertex(vertex: Int) -> Bool
    func isSinkVertex(vertex: Int) -> Bool
}

//sourcery: AutoMockable
protocol Edge {
    
}

protocol Graph {
    func addVertex(vertex: String)
    func hasVertex(vertex: String) -> Bool
    func addEdge(vertex1: String, vertex2: String, edge: Edge)
    func hasEdge(vertex1: String, vertex2: String) -> Bool
    func vertexDegree(vertex: String) -> Int
    func getAdjacentEdge(vertex: String) -> [Edge]
    func getAdjacentVertex(vertex: String) -> [String]
    func printTable()
    func removeVertex(vertex: String)
    func removeEdge(vertex1: String, vertex2: String)
}

protocol DirectedGraph {
    func vertexInDegree(vertex: String) -> Int
    func vertexOutDegree(vertex: String) -> Int
    func isSourceVertex(vertex: String) -> Bool
    func isSinkVertex(vertex: String) -> Bool
}
