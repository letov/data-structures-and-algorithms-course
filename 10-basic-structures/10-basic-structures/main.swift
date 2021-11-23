//
//  main.swift
//  10-basic-structures
//
//  Created by руслан карымов on 18.11.2021.
//

import Foundation

protocol DArrayProtocol {
    associatedtype Item
    var count: Int { get }
    func get(_ index: Int) -> Item?
    mutating func add(_ item: Item)
    mutating func removeLast()
    mutating func insert(_ item: Item, _ index: Int)
    mutating func remove(_ index: Int)
}

struct SingleDArray<T>: DArrayProtocol {
    
    typealias Item = T
    
    private var arr = [T]()
    
    var count: Int = 0
    
    let emptyItem: T
    
    init(_ emptyItem: T) {
        self.emptyItem = emptyItem
    }
    
    func get(_ index: Int) -> T? {
        return arr[index]
    }
    
    mutating func add(_ item: T) {
        resize()
        arr[count] = item
        count += 1
    }
    
    mutating func removeLast() {
        arr[count - 1] = emptyItem
        count -= 1
    }
    
    mutating func resize() {
        var newArray = [T].init(repeating: emptyItem, count: count + 1)
        newArray.enumerated().forEach { newArrayIndex, _ in
            newArray[newArrayIndex] = newArrayIndex < count ? arr[newArrayIndex] : emptyItem
        }
        arr = newArray
    }

    mutating func insert(_ item: T, _ index: Int) {
        resize()
        if count != 0 {
            for i in (index + 1...count).reversed() {
                arr[i] = arr[i - 1]
            }
        }
        arr[index] = item
        count += 1
    }
    
    mutating func remove(_ index: Int) {
        for i in (index..<count - 1) {
            arr[i] = arr[i + 1]
        }
        arr[count - 1] = emptyItem
        count -= 1
    }
    
    mutating func speedFill(_ arr: [T]) {
        self.arr = arr
        count = arr.count
    }
}

struct VectorDArray<T>: DArrayProtocol {
    
    private var arr = [T]()
    
    var count: Int = 0
    
    let vector: Int = 10
    
    let emptyItem: T
    
    init(_ emptyItem: T) {
        self.emptyItem = emptyItem
    }

    func get(_ index: Int) -> T? {
        return arr[index]
    }
    
    mutating func add(_ item: T) {
        if count >= arr.count {
            resize()
        }
        arr[count] = item
        count += 1
    }
    
    mutating func removeLast() {
        arr[count - 1] = emptyItem
        count -= 1
    }
    
    mutating func resize() {
        var newArray = [T].init(repeating: emptyItem, count: count + vector)
        newArray.enumerated().forEach { newArrayIndex, _ in
            newArray[newArrayIndex] = newArrayIndex < count ? arr[newArrayIndex] : emptyItem
        }
        arr = newArray
    }
    
    mutating func insert(_ item: T, _ index: Int) {
        if count + 1 >= arr.count {
            resize()
        }
        if count != 0 {
            for i in (index + 1...count).reversed() {
                arr[i] = arr[i - 1]
            }
        }
        arr[index] = item
        count += 1
    }
    
    mutating func remove(_ index: Int) {
        for i in (index..<count - 1) {
            arr[i] = arr[i + 1]
        }
        arr[count - 1] = emptyItem
        count -= 1
    }
    
    mutating func speedFill(_ arr: [T]) {
        self.arr = arr
        count = arr.count
    }
    
}

struct FactorDArray<T>: DArrayProtocol {
    private var arr = [T]()
    
    var count: Int = 0
    
    let emptyItem: T
    
    init(_ emptyItem: T) {
        self.emptyItem = emptyItem
    }

    func get(_ index: Int) -> T? {
        return arr[index]
    }
    
    mutating func add(_ item: T) {
        if count >= arr.count {
            resize()
        }
        arr[count] = item
        count += 1
    }
    
    mutating func removeLast() {
        arr[count - 1] = emptyItem
        count -= 1
    }
    
    mutating func resize() {
        var newArray = [T].init(repeating: emptyItem, count: count * 2 + 1)
        newArray.enumerated().forEach { newArrayIndex, _ in
            newArray[newArrayIndex] = newArrayIndex < count ? arr[newArrayIndex] : emptyItem
        }
        arr = newArray
    }
    
    mutating func insert(_ item: T, _ index: Int) {
        if count + 1 >= arr.count {
            resize()
        }
        if count != 0 {
            for i in (index + 1...count).reversed() {
                arr[i] = arr[i - 1]
            }
        }
        arr[index] = item
        count += 1
    }
    
    mutating func remove(_ index: Int) {
        for i in (index..<count - 1) {
            arr[i] = arr[i + 1]
        }
        arr[count - 1] = emptyItem
        count -= 1
    }
    
    mutating func speedFill(_ arr: [T]) {
        self.arr = arr
        count = arr.count
    }
    
}

struct MatrixDArray<T>: DArrayProtocol {
    private var arr = [[T]]()
    
    var count: Int = 0
    
    var rowSize: Int = 100
    
    let emptyItem: T
    
    func indexToCoord(_ index: Int) -> (Int, Int) {
        let y = Int(floor(Double(index / rowSize)))
        let x = index % rowSize
        return (y, x)
    }
    
    init(_ emptyItem: T) {
        self.emptyItem = emptyItem
        arr = [[T]].init(repeating: [T].init(repeating: emptyItem, count: rowSize), count: 1)
    }

