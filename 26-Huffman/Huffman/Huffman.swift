//
//  Huffman.swift
//  Huffman
//
//  Created by руслан карымов on 15.02.2022.
//

import Foundation

extension BinaryInteger {
    func bit(at index: Int) -> Bool {
        return (self >> index) & 1 == 1
    }
    
    mutating func setBit(at index: Int, to bool: Bool) {
        if bool {
        self |= (1 << index)
        } else {
        self &= ~(1 << index)
        }
    }
    var asBinaryString: String {
        var result = String()
        for i in 0..<self.bitWidth {
            result = (bit(at: i) ? "1" : "0") + result
        }
        return result
    }
}

class BitFlow: Equatable {
    var storage = [Int]()
    var count = 0
    
    init() {
    }
    
    init(firstBit: Bool) {
        var first = Int()
        if firstBit {
            first.setBit(at: Int.bitWidth - 1, to: true)
        }
        storage.append(first)
        count = 1
    }
    
    func clear() {
        storage = []
        count = 0
    }
    
    func add(bitFlow: BitFlow) {
        let newCount = count + bitFlow.count
        let (storageIndex, _) = getStorageIndex(index: newCount)
        while storageIndex >= storage.count {
            storage.append(0)
        }
        for storageValue in bitFlow.storage {
            for i in 0..<Int.bitWidth {
                if count >= newCount {
                    return
                }
                let bit = storageValue.bit(at: Int.bitWidth - i - 1)
                if bit {
                    let (storageIndex, bitIndex) =  getStorageIndex(index: count)
                    storage[storageIndex].setBit(at: Int.bitWidth - bitIndex - 1, to: true)
                }
                count += 1
            }
        }
    }

    var asBinaryString: String {
        return String(storage.reduce(into: "") { $0 += $1.asBinaryString }.prefix(count))
    }
    
    func getStorageIndex(index: Int) -> (storageIndex: Int, bitIndex: Int) {
        let storageIndex = Int(floor(Double(index) / Double(Int.bitWidth)))
        let bitIndex = index % Int.bitWidth
        return (storageIndex: storageIndex, bitIndex: bitIndex)
    }
    
    func bit(at index: Int) -> Bool? {
        let (storageIndex, bitIndex) = getStorageIndex(index: index)
        guard storageIndex < storage.count else {
            return nil
        }
        return storage[storageIndex].bit(at: Int.bitWidth - bitIndex - 1)
    }
    
    static func == (lhs: BitFlow, rhs: BitFlow) -> Bool {
        return lhs.storage == rhs.storage && lhs.count == rhs.count
    }
}

class TreeNode {
    var left: TreeNode?
    var right: TreeNode?
    var byte: Int8?
    init(left: TreeNode?, right: TreeNode?, byte: Int8?) {
        self.left = left
        self.right = right
        self.byte = byte
    }
}

protocol Compressor {
    func pack(data: [Int8]) -> [Int]
    func unpack(data: [Int]) -> [Int8]?
}

class Huffman: Compressor {
    var root: TreeNode?
    var frequencyArr = [(Int8, Int)]()
    var codesTable = [Int8: BitFlow]()
    var mainBitFlow = BitFlow()

    func stringToBytes(string: String) -> [Int8] {
        return string.reduce(into: [Int8]()) {
            $0.append(Int8($1.asciiValue ?? 0))
        }
    }
    
    func bytesToString(bytes: [Int8]) -> String {
        return String(data: Data(bytes.map {
            UInt8(bitPattern: $0)
        }), encoding: .utf8) ?? ""
    }
    
    func genFrequency(data: [Int8]) {
        var frequencyTable = [Int8: Int]()
        for byte in data {
            frequencyTable[byte] = (frequencyTable[byte] ?? 0) + 1
        }
        frequencyArr = frequencyTable.sorted(by: <)
    }
    
    func genTree() {
        root = nil
        var queue = PriorityQueue<TreeNode>()
        for (byte, prioritry) in frequencyArr {
            queue.enqueue(prioritry, TreeNode(left: nil, right: nil, byte: byte))
        }
        while !queue.isEmpty {
            let _right = queue.dequeue()
            let _left = queue.dequeue()
            guard let right = _right, let left = _left else {
                root = _right?.item ?? _left?.item
                return
            }
            let prioritry = right.priority + left.priority
            let node = TreeNode(left: left.item, right: right.item, byte: nil)
            queue.enqueue(prioritry, node)
        }
    }
    
    func getCode(byte: Int8) -> BitFlow? {
        return getCode(byte: byte, node: root)
    }
    
