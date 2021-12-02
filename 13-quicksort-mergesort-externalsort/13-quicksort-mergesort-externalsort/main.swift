//
//  main.swift
//  13-quicksort-mergesort-externalsort
//
//  Created by руслан карымов on 02.12.2021.
//

import Foundation

extension Array where Element: Comparable {
    
    /// quickSort
    
    func _quickSort(_ slice: inout ArraySlice<Element>) -> ArraySlice<Element> {
        guard slice.count > 1 else {
            return slice
        }
        var i = slice.startIndex
        var j = index(before: slice.endIndex)
        let pivot = slice[j]
        while i <= j {
            if slice[i] <= pivot {
                i = index(after: i)
            } else if slice[j] > pivot {
                j = index(before: j)
            } else {
                slice.swapAt(i, j)
            }
        }
        if j < slice.startIndex {
            j = slice.startIndex
            i = index(after: j)
        }
        if i >= slice.endIndex {
            i = index(before: slice.endIndex)
            j = index(before: i)
        }
        return _quickSort(&slice[...j]) + _quickSort(&slice[i...])
    }
    
    func _quickSortSwifty(_ arr: Array<Element>) -> Array<Element> {
        guard arr.count > 1 else {
            return arr
        }
        let pivot = arr.last!
        let low = arr.filter { $0 < pivot }
        let eq = arr.filter { $0 == pivot }
        let high = arr.filter { $0 > pivot }
        return _quickSortSwifty(low) + eq + _quickSortSwifty(high)
    }
    
    /// timSort
    
    func _timSort(_ slice: inout ArraySlice<Element>) -> ArraySlice<Element> {
        guard slice.count > 1 else {
            return slice
        }
        let pivot = slice.last!
        var a = slice.startIndex - 1
        for i in stride(from: slice.startIndex, to: slice.endIndex, by: 1) {
            if slice[i] <= pivot {
                a = index(after: a)
                slice.swapAt(a, i)
            }
        }
        return _timSort(&slice[..<a]) + slice[a...a] + _timSort(&slice[(a + 1)...])
    }
    
    func quickSorted() -> [Element] {
        var slice = ArraySlice(self)
        return Array(_quickSort(&slice))
    }
    
    func quickSortedSwifty() -> [Element] {
        let slice = ArraySlice(self)
        return _quickSortSwifty(Array(slice))
    }
    
    func timSorted() -> [Element] {
        var slice = ArraySlice(self)
        return Array(_timSort(&slice))
    }
    
    /// mergeSort
    
    func merge(_ left: ArraySlice<Element>, _ right: ArraySlice<Element>) -> ArraySlice<Element> {
        var leftIndex = 0
        var rightIndex = 0
        var result = ArraySlice<Element>()
        while leftIndex < left.count && rightIndex < right.count {
            if left[left.startIndex + leftIndex] < right[right.startIndex + rightIndex] {
                result.append(left[left.startIndex + leftIndex])
                leftIndex = index(after: leftIndex)
            } else if left[left.startIndex + leftIndex] > right[right.startIndex + rightIndex] {
                result.append(right[right.startIndex + rightIndex])
                rightIndex = index(after: rightIndex)
            } else {
                result.append(left[left.startIndex + leftIndex])
                leftIndex = index(after: leftIndex)
                result.append(right[right.startIndex + rightIndex])
                rightIndex = index(after: rightIndex)
            }
        }
        if leftIndex < left.count {
            result += left[(left.startIndex + leftIndex)...]
        } else if rightIndex < right.count {
            result += right[(right.startIndex + rightIndex)...]
        }
        return result
    }
    
    func _mergeSort(_ slice: inout ArraySlice<Element>) -> ArraySlice<Element> {
        guard slice.count > 1 else {
            return slice
        }
        let half = slice.startIndex + Int(slice.count / 2)
        let left = _mergeSort(&slice[..<half])
        let right = _mergeSort(&slice[half...])
        return merge(left, right)
    }
    
    func mergeSorted() -> [Element] {
        var slice = ArraySlice(self)
        return Array(_mergeSort(&slice))
    }
}

struct SortFileContent {
    let path: String
    let N: UInt64
    let K: Int              //  block size < K -> sort in memory
    var file: FileHandle?
    let fileManager = FileManager.default
    let uInt16Size = MemoryLayout<UInt16>.size

    init?(pathToFile: String, N: UInt64, K: Int) {
        path = pathToFile + "/\(N)"
        self.N = N
        self.K = K
        genFile()
    }

    func readUInt16File(_ fileHandle: FileHandle?, _ seekOffset: UInt64) -> UInt16 {
        try! fileHandle?.seek(toOffset: seekOffset * UInt64(uInt16Size))
        let bytes = try! fileHandle?.read(upToCount: uInt16Size)
        return bytes!.withUnsafeBytes { $0.load(as: UInt16.self) }
    }
    
