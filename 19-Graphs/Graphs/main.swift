//
//  main.swift
//  Graphs
//
//  Created by руслан карымов on 24.01.2022.
//

import Foundation

//sourcery: AutoMockable
protocol Edge {
    
}

protocol Graph {
    mutating func addVertex(vertex: String)
    func hasVertex(vertex: String) -> Bool
    mutating func addEdge(vertex1: String, vertex2: String, edge: Edge)
    func hasEdge(vertex1: String, vertex2: String) -> Bool
    func vertexDegree(vertex: String) -> Int
    func getAdjacentEdge(vertex: String) -> [Edge]
    func getAdjacentVertex(vertex: String) -> [String]
    func printTable()
    mutating func removeVertex(vertex: String)
    mutating func removeEdge(vertex1: String, vertex2: String)
}