    func getCode(byte: Int8, node: TreeNode?) -> BitFlow? {
        guard let node = node else {
            return nil
        }
        if node.byte == byte {
            return BitFlow()
        }
        let _right = getCode(byte: byte, node: node.right)
        let _left = getCode(byte: byte, node: node.left)
        guard let nextBitFlow = _right ?? _left else {
            return nil
        }
        let bitFlow = _left != nil ? BitFlow(firstBit: false) : BitFlow(firstBit: true)
        bitFlow.add(bitFlow: nextBitFlow)
        return bitFlow
    }
    
    func genCodes() {
        codesTable.removeAll()
        for (byte, _) in frequencyArr {
            codesTable[byte] = getCode(byte: byte)
        }
    }
    
    func genMainBitFlow(data: [Int8]) {
        mainBitFlow.clear()
        for byte in data {
            if let bitFlow = codesTable[byte] {
                mainBitFlow.add(bitFlow: bitFlow)
            }
        }
    }
    
    func compress(data: [Int8]) {
        genFrequency(data: data)
        genTree()
        genCodes()
        genMainBitFlow(data: data)
    }
    
    func getByte(bitFlow: BitFlow) -> Int8? {
        guard let bit = bitFlow.bit(at: 0) else {
            return nil
        }
        guard let root = root else {
            return nil
        }
        let nextNode = bit ? root.right : root.left
        return getByte(bitFlow: bitFlow, node: nextNode, bitIndex: 1)
    }
    
    func getByte(bitFlow: BitFlow, node: TreeNode?, bitIndex: Int) -> Int8? {
        guard bitIndex <= bitFlow.count else {
            return nil
        }
        guard let node = node else {
            return nil
        }
        guard let bit = bitFlow.bit(at: bitIndex) else {
            return nil
        }
        guard node.byte == nil else {
            return node.byte!
        }
        let nextNode = bit ? node.right : node.left
        return getByte(bitFlow: bitFlow, node: nextNode, bitIndex: bitIndex + 1)
    }
    
    func decompress() -> [Int8]? {
        genTree()
        var result = [Int8]()
        var bitFlow = BitFlow()
        for bitIndex in 0..<mainBitFlow.count {
            guard let bit = mainBitFlow.bit(at: bitIndex) else {
                return nil
            }
            bitFlow.add(bitFlow: BitFlow(firstBit: bit))
            if let byte = getByte(bitFlow: bitFlow) {
                result.append(byte)
                bitFlow = BitFlow()
            }
        }
        return result
    }
    
    /*func intToInt8Array(data: Int) -> [Int8] {
        var result = [Int8]()
        for i in 0..<8 {
            result.append(Int8(truncatingIfNeeded: data >> (i * Int8.bitWidth)))
        }
        return result
    }
    
    func int8ArrayToInt(data: [Int8]) -> Int {
        var result = UInt.zero
        for (i, elem) in data.enumerated() {
            result |= UInt(UInt8(truncatingIfNeeded: elem)) << (i * Int8.bitWidth)
        }
        return Int(truncatingIfNeeded: result)
    }*/
    
    // 11001100
    // 00000000 ... 0100101
    // 11001100 ... 0100101
    func saveInt8ToIntHight(int8: Int8, int: Int) -> Int {
        return int | Int(truncatingIfNeeded:(UInt(UInt8(truncatingIfNeeded: int8)) << (7 * Int8.bitWidth)))
    }
    
    func readInt8FromIntHight(int: Int) -> (Int8, Int) {
        var int8 = Int8.zero
        var int = int
        int8 = Int8(truncatingIfNeeded:int >> (7 * Int8.bitWidth))
        int <<= 8
        int >>= 8
        return (int8, int)
    }
    
    // frequencyArr: [Int8: Int]
    //                       | size
    // count: Int8 x 8       | 8
    //        byte  frequency
    // row 0: Int8  Int8 x 7 | 8
    // row 1: ...
    func packFrequencyTable() -> [Int] {
        var result = [Int]()
        result.append(frequencyArr.count)
        for (byte, frequency) in frequencyArr {
            result.append(saveInt8ToIntHight(int8: byte, int: frequency))
        }
        return result
    }
    
    func unpackFrequencyTable(data: [Int]) {
        frequencyArr.removeAll()
        var frequencyTable = [Int8: Int]()
        guard data.count > 0 else {
            return
        }
        let count = data[0]
        guard data.count == count + 1 else {
            return
        }
        for i in 1...count {
            let (byte, frequency) = readInt8FromIntHight(int: data[i])
            frequencyTable[byte] = frequency
        }
        frequencyArr = frequencyTable.sorted(by: <)
    }
    
