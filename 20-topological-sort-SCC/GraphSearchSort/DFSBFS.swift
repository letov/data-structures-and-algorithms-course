//
//  DFSBFS.swift
//  GraphSearchSort
//
//  Created by руслан карымов on 27.01.2022.
//

import Foundation

struct Stack<T> {
    var storage = Array<T>()
    var isEmpty: Bool {
        storage.isEmpty
    }
    mutating func push(_ e: T) {
        storage.append(e)
    }
    mutating func pop() -> T {
        return storage.removeLast()
    }
}

struct Queue<T> {
    var storage = Array<T>()
    var isEmpty: Bool {
        storage.isEmpty
    }
    mutating func queue(_ e: T) {
        storage.append(e)
    }
    mutating func dequeue() -> T {
        return storage.removeFirst()
    }
}

class LinkedGraphDFSBFS: LinkedDirectedGraph {
    var used = Set<String>()
    func DFS(vertex: String) {
        if used.contains(vertex) {
            return
        }
        used.insert(vertex)
        getAdjacentVertex(vertex: vertex).forEach { vertex in
            DFS(vertex: vertex)
        }
    }
    func DFSStack(vertex: String) {
        var stack = Stack<String>()
        stack.push(vertex)
        while !stack.isEmpty {
            let vertex = stack.pop()
            getAdjacentVertex(vertex: vertex).forEach { vertex in
                if !used.contains(vertex) {
                    used.insert(vertex)
                    stack.push(vertex)
                }
            }
        }
    }
    func BFS(vertex: String) {
        var queue = Queue<String>()
        queue.queue(vertex)
        while !queue.isEmpty {
            let vertex = queue.dequeue()
            getAdjacentVertex(vertex: vertex).forEach { vertex in
                if !used.contains(vertex) {
                    used.insert(vertex)
                    queue.queue(vertex)
                }
            }
        }
    }
}