    func writeUInt16File(_ fileHandle: FileHandle?, _ value: inout UInt16, _ seekOffset: UInt64) -> UInt64 {
        try! fileHandle?.seek(toOffset: seekOffset * UInt64(uInt16Size))
        let data = Data(bytes: &value, count: MemoryLayout<UInt16>.size)
        try! fileHandle?.write(contentsOf: data)
        return seekOffset + 1
    }

    mutating func genFile() {
        fileManager.createFile(atPath: path, contents: nil, attributes: nil)
        file = FileHandle(forUpdatingAtPath: path)
        var i: UInt64 = 0
        while i < N {
            var value = UInt16.random(in: UInt16.zero...UInt16.max)
            i = writeUInt16File(file, &value, i)
        }
    }
    
    struct Side {
        let offset: UInt64
        let count: UInt64
        var half: UInt64 { count / 2 }
    }
    
    func mergeExternal(_ left: Side, _ right: Side) -> Side {
        let tmpPath = "\(path)_tmp"
        fileManager.createFile(atPath: tmpPath, contents: nil, attributes: nil)
        defer {
            try! fileManager.removeItem(atPath: tmpPath)
        }
        let tmpFile = FileHandle(forUpdatingAtPath: tmpPath)
        var leftIndex: UInt64 = 0
        var rightIndex: UInt64 = 0
        var tmpOffset: UInt64 = 0
        while leftIndex < left.count && rightIndex < right.count {
            var leftValue = readUInt16File(file, left.offset + leftIndex)
            var rightValue = readUInt16File(file, right.offset + rightIndex)
            if leftValue < rightValue {
                tmpOffset = writeUInt16File(tmpFile, &leftValue, tmpOffset)
                leftIndex += 1
            } else if leftValue > rightValue {
                tmpOffset = writeUInt16File(tmpFile, &rightValue, tmpOffset)
                rightIndex += 1
            } else {
                tmpOffset = writeUInt16File(tmpFile, &leftValue, tmpOffset)
                leftIndex += 1
                tmpOffset = writeUInt16File(tmpFile, &rightValue, tmpOffset)
                rightIndex += 1
            }
        }
        if leftIndex < left.count {
            while leftIndex < left.count {
                var value = readUInt16File(file, left.offset + leftIndex)
                leftIndex += 1
                tmpOffset = writeUInt16File(tmpFile, &value, tmpOffset)
            }
        } else if rightIndex < right.count {
            while rightIndex < right.count {
                var value = readUInt16File(file, right.offset + rightIndex)
                rightIndex += 1
                tmpOffset = writeUInt16File(tmpFile, &value, tmpOffset)
            }
        }
        for i: UInt64 in 0..<(left.count + right.count) {
            var value = readUInt16File(tmpFile, i)
            _ = writeUInt16File(file, &value, left.offset + i)
        }
        return Side(offset: left.offset, count: left.count + right.count)
    }
    
    func memSort(_ side: Side) -> Side {
        var buf = [UInt16]()
        for offset in side.offset..<(side.offset + side.count) {
            buf.append(readUInt16File(file, offset))
        }
        buf = buf.timSorted()
        for i in buf.enumerated() {
            var value = i.element
            _ = writeUInt16File(file, &value, side.offset + UInt64(i.offset))
        }
        return side
    }
    
    func _mergeExternalSort(_ side: Side) -> Side {
        guard side.count > 1 else {
            return side
        }
        guard side.count > K else {
            return memSort(side)
        }
        let left = _mergeExternalSort(Side(offset: side.offset, count: side.half))
        let right = _mergeExternalSort(Side(offset: side.offset + side.half, count: side.count - side.half))
        return mergeExternal(left, right)
    }

    func mergeExternalSort() {
        _ = _mergeExternalSort(Side(offset: 0, count: N))
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

/*let t = 1000000
var arr = Array(1...t)
arr.reverse()
Timer.share.start()
arr = arr.quickSorted()
Timer.share.stop("quickSorted")
arr.sortAlert()

arr.reverse()
Timer.share.start()
arr = arr.quickSortedSwifty()
Timer.share.stop("quickSortedSwifty")
arr.sortAlert()

arr.reverse()
Timer.share.start()
arr = arr.timSorted()
Timer.share.stop("timSorted")
arr.sortAlert()

arr.reverse()
Timer.share.start()
arr = arr.mergeSorted()
Timer.share.stop("mergeSorted")
arr.sortAlert()*/

var sortFileContent = SortFileContent(pathToFile: "/Users/ruslankarymov/Desktop", N: 1000, K: 100)
Timer.share.start()
sortFileContent?.mergeExternalSort()
Timer.share.stop("mergeExternalSort")