    func get(_ index: Int) -> T? {
        let coord = indexToCoord(index)
        return arr[coord.0][coord.1]
    }
    
    mutating func add(_ item: T) {
        if count % rowSize == 0 && count != 0 {
            resize()
        }
        let coord = indexToCoord(count)
        arr[coord.0][coord.1] = item
        count += 1
    }
    
    mutating func removeLast() {
        let coord = indexToCoord(count - 1)
        arr[coord.0][coord.1] = emptyItem
        count -= 1
    }
    
    mutating func resize() {
        let newArray = [T].init(repeating: emptyItem, count: rowSize)
        arr.append(newArray)
    }
    
    mutating func insert(_ item: T, _ index: Int) {
        if count % rowSize == 0 {
            resize()
        }
        if count != 0 {
            for i in (index + 1...count).reversed() {
                let coord1 = indexToCoord(i)
                let coord2 = indexToCoord(i - 1)
                arr[coord1.0][coord1.1] = arr[coord2.0][coord2.1]
            }
        }
        let coord3 = indexToCoord(index)
        arr[coord3.0][coord3.1] = item
        count += 1
    }
    
    mutating func remove(_ index: Int) {
        for i in (index..<count - 1) {
            let coord1 = indexToCoord(i)
            let coord2 = indexToCoord(i + 1)
            arr[coord1.0][coord1.1] = arr[coord2.0][coord2.1]
        }
        let coord3 = indexToCoord(count - 1)
        arr[coord3.0][coord3.1] = emptyItem

        count -= 1
    }
}

struct LinkedList<T> {
    
    class Node<T> {
        var value: T
        var next: Node? = nil
        
        init(_ value: T, _ next: Node? = nil) {
            self.value = value
            self.next = next
        }
    }
    
    var head: Node<T>?
    var tail: Node<T>?
    
    var count: Int = 0
    
    mutating func push(_ item: T) {
        head = Node(item, head)
        if tail == nil {
            tail = head
        }
        count += 1
    }
    
    mutating func add(_ item: T) {
        if (head == nil) {
            push(item)
            return
        }
        tail!.next = Node(item)
        tail = tail!.next
        count += 1
    }
    
    mutating func removeLast() {
        var curItem = head
        var prevItem: Node<T>? = nil
        while curItem?.next != nil {
            prevItem = curItem
            curItem = curItem?.next
        }
        tail = prevItem
        tail?.next = nil
    }
    
    mutating func insert(_ item: T, _ index: Int) {
        if index == 0 {
            push(item)
            return
        }
        var curItem = head
        var prevItem: Node<T>? = nil
        var curIndex = 0
        while curItem != nil {
            if curIndex == index {
                prevItem?.next = Node(item, curItem)
                break
            }
            prevItem = curItem
            curItem = curItem?.next
            curIndex += 1
        }
    }
    
    mutating func remove(_ index: Int) {
        if index == 0 {
            head = head?.next
        }
        var curItem = head
        var prevItem: Node<T>? = nil
        var curIndex = 0
        while curItem != nil {
            if curIndex == index {
                prevItem?.next = curItem?.next
                break
            }
            prevItem = curItem
            curItem = curItem?.next
            curIndex += 1
        }
    }
    
    func get(_ index: Int) -> T? {
        var curItem = head
        var curIndex = 0
        while curItem != nil {
            if curIndex == index {
                return curItem?.value
            }
            curItem = curItem?.next
            curIndex += 1
        }
        return nil
    }
    
    func display() -> [T] {
        var curItem = head
        var result = [T]()
        while curItem != nil {
            result.append(curItem!.value)
            curItem = curItem?.next
        }
        return result
    }
}

func testPut(_ dArray: inout LinkedList<Int>, _ total: Int) {
    let start = DispatchTime.now()
    for j in 0...total {
       //dArray.get(Int.random(in: 0..<dArray.count))
    }
    let time = (DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1000000
    print("\(type(of: dArray)) - \(time) ms")
}

var single = SingleDArray(Int.zero)
var vector = VectorDArray(Int.zero)
var factor = FactorDArray(Int.zero)
var matrix = MatrixDArray(Int.zero)
var linkedList = LinkedList<Int>()

//testPut(&linkedList, 1000)

struct PriorityQueue<T> {
    var queue = LinkedList<(Int, T)>()
    
    mutating func enqueue(_ priority: Int, _ item: T) {
        var curItem = queue.head
        var curIndex = 0
        while curItem != nil {
            let val = curItem?.value
            if val!.0 < priority {
                queue.insert((priority, item), curIndex)
                return
            }
            curItem = curItem?.next
            curIndex += 1
        }
        queue.add((priority, item))
    }
    
    mutating func dequeue() -> T? {
        let result = queue.head
        queue.remove(0)
        return result?.value.1
    }
    
    func display() -> [(Int,T)] {
        return queue.display()
    }
}

var priorityQueue = PriorityQueue<String>()
priorityQueue.enqueue(5, "F")
priorityQueue.enqueue(1, "B")
priorityQueue.enqueue(3, "D")
priorityQueue.enqueue(4, "E")
priorityQueue.enqueue(0, "A")
priorityQueue.enqueue(2, "C")
priorityQueue.enqueue(0, "A1")
priorityQueue.enqueue(0, "A2")
print(priorityQueue.display())
