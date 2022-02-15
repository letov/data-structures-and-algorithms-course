//
//  RLE.swift
//  Compression
//
//  Created by руслан карымов on 13.02.2022.
//

import Foundation

protocol Compressor {
    func clearBlock()
    func compressByByte(byte: Int8) -> [Int8]?
    func endBlock() -> [Int8]
    func clearData()
    func decompressByByte(byte: Int8) -> [Int8]?
    func endData() -> [Int8]
}


class RLE: Compressor {
    func stringToBytes(string: String) -> [UInt8] {
        return string.reduce(into: [UInt8]()) {
            $0.append(UInt8($1.asciiValue ?? 0))
        }
    }
    
    func bytesToString(bytes: [UInt8]) -> String {
        return String(data: Data(bytes), encoding: .utf8) ?? ""
    }
    
    func uIntToInt(data: [UInt8]) -> [Int8] {
        return data.reduce(into: [Int8]()) {
            $0.append(Int8(bitPattern: $1))
        }
    }
    
    func intToUInt(data: [Int8]) -> [UInt8] {
        return data.reduce(into: [UInt8]()) {
            $0.append(UInt8(bitPattern: $1))
        }
    }
    
    func compressSimple(data : [Int8]) -> [Int8] {
        guard data.count != 0 else {
            return []
        }
        var result = [Int8]()
        var before = data.first!
        var count: Int8 = 0
        for current in data {
            if before != current || count == Int8.max {
                result.append(count)
                result.append(before)
                before = current
                count = 0
            }
            count += 1
        }
        if count > 0 {
            result.append(count)
            result.append(before)
        }
        return result
    }
    
    var block = [Int8]()
    
    func blockNew(byte: Int8) {
        block.removeAll()
        block.append(0)
        block.append(byte)
    }

    func blockAddSame(repeatCount: Int = 0) {
        block[0] += block[0] == 0 ? 2 : 1
        if repeatCount == 0 {
            return
        }
        blockAddSame(repeatCount: repeatCount - 1)
    }
    
    func blockAddSingle(byte: Int8) {
        block.append(byte)
        block[0] = -(Int8(block.count) - 1)
    }
    
    func blockAdd(byte: Int8, state: State) {
        if state == .plus {
            blockAddSame()
        } else {
            blockAddSingle(byte: byte)
        }
    }
    
    func blockBackStep(repeatCount: Int = 0) {
        if block[0] < 0 {
            block[0] += 1
            block.removeLast()
        } else {
            block[0] -= 1
        }
        if repeatCount == 0 {
            return
        }
        blockBackStep(repeatCount: repeatCount - 1)
    }
    
    var isBlockOverflow: Bool {
        return block[0] == Int8.max || block[0] == Int8.min + 2
    }
    
    var isBlockDoubleTail: Bool {
        if block.count < 3 {
            return false
        }
        return block[block.count - 1] == block[block.count - 2]
    }
    
    enum State {
        case plus
        case minus
    }
    
    func int8ToState(value: Int8) -> State? {
        if value == 0 {
            return nil
        } else if value < 0 {
            return .minus
        } else {
            return .plus
        }
    }

    func changeState(fromMinusToPlus: Bool, byte: Int8) -> [Int8] {
        var block = [Int8]()
        if fromMinusToPlus {
            let repeatCount = isBlockDoubleTail ? 1 : 0
            blockBackStep(repeatCount: repeatCount)
            block = self.block
            blockNew(byte: byte)
            blockAddSame(repeatCount: repeatCount)
        } else {
            block = self.block
            blockNew(byte: byte)
        }
        return block
    }

    func compress(data: [Int8]) -> [Int8] {
        guard data.count > 0 else {
            return []
        }
        var result = [Int8]()
        blockNew(byte: data.first!)
        var i = 1
        while i < data.count {
            let byte = data[i]
            var state: State = byte == block.last! ? .plus : .minus
            let blockState = int8ToState(value: block[0])
            let fromMinusToPlus = blockState == .minus && state == .plus
            state = fromMinusToPlus && !isBlockDoubleTail ? .minus : state
            if blockState == nil || state == blockState {
                blockAdd(byte: byte, state: state)
                if isBlockOverflow {
                    result += changeState(fromMinusToPlus: false, byte: byte)
                    i += 1
                    if i < data.count {
                        blockNew(byte: data[i])
                    }
                }
            } else {
                result += changeState(fromMinusToPlus: fromMinusToPlus, byte: byte)
            }

            i += 1
        }
        result += block
        return result
    }
    
    func clearBlock() {
        block = []
    }
    
