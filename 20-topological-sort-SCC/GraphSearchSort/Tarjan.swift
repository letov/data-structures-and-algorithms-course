//
//  Tarjan.swift
//  GraphSearchSort
//
//  Created by руслан карымов on 08.02.2022.
//

import Foundation

class AdjacencyVectorTarjan: AdjacencyVectorDirectGraph {
    var black = [Int]()
    var gray = [Int]()
    func DFS(vertex: Int) {
        if gray.contains(vertex) {
            return
        }
        gray.append(vertex)
        for outVertex in vertexVertors[vertex] {
            DFS(vertex: outVertex)
        }
        black.append(vertex)
    }
    func tarjanSort() -> [Int] {
        black = [Int]()
        gray = [Int]()
        for vertex in 0..<vertexVertors.count {
            if !black.contains(vertex) {
                DFS(vertex: vertex)
            }
        }
        return Array(black.reversed())
    }
}
