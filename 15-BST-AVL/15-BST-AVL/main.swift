//
//  main.swift
//  15-BST-AVL
//
//  Created by руслан карымов on 16.12.2021.
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
        return "\(key) (\(high))"
    }
    
    var subnodes: [Node] {
        return [L, R].compactMap { $0 }
    }
}

class BST {
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
    
    func insert(key: Int, node: Node) {
        let a = key > node.key
        guard let nextNode = a ? node.R : node.L else {
            if a {
                node.R = Node(key: key)
            } else {
                node.L = Node(key: key)
            }
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
    
    func min(node: Node) -> Node {
        guard let next = node.L else {
            return node
        }
        return min(node: next)
    }
    
    func removeChild(key: Int, node: Node?) {
        guard let node = node else {
            root = nil
            return
        }
        if key > node.key {
            node.R = nil
        } else {
            node.L = nil
        }
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
    
    func getParent(key: Int, node: Node?) -> Node? {
        guard let node = node else {
            return nil
        }
        if key == node.L?.key || key == node.R?.key {
            return node
        }
        return getParent(key: key, node: key > node.key ? node.R : node.L)
    }
    
    func remove(key: Int, node: Node?) {
        guard let node = node else {
            return
        }
        if key == node.key {
            let parent = getParent(key: key)
            if node.L == nil && node.R == nil {
                removeChild(key: key, node: parent)
            } else if node.L == nil || node.R == nil {
                if parent == nil {
                    root = node.L ?? node.R
                } else if key > parent!.key {
                    parent!.R = node.L ?? node.R
                } else {
                    parent!.L = node.L ?? node.R
                }
            } else {
                let minNode = min(node: node.R!)
                let minNodeKey = minNode.key
                let minNodeParent = getParent(key: minNodeKey, node: node)
                removeChild(key: minNodeKey, node: minNodeParent)
                minNode.key = node.key
                node.key = minNodeKey
            }
            return
        }
        remove(key: key, node: key > node.key ? node.R : node.L)
    }
    
    func remove(key: Int) {
        return remove(key: key, node: root)
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

/*var bstRandom = BST()
var bstSorted = BST()

let N = 30
let arrSorted = Array(1...N)
let arrShuffled = arrSorted.shuffled()

Timer.share.timer(label: "bts random insert") {
    arrShuffled.forEach {
        bstRandom.insert(key: $0)
    }
}
 
Timer.share.timer(label: "bts random search") {
    arrShuffled.forEach {
        if $0 % 10 == 0 {
            _ = bstRandom.search(key: $0)
        }
    }
}

Timer.share.timer(label: "bts random remove") {
    arrShuffled.forEach {
        if $0 % 2 == 0 {
            bstRandom.remove(key: $0)
        }
    }
}

Timer.share.timer(label: "bts sorted insert") {
    arrSorted.forEach {
        bstSorted.insert(key: $0)
    }
}
    
Timer.share.timer(label: "bts sorted search") {
    arrSorted.forEach {
        if $0 % 10 == 0 {
            _ = bstSorted.search(key: $0)
        }
    }
}
    
Timer.share.timer(label: "bts sorted remove") {
    arrSorted.forEach {
        if $0 % 2 == 0 {
            bstSorted.remove(key: $0)
        }
    }
}*/

class AVL: BST {
    
    func smallLeftRotation(node: Node, parent: Node?) {
        let b = node.R
        let M = b?.L
        if parent == nil {
            root = b
        } else if node.key < parent!.key {
            parent?.L = b
        } else {
            parent?.R = b
        }
        b?.L = node
        node.R = M
        setHight(node: node)
        setHight(node: b)
    }
    
    func smallRightRotation(node: Node, parent: Node?) {
        let b = node.L
        let M = b?.R
        if parent == nil {
            root = b
        } else if node.key < parent!.key {
            parent?.L = b
        } else {
            parent?.R = b
        }
        b?.R = node
        node.L = M
        setHight(node: node)
        setHight(node: b)
    }
    
    func bigLeftRotation(node: Node, parent: Node?) {
        let b = node.R
        let c = b?.L
        let M = c?.L
        let N = c?.R
        if parent == nil {
            root = c
        } else if node.key < parent!.key {
            parent?.L = c
        } else {
            parent?.R = c
        }
        c?.L = node
        c?.R = b
        node.R = N
        b?.L = M
        setHight(node: node)
        setHight(node: b)
        setHight(node: c)
    }
    
    func bigRightRotation(node: Node, parent: Node?) {
        let b = node.L
        let c = b?.R
        let M = c?.L
        let N = c?.R
        if parent == nil {
            root = c
        } else if node.key < parent!.key {
            parent?.L = c
        } else {
            parent?.R = c
        }
        c?.L = b
        c?.R = node
        node.L = N
        b?.R = M
        setHight(node: node)
        setHight(node: b)
        setHight(node: c)
    }
    
    func setHight(node: Node?) {
        guard let node = node else {
            return
        }
        let rh = node.R?.high ?? 0
        let lh = node.L?.high ?? 0
        node.high = max(rh, lh) + 1
    }

    func balance(node: Node) {
        let parent = getParent(key: node.key)
        let rh = node.R?.high ?? 0
        let lh = node.L?.high ?? 0
        if abs(rh - lh) > 1 {
            if rh > lh {
                let rrh = node.R?.R?.high ?? 0
                let rlh = node.R?.L?.high ?? 0
                if rrh >= rlh {
                    smallLeftRotation(node: node, parent: parent)
                } else {
                    bigLeftRotation(node: node, parent: parent)
                }
            } else {
                let lrh = node.L?.R?.high ?? 0
                let llh = node.L?.L?.high ?? 0
                if llh >= lrh {
                    smallRightRotation(node: node, parent: parent)
                } else {
                    bigRightRotation(node: node, parent: parent)
                }
            }
        } else {
            setHight(node: node)
        }
        if parent == nil {
            return
        } else {
            balance(node: parent!)
        }
    }
    
    override func insert(key: Int, node: Node) {
        let a = key > node.key
        guard let nextNode = a ? node.R : node.L else {
            if a {
                node.R = Node(key: key)
            } else {
                node.L = Node(key: key)
            }
            balance(node: node)
            return
        }
        insert(key: key, node: nextNode)
    }
}

/*var avlRandom = AVL()
var avlSorted = AVL()

Timer.share.timer(label: "avl random insert") {
    arrShuffled.forEach {
        avlRandom.insert(key: $0)
    }
}

Timer.share.timer(label: "avl random search") {
    arrShuffled.forEach {
        if $0 % 10 == 0 {
            _ = avlRandom.search(key: $0)
        }
    }
}

Timer.share.timer(label: "avl random remove") {
    arrShuffled.forEach {
        if $0 % 2 == 0 {
            avlRandom.remove(key: $0)
        }
    }
}

Timer.share.timer(label: "avl sorted insert") {
    arrSorted.forEach {
        avlSorted.insert(key: $0)
    }
}
    
Timer.share.timer(label: "avl sorted search") {
    arrSorted.forEach {
        if $0 % 10 == 0 {
            _ = avlSorted.search(key: $0)
        }
    }
}
    
Timer.share.timer(label: "avl sorted remove") {
    arrSorted.forEach {
        if $0 % 2 == 0 {
            avlSorted.remove(key: $0)
        }
    }
}*/

let a = AVL()
let N = 10000

Timer.share.timer(label: "") {
    Array(1...N).forEach {
        a.insert(key: $0)
    }

}
print(a.getHighs())