    func compressByByte(byte: Int8) -> [Int8]? {
        guard !block.isEmpty else {
            blockNew(byte: byte)
            return nil
        }
        var state: State = byte == block.last! ? .plus : .minus
        let blockState = int8ToState(value: block[0])
        let fromMinusToPlus = blockState == .minus && state == .plus
        state = fromMinusToPlus && !isBlockDoubleTail ? .minus : state
        var doneBlock: [Int8]?
        if blockState == nil || state == blockState {
            blockAdd(byte: byte, state: state)
            if isBlockOverflow {
                doneBlock = changeState(fromMinusToPlus: false, byte: byte)
                block = []
            }
        } else {
            doneBlock = changeState(fromMinusToPlus: fromMinusToPlus, byte: byte)
        }
        return doneBlock
    }
    
    func endBlock() -> [Int8] {
        if block != [] && block[0] == 0 {
            blockAddSame()
        }
        let result = block
        clearBlock()
        return result
    }
    
    func decompress(data: [Int8]) -> [Int8] {
        guard data.count > 1 else {
            return []
        }
        var result = [Int8]()
        var i = 0
        while i < data.count {
            let blockCount = data[i]
            if blockCount > 0 {
                guard i < data.count else {
                    return []
                }
                let byte = data[i + 1]
                result += (1...blockCount).reduce(into: [Int8]()) { acc, _ in
                    acc.append(byte)
                }
                i += 2
            } else {
                result += Array(data[(i + 1)...(i + abs(Int(blockCount)))])
                i += abs(Int(blockCount)) + 1 
            }
        }
        return result
    }
    
    var data = [Int8]()
    var blockCount = Int8.zero
    
    func clearData() {
        blockCount = Int8.zero
        data = []
    }
    
    func decompressByByte(byte: Int8) -> [Int8]? {
        guard blockCount != 0 else {
            let result = data
            clearData()
            blockCount = byte
            return result
        }
        if blockCount > 0 {
            let count = blockCount
            clearData()
            return [Int8].init(repeating: byte, count: Int(count))
        } else {
            blockCount += 1
            data.append(byte)
        }
        return nil
    }
    
    func endData() -> [Int8] {
        let result = data
        clearData()
        return result
    }
    
    func compressString(string: String) -> [Int8] {
        let data = uIntToInt(data: stringToBytes(string: string))
        return compress(data: data)
    }
    
    func decompressString(bytes: [Int8]) -> String {
        let bytes = intToUInt(data: decompress(data: bytes))
        return bytesToString(bytes: bytes)
    }
}

class CompressFile {
    let Int8Size = MemoryLayout<Int8>.size
    let compressor: Compressor
    let fileManager = FileManager.default
    let readBuffer = 10000

    init(compressor: Compressor) {
        self.compressor = compressor
    }

    func readInt8(file: FileHandle, seekOffset: Int) throws -> [Int8] {
        var bytes: [Int8]?
        do {
            try file.seek(toOffset: UInt64(seekOffset * Int8Size))
            let data = try file.read(upToCount: Int8Size * readBuffer)
            bytes = data?.reduce(into: [Int8]()) {
                $0.append(Int8(bitPattern: $1))
            }
        }
        if bytes == nil {
            return []
        } else {
            return bytes!
        }
    }
    
    func compressFile(inFilePath: String, outFilePath: String) throws {
        guard let file = FileHandle(forUpdatingAtPath: inFilePath) else {
            return
        }
        fileManager.createFile(atPath: outFilePath, contents: nil, attributes: nil)
        var buf = [Int8]()
        var seekOffset: Int = 0
        compressor.clearBlock()
        repeat {
            var data = [Int8]()
            var block: [Int8]?
            do {
                buf = try readInt8(file: file, seekOffset: seekOffset)
                for byte in buf {
                    block = compressor.compressByByte(byte: byte)
                    if block != nil {
                        data += block!
                    }
                }
                try writeInt8Buf(path: outFilePath, buf: data)
            }
            seekOffset += readBuffer
        } while !buf.isEmpty
        let endBlock = compressor.endBlock()
        try writeInt8Buf(path: outFilePath, buf: endBlock)
    }
    
    func writeInt8Buf(path: String, buf: [Int8]) throws {
        guard let file = FileHandle(forUpdatingAtPath: path) else {
            return
        }
        do {
            try file.seekToEnd()
            let data = Data(bytes: buf, count: buf.count)
            try file.write(contentsOf: data)
        }
    }
    
    func decompressFile(inFilePath: String, outFilePath: String) throws {
        guard let file = FileHandle(forUpdatingAtPath: inFilePath) else {
            return
        }
        fileManager.createFile(atPath: outFilePath, contents: nil, attributes: nil)
        var buf = [Int8]()
        var seekOffset: Int = 0
        compressor.clearData()
        repeat {
            var data: [Int8]?
            do {
                buf = try readInt8(file: file, seekOffset: seekOffset)
                for byte in buf {
                    data = compressor.decompressByByte(byte: byte)
                    if data != nil && !data!.isEmpty {
                        try writeInt8Buf(path: outFilePath, buf: data!)
                    }
                }
            }
            seekOffset += readBuffer
        } while !buf.isEmpty
        let endData = compressor.endData()
        try writeInt8Buf(path: outFilePath, buf: endData)
    }
}
