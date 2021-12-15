//
//  main.swift
//  RedBlackTree
//
//  Created by руслан карымов on 14.12.2021.
//

import Foundation

enum NodeColor {
    case red
    case black
}

final class Node {
    var key: Int
    var L: Node?
    var R: Node?
    var color: NodeColor = .red
    
    func changeColor(color: NodeColor) {
        self.color = color
        if color == .red {
            L?.color = .black
            R?.color = .black
        }
    }
    
    init(key: Int) {
        self.key = key
    }
}

extension Node: TreeRepresentable {
    var name: String {
        return "\(key) (\(color))"
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

class RBT {
    var root: Node?
    typealias Rel = (P: Node?, G: Node?, U: Node?)
    
    init() {
        root = nil
    }
    
    func printTree() {
        guard let root = root else {
            return
        }
        print(TreePrinter.printTree(root: root))
    }
    
    func getParent(key: Int, node: Node?) -> Node? {
        guard let node = node else {
            return nil
        }
        if key == node.L?.key || key == node.R?.key {
            return node
        }
        return getParent(key: key, node: key > node.key ? node.R : node.L)
    }
    
    func getParent(key: Int) -> Node? {
        guard let node = root else {
            return nil
        }
        if node.key == key {
            return nil
        }
        return getParent(key: key, node: node)
    }
    
    func getRelatives(key: Int) -> Rel {
        let P = getParent(key: key)
        let G = P == nil ? nil : getParent(key: P!.key)
        var U: Node? = nil
        if G != nil {
            U = key > G!.key ? G?.L : G?.R
        }
        return (P: P, G: G, U: U)
    }
    
    func smallLeftRotation(node: Node, rel: Rel) {
        let M = node.L
        rel.G?.L = node
        node.L = rel.P
        rel.P?.R = M
    }
    
    func smallRightRotation(node: Node, rel: Rel) {
        let N = node.R
        rel.G?.R = node
        node.R = rel.P
        rel.P?.L = N
    }
    
    func bigLeftRotation(node: Node, rel: Rel, subTreeParent: Node?) {
        let C = rel.P?.L
        rel.P?.L = rel.G
        rel.G?.R = C
        if subTreeParent == nil {
            root = rel.P!
        } else {
            if rel.P!.key > subTreeParent!.key {
                subTreeParent?.R = rel.P!
            } else {
                subTreeParent?.L = rel.P!
            }
        }
    }
    
    func bigRightRotation(node: Node, rel: Rel, subTreeParent: Node?) {
        let C = rel.P?.R
        rel.P?.R = rel.G
        rel.G?.L = C
        if subTreeParent == nil {
            root = rel.P!
        } else {
            if rel.P!.key > subTreeParent!.key {
                subTreeParent?.R = rel.P!
            } else {
                subTreeParent?.L = rel.P!
            }
        }
    }
    
    func balance(node: Node) {
        let rel = getRelatives(key: node.key)
        guard let parent = rel.P else {
            if node.color == .red {
                node.changeColor(color: .black)
            }
            return
        }
        guard let gParent = rel.G, parent.color == .red else {
            return
        }
        let uncleColor = rel.U?.color ?? .black
        switch uncleColor {
        case .red:
            // case 1
                gParent.changeColor(color: .red)
                parent.changeColor(color: .black)
                rel.U?.changeColor(color: .black)
                balance(node: gParent)
            break
        case .black:
            let a = node.key > parent.key && node.key < gParent.key
            let b = node.key < parent.key && node.key > gParent.key
            if a || b {
                // case 2
                if a {
                    smallLeftRotation(node: node, rel: rel)
                } else {
                    smallRightRotation(node: node, rel: rel)
                }
                balance(node: parent)
            } else {
                // case 3
                let subTreeParent = getParent(key: gParent.key)
                if node.key > parent.key {
                    bigLeftRotation(node: node, rel: rel, subTreeParent: subTreeParent)
                } else {
                    bigRightRotation(node: node, rel: rel, subTreeParent: subTreeParent)
                }
                parent.changeColor(color: .black)
                gParent.changeColor(color: .red)
            }
            break
        }
    }

    func insert(key: Int, node: Node) {
        let a = key > node.key
        guard let nextNode = a ? node.R : node.L else {
            if a {
                node.R = Node(key: key)
                balance(node: node.R!)
            } else {
                node.L = Node(key: key)
                balance(node: node.L!)
            }
            return
        }
        insert(key: key, node: nextNode)
    }
    
    func insert(key: Int) {
        guard let node = root else {
            root = Node(key: key)
            balance(node: root!)
            return
        }
        insert(key: key, node: node)
    }
    
    func search(key: Int, node: Node?) -> Bool {
        guard let node = node else {
            return false
        }
        if key == node.key {
            return true
        }
        return search(key: key, node: key > node.key ? node.R : node.L)
    }
    
    func search(key: Int) -> Bool {
        return search(key: key, node: root)
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

let rbtSorted = RBT()
let rbtShuffled = RBT()

let N = 1000000

let arrSorted = Array(1...N)
let arrShuffled = arrSorted.shuffled()

Timer.share.timer(label: "rbt random insert") {
    arrShuffled.forEach {
        rbtShuffled.insert(key: $0)
    }
}

Timer.share.timer(label: "rbt random search") {
    arrShuffled.forEach {
        if $0 % 10 == 0 {
            _ = rbtShuffled.search(key: $0)
        }
    }
}

Timer.share.timer(label: "rbt sorted insert") {
    arrSorted.forEach {
        rbtSorted.insert(key: $0)
    }
}

Timer.share.timer(label: "rbt sorted search") {
    arrSorted.forEach {
        if $0 % 10 == 0 {
            _ = rbtSorted.search(key: $0)
        }
    }
}
