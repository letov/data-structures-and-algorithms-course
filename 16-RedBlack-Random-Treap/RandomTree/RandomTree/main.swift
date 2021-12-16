//
//  main.swift
//  RandomTree
//
//  Created by руслан карымов on 15.12.2021.
//

import Foundation

final class Node {
    var key: Int
    var L: Node?
    var R: Node?
    var high: Int = 1

    init(key: Int) {
        self.key = key
    }
}

extension Node: TreeRepresentable {
    var name: String {
        return "\(key)"
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

class RT {
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
    
    func fixHigh(node: Node) {
        node.high = (node.L?.high ?? 0) + (node.R?.high ?? 0) + 1
    }

    func insert(key: Int, node: Node) {
        let a = key > node.key
        guard let nextNode = a ? node.R : node.L else {
            if Int.random(in: Int.zero...Int.max) % (node.high + 1) == 0 {
                root = rootInsert(key: key, node: root)
                return
            }
            if a {
                node.R = Node(key: key)
            } else {
                node.L = Node(key: key)
            }
            fixHigh(node: node)
            return
        }
        insert(key: key, node: nextNode)
    }
    
    func insert(key: Int) {
        guard let node = root else {
            root = Node(key: key)
            return
        }
        insert(key: key, node: node)
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
    
    func search(key: Int) -> Node? {
        return search(key: key, node: root)
    }
    
    func leftRotate(node: Node) -> Node? {
        guard let newRoot = node.R else {
            return node
        }
        node.R = newRoot.L
        newRoot.L = node
        newRoot.high = node.high
        fixHigh(node: node)
        return newRoot
    }
    
    func rightRotate(node: Node) -> Node?  {
        guard let newRoot = node.L else {
            return node
        }
        node.L = newRoot.R
        newRoot.R = node
        newRoot.high = node.high
        fixHigh(node: node)
        return newRoot
    }
    
    func rootInsert(key: Int, node: Node?) -> Node? {
        guard let node = node else {
            return Node(key: key)
        }
        if key < node.key {
            node.L = rootInsert(key: key, node: node.L)
            return rightRotate(node: node)
        } else {
            node.R = rootInsert(key: key, node: node.R)
            return leftRotate(node: node)
        }
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

extension RT: Equatable {
    static func == (lhs: RT, rhs: RT) -> Bool {
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

let a = RT()
let N = 1000

Timer.share.timer(label: "") {
    Array(1...N).forEach {
        a.insert(key: $0)
    }

}
print(a.getHighs())
