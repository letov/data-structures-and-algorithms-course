//
//  main.swift
//  workplace
//
//  Created by руслан карымов on 29.10.2021.
//

import Foundation

// St стабильность - сохраняется порядок равных элементов, как не в отсортированном массиве
// Ad адаптивность - эффективность при обработке уже отсортированных данных
// Online - для работы не нужно знать сразу все данные, можно добавть данные в процессе работы

// bubbleSort
// O(N^2) | Memory 1 | St+ | Ad- | Online-
// comp count (N^2 - N) / 2 | xchange (N^2 - N) / 2
extension Array where Element: Comparable {
    mutating func bubbleSort() {
        for i in 0..<self.count {
            for j in 0..<self.count - i - 1 {
                if self[j] > self[j + 1] {
                    self.swapAt(j, j + 1)
                }
            }
        }
    }
}

// bubbleSortAd Ad+
extension Array where Element: Comparable {
    mutating func bubbleSortAd() {
        for i in 0..<self.count {
            var swap = false
            for j in 0..<self.count - i - 1 {
                if self[j] > self[j + 1] {
                    self.swapAt(j, j + 1)
                    swap = true
                }
            }
            if !swap {
                return
            }
        }
    }
}

// insertionSort
// O(N^2) | Memory 1 | St+ | Ad+ | Online+
// comp count (N^2 - N) / 2 | xchange (N^2 - N) / 2
extension Array where Element: Comparable {
    mutating func insertionSort() {
        for i in 0..<self.count {
            for j in (0...i).reversed() {
                if j > 0 && self[j] < self[j - 1] {
                    self.swapAt(j, j - 1)
                }
            }
        }
    }
}

// insertionSortAB
// O (N logN)
extension Array where Element: Comparable {
    func binSearchIndex(_ arr: ArraySlice<Element>, _ item: Element) -> Int? {
        var low = arr.startIndex
        var high = arr.endIndex
        while low != high {
            let mid = index(low, offsetBy: distance(from: low, to: high) / 2)
            if arr[mid] < item {
                low = index(after: mid)
            } else {
                high = mid
            }
        }
        return low
    }
    
    func insertAndRemove(_ indexSrc: Int, _ indexDst: Int, _ arr: inout [Element]) {
        let tmp = arr[indexSrc]
        var i = indexSrc - 1
        while i >= indexDst {
            arr[i + 1] = arr[i]
            i -= 1
        }
        arr[indexDst] = tmp
    }
    
    mutating func insertionSortAB() {
        for indexSrc in 0..<self.count {
            if let indexDst = binSearchIndex(self[..<indexSrc], self[indexSrc]) {
                // faster
                /*self.insert(self[indexSrc], at: indexDst)
                self.remove(at: indexSrc + 1)*/
                insertAndRemove(indexSrc, indexDst, &self)
            }
        }
    }
}

// shellSort
// St- | Ad- | Online-
extension Array where Element: Comparable {
    
    func gap1() -> [Int] {
        return sequence(first: self.count, next: { $0 / 2 } )
            .prefix(self.count)
            .filter { $0 > 0 }
    }
    
    func gap2() -> [Int] {
        var result = [Int]()
        var k = 0
        var elem = 0
        while elem > 0 || k == 0 {
            result.append(elem)
            k += 1
            elem = 2 * (self.count / Int(pow(Double(2), Double(k + 1)))) - 1
        }
        return result
    }
    
    func gap3() -> [Int] {
        var result = [Int]()
        var k = 1
        var elem = 1
        while elem < self.count {
            result.append(elem)
            k += 1
            elem = Int(pow(Double(2), Double(k))) - 1
        }
        return result.reversed()
    }
    
    enum GapType {
        case gap1, gap2, gap3
    }
    
    mutating func shellSort(_ gapType: GapType) {
        var gapList = [Int]()
        switch gapType {
        case .gap1:
            gapList = gap1()
        case .gap2:
            gapList = gap2()
        case .gap3:
            gapList = gap3()
        }
        for gap in gapList {
            var i = 0
            while i + gap < self.count {
                var j = i + gap
                let tmp = self[j]
                while j - gap >= 0 && self[j - gap] > tmp {
                    self.swapAt(j, j - gap)
                    j -= gap
                }
                i += 1
            }
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

let t = 100
var arr = Array(1...t)
arr.swapAt(0, t - 1)
Timer.share.start()
arr.bubbleSort()
Timer.share.stop("bubbleSort")
arr.sortAlert()

arr = Array(1...t)
arr.swapAt(0, t - 1)
Timer.share.start()
arr.bubbleSortAd()
Timer.share.stop("bubbleSortAd")
arr.sortAlert()

arr = Array(1...t)
arr.swapAt(0, t - 1)
Timer.share.start()
arr.insertionSort()
Timer.share.stop("insertionSort")
arr.sortAlert()

arr = Array(1...t)
arr.swapAt(0, t - 1)
Timer.share.start()
arr.insertionSortAB()
Timer.share.stop("insertionSortAB")
arr.sortAlert()

arr = Array(1...t)
arr.swapAt(0, t - 1)
Timer.share.start()
arr.shellSort(.gap1)
Timer.share.stop("shellSort gap1")
arr.sortAlert()

arr = Array(1...t)
arr.swapAt(0, t - 1)
Timer.share.start()
arr.shellSort(.gap2)
Timer.share.stop("shellSort gap2")
arr.sortAlert()

arr = Array(1...t)
arr.swapAt(0, t - 1)
Timer.share.start()
arr.shellSort(.gap3)
Timer.share.stop("shellSort gap3")
arr.sortAlert()
