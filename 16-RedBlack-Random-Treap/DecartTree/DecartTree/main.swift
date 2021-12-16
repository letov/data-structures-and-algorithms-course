//
//  main.swift
//  DecartTree
//
//  Created by руслан карымов on 15.12.2021.
//

import Foundation

final class Node {
    var key: Int
    var L: Node?
    var R: Node?
    var y: Int

    init(key: Int, y: Int) {
        self.key = key
        self.y = y
    }
}

extension Node: TreeRepresentable {
    var name: String {
        return "\(key),\(y)"
    }
    
    var subnodes: [Node] {
        return [L, R].compactMap { $0 }
    }
}

extension Node: Equatable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.key == rhs.key
        && lhs.L == rhs.L
        && lhs.R == rhs.R
    }
}

class DT {
    var root: Node?
    
    init() {
        root = nil
    }
    
    func printTree() {
        guard let root = root else {
            return
        }
        print(TreePrinter.printTree(root: root))
    }
    
    func search(key: Int, node: Node?) -> Node? {
        guard let node = node else {
            return nil
        }
        if key == node.key {
            return node
        }
        return search(key: key, node: key > node.key ? node.R : node.L)
    }

    func split(key: Int, node: Node?) -> (Node?, Node?) {
        guard let node = node else {
            return (nil, nil)
        }
        var L: Node
        var R: Node
        if key < node.key {
            R = Node(key: node.key, y: node.y)
            R.R = node.R
            guard let nodeL = node.L else {
                return (nil, R)
            }
            L = Node(key: nodeL.key, y: nodeL.y)
            L.L = nodeL.L
            (L.R, R.L) = split(key: key, node: nodeL.R)
        } else {
            L = Node(key: node.key, y: node.y)
            L.L = node.L
            guard let nodeR = node.R else {
                return (L, nil)
            }
            R = Node(key: nodeR.key, y: nodeR.y)
            R.R = nodeR.R
            (L.R, R.L) = split(key: key, node: nodeR.L)
        }
        return (L, R)
    }
    
    func merge(node1: Node?, node2: Node?) -> Node? {
        guard let node1 = node1 else {
            return node2
        }
        guard let node2 = node2 else {
            return node1
        }
        var node: Node
        if node1.y < node2.y {
            node = Node(key: node2.key, y: node2.y)
            node.R = node2.R
            node.L = merge(node1: node1, node2: node2.L)
        } else {
            node = Node(key: node1.key, y: node1.y)
            node.L = node1.L
            node.R = merge(node1: node1.R, node2: node2)
        }
        return node
    }
    
    func insert(key: Int, node: Node) {
        let (L, R) = split(key: key, node: node)
        let y = Int.random(in: Int.zero...Int.max)
        root = merge(node1: L, node2: Node(key: key, y: y))
        root = merge(node1: root, node2: R)
    }
    
    func insert(key: Int) {
        guard let node = root else {
            root = Node(key: key, y: Int.random(in: Int.zero...Int.max))
            return
        }
        insert(key: key, node: node)
    }
    
    func highs(_ result: inout [Int], _ node: Node?, _ acc: Int) {
        guard let node = node else {
            return
        }
        if node.L == nil && node.R == nil {
            result.append(acc)
            return
        }
        let acc = acc + 1
        highs(&result, node.L, acc)
        highs(&result, node.R, acc)
    }
    
    func getHighs() -> (min: Int, max: Int, average: Int) {
        var result = [Int]()
        highs(&result, root, 0)
        return (min: result.min() ?? 0,
                max: result.max() ?? 0,
                average: result.reduce(0, +) / result.count)
    }
}

extension DT: Equatable {
    static func == (lhs: DT, rhs: DT) -> Bool {
        return lhs.root == rhs.root
    }
}

class Timer {
    static var share = Timer()
    private var startTime = DispatchTime.now()
    
    func start() {
        startTime = DispatchTime.now()
    }
    
    func stop(_ label: String = "") {
        let stopTime = (DispatchTime.now().uptimeNanoseconds - startTime.uptimeNanoseconds) / 1000000
        print("\(label) - \(stopTime) ms")
    }
    
    func timer(label: String = "", _ f: () -> ()) {
        start()
        f()
        stop(label)
    }
}

let a = DT()
let N = 100000

Timer.share.timer(label: "") {
    Array(1...N).forEach {
        a.insert(key: $0)
    }

}
print(a.getHighs())
