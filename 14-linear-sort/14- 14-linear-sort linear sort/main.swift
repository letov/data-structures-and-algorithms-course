//
//  main.swift
//  14- 14-linear-sort linear sort
//
//  Created by руслан карымов on 03.12.2021.
//

import Foundation

class Node {
    var value: Int
    var next: Node? = nil
    
    init(_ value: Int, _ next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

struct BucketValue {
    
    var head: Node?

    mutating func add(_ item: Int) {
        if head == nil {
            head = Node(item, nil)
            return
        }
        var curItem = head
        var prevItem: Node? = nil
        while curItem != nil {
            if curItem!.value > item {
                if prevItem == nil {
                    head = Node(item, curItem)
                } else {
                    prevItem?.next = Node(item, curItem)
                }
                return
            }
            prevItem = curItem
            curItem = curItem?.next
        }
        prevItem?.next = Node(item, nil)
    }
    
    func get(_ index: Int) -> Int? {
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
}

extension BucketValue: Sequence, IteratorProtocol {
    typealias Element = Node
    
    mutating func next() -> Node? {
        defer {
            head = head?.next
        }
        return head
    }
}

extension Array where Element == Int {
    mutating func bucketSort() {
        var bucketValues = [BucketValue].init(repeating: BucketValue(), count: self.count)
        let maxPlus1 = self.max()! + 1
        for elem in self {
            let current = Int((elem * self.count) / maxPlus1)
            bucketValues[current].add(current)
        }
        self = []
        for bucketValue in bucketValues {
            for value in bucketValue {
                self.append(value.value)
            }
        }
    }
    
    mutating func countSort() {
        let max = self.max()!
        var counter = [Int].init(repeating: 0, count: max + 1)
        for i in self {
            counter[i] += 1
        }
        var prev = 0
        for i in counter.indices {
            counter[i] += prev
            prev = counter[i]
        }
        for i in self.reversed() {
            let index = counter[i] - 1
            self[index] = i
            counter[i] -= 1
        }
    }

    // K - кол-во частей размером bit
    // D - кол-во вариантов размером bit
    mutating func radixSort(_ bit: Int) {
        let K = Int(64 / bit)
        let D = (pow(Decimal(2), bit) as NSDecimalNumber).intValue
        var mask = D - 1
        for part in 0...K {
            var counter = [Int].init(repeating: 0, count: D)
            for i in self {
                let counterIndex = (i & mask) >> (part * bit)
                counter[counterIndex] += 1
            }
            var prev = 0
            for i in counter.indices {
                counter[i] += prev
                prev = counter[i]
            }
            for i in self.reversed() {
                let counterIndex = (i & mask) >> (part * bit)
                let index = counter[counterIndex] - 1
                self[index] = i
                counter[counterIndex] -= 1
            }
            mask <<= bit
        }
    }
    
    // если нет крупных элементов
    // - O(maxElement) по памяти
    // + быстрее на максимальных bit
    mutating func radixSortA(_ bit: Int) {
        let K = Int(64 / bit)
        let D = (pow(Decimal(2), bit) as NSDecimalNumber).intValue
        var mask = D - 1
        for _ in 0...K {
            var max = 0
            for item in self {
                let curDigit = item & mask
                max = curDigit > max ? curDigit : max
            }
            if max == 0 {
                mask <<= bit
                continue
            }
            var counter = [Int].init(repeating: 0, count: max + 1)
            for i in self {
                counter[i & mask] += 1
            }
            var prev = 0
            for i in counter.indices {
                counter[i] += prev
                prev = counter[i]
            }
            for i in self.reversed() {
                let index = counter[i & mask] - 1
                self[index] = i
                counter[i & mask] -= 1
            }
            mask <<= bit
        }
    }
}

extension Array where Element: Comparable {
    func sortAlert() {
        if self.sorted() == self {
            print("sorted")
        } else {
            print("NOT sorted")
        }
    }
}

struct Timer {
    static var share = Timer()
    private var startTime = DispatchTime.now()
    mutating func start() {
        startTime = DispatchTime.now()
    }
    func stop(_ label: String = "") {
        let stopTime = (DispatchTime.now().uptimeNanoseconds - startTime.uptimeNanoseconds) / 1000000
        print("\(label) - \(stopTime) ms")
    }
}

/*let t = 100
var arr = Array(1...t)
arr.reverse()
Timer.share.start()
arr.bucketSort()
Timer.share.stop("bucketSort")
arr.sortAlert()

arr = Array(1...t)
arr.reverse()
Timer.share.start()
arr.countSort()
Timer.share.stop("countSort")
arr.sortAlert()*/

let t = 1000
var arr = Array(1...t)
let bits = sequence(first: 1, next: { $0 * 2 })
    .prefix(7)
for bit in bits { // 1...64
    arr = Array(1...t)
    Timer.share.start()
    arr.radixSortA(bit)
    Timer.share.stop("radixSort")
    arr.sortAlert()
}