    // countBit: Int
    // data: [Int]
    func packMainBitFlow() -> [Int] {
        var result = [Int]()
        result.append(mainBitFlow.count)
        result += mainBitFlow.storage
        return result
    }
    
    func unpackMainBitFlow(data: [Int]) {
        mainBitFlow.clear()
        guard data.count > 0 else {
            return
        }
        mainBitFlow.count = data[0]
        mainBitFlow.storage = data
        mainBitFlow.storage.removeFirst()
    }
    
    func pack(data: [Int8]) -> [Int] {
        compress(data: data)
        let packFrequencyTable = packFrequencyTable()
        let packMainBitFlow = packMainBitFlow()
        return packFrequencyTable + packMainBitFlow
    }
    
    func unpack(data: [Int]) -> [Int8]? {
        guard data.count > 0 else {
            return nil
        }
        let frequencyCount = data[0]
        guard data.count > frequencyCount else {
            return nil
        }
        unpackFrequencyTable(data: Array(data[0...frequencyCount]))
        unpackMainBitFlow(data: Array(data[(frequencyCount + 1)..<data.count]))
        return decompress()
    }
}

class CompressFile {
    let compressor: Compressor
    let fileManager = FileManager.default
    init(compressor: Compressor) {
        self.compressor = compressor
    }

    func read(file: FileHandle, seekOffset: Int, readBufferSize: Int) throws -> Data? {
        let Int8Size = MemoryLayout<Int8>.size
        var data: Data?
        do {
            try file.seek(toOffset: UInt64(Int8Size * seekOffset))
            data = try file.read(upToCount: Int8Size * readBufferSize)
        }
        return data
    }
    
    func write(path: String, data: Data) throws {
        guard let file = FileHandle(forUpdatingAtPath: path) else {
            return
        }
        do {
            try file.seekToEnd()
            try file.write(contentsOf: data)
        }
    }
    
    func compressFile(inFilePath: String, outFilePath: String) throws {
        guard let file = FileHandle(forUpdatingAtPath: inFilePath) else {
            return
        }
        let fileSize = try! FileManager.default.attributesOfItem(atPath: inFilePath)[.size] as! Int
        fileManager.createFile(atPath: outFilePath, contents: nil, attributes: nil)
        var seekOffset: Int = 0
        let readBufferSize = 100000
        repeat {
            do {
                guard let data = try read(file: file, seekOffset: seekOffset, readBufferSize: readBufferSize) else {
                    return
                }
                let bytes = data.reduce(into: [Int8]()) {
                    $0.append(Int8(bitPattern: $1))
                }
                var pack = compressor.pack(data: bytes)
                pack = [pack.count] + pack
                let dataWrite = pack.withUnsafeBufferPointer {
                    Data(buffer: $0)
                }
                try write(path: outFilePath, data: dataWrite)
            }
            seekOffset += readBufferSize
        } while seekOffset < fileSize
    }

    func decompressFile(inFilePath: String, outFilePath: String) throws {
        let IntSize = MemoryLayout<Int>.size
        guard let file = FileHandle(forUpdatingAtPath: inFilePath) else {
            return
        }
        let fileSize = try! FileManager.default.attributesOfItem(atPath: inFilePath)[.size] as! Int
        fileManager.createFile(atPath: outFilePath, contents: nil, attributes: nil)
        var seekOffset: Int = 0
        var packCount: Int = 0
        repeat {
            do {
                guard let dataCount = try read(file: file, seekOffset: seekOffset, readBufferSize: IntSize) else {
                    return
                }
                packCount = dataCount.withUnsafeBytes {
                    $0.load(as: Int.self)
                }
                seekOffset += IntSize
                guard let data = try read(file: file, seekOffset: seekOffset, readBufferSize: packCount * IntSize) else {
                    return
                }
                let bytes: [Int] = data.withUnsafeBytes {
                    let unsafeBufferPointer = $0.bindMemory(to: Int.self)
                    let unsafePointer = unsafeBufferPointer.baseAddress!
                    return [Int](UnsafeBufferPointer<Int>(start: unsafePointer, count: packCount))
                }
                seekOffset += packCount * IntSize
                guard let unpack = compressor.unpack(data: bytes) else {
                    return
                }
                let dataWrite = unpack.withUnsafeBufferPointer {
                    Data(buffer: $0)
                }
                try write(path: outFilePath, data: dataWrite)
            }
        } while seekOffset < fileSize
    }
}
