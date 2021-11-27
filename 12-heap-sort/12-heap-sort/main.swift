//
//  main.swift
//  workplace
//
//  Created by руслан карымов on 29.10.2021.
//

import Foundation

extension Array where Element: Comparable {
    mutating func selectSorted() -> [Element] {
        var result = self
        var rawEnd = result.endIndex - 1
        while rawEnd > result.startIndex {
            let max = result[...rawEnd].enumerated().max(by: { $0.element < $1.element })
            result.swapAt(rawEnd, max!.offset)
            rawEnd = result.index(before: rawEnd)
        }
        return result
    }
}

extension Array where Element: Comparable {
    
    mutating func maxToRoot(_ root: Int, _ size: Int) {
        let l = 2 * root + 1
        let r = 2 * root + 2
        
        var x = root
        if l < size && self[l] > self[x] {
            x = l
        }
        if r < size && self[r] > self[x] {
            x = r
        }

        if x == root {
            return
        }
        
        self.swapAt(root, x)
        maxToRoot(x, size)
    }
    
    mutating func heapSort() {
        for i in stride(from: self.count - 1 / 2, through: 0, by: -1) {
            maxToRoot(i, self.count - 1)
        }
        for size in stride(from: self.count - 1, through: 0, by: -1) {
            self.swapAt(0, size)
            maxToRoot(0, size)
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

extension Array where Element: Comparable {
    func sortAlert() {
        if self.sorted() == self {
            print("sorted")
        } else {
            print("NOT sorted")
        }
    }
}

let t = 100000
var arr = Array(1...t)
arr.reverse()
Timer.share.start()
arr.heapSort()
Timer.share.stop("heapSorted")
arr.sortAlert()
