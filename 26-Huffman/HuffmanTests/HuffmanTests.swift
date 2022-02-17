//
//  HuffmanTests.swift
//  HuffmanTests
//
//  Created by руслан карымов on 15.02.2022.
//

import XCTest
import CryptoKit

class HuffmanTests: XCTestCase {
    
    var huffman: Huffman!
    var cf: CompressFile!

    override func setUpWithError() throws {
        try super.setUpWithError()
        huffman = Huffman()
        cf = CompressFile(compressor: huffman)
    }

    override func tearDownWithError() throws {
        huffman = nil
        cf = nil
        try super.tearDownWithError()
    }

    func testGetFrequency() throws {
        let data = huffman.stringToBytes(string: "AABBBCCCDDDDD")
        huffman.genFrequency(data: data)
        XCTAssertEqual(huffman.frequencyArr.count, 4)
    }
    
    func genString() -> String {
        var result = ""
        ["#:25","$:2",".:9","+:3","E:1"].forEach {
        //35     36    46    43    69
        //0      1100  10    111   1101
            let a = $0.components(separatedBy: ":")
            result += (0..<Int(a[1])!).reduce(into: "") { acc, _ in
                acc.append(a[0])
            }
        }
        return result
    }
    
    func genData() -> [Int8] {
        /*
         2 2 101
         0 5 00
         9 1 110
         3 2 100
         4 1 111
         1 5 01
         */
        return [0, 1, 1, 1, 1, 1, 3, 0, 3, 2, 2, 4, 0, 9, 0, 0]
    }
    
    func testCodes() throws {
        let data = huffman.stringToBytes(string: genString())
        huffman.genFrequency(data: data)
        huffman.genTree()
        let bitFlow = huffman.getCode(byte: 36)!
        XCTAssertEqual(bitFlow.asBinaryString, "1100")
    }
    
    func testGenMainBitFlow()  throws {
        var data = huffman.stringToBytes(string: genString())
        huffman.genFrequency(data: data)
        huffman.genTree()
        huffman.genCodes()
        data = huffman.stringToBytes(string: "##$$.E++")
        huffman.genMainBitFlow(data: data)
        XCTAssertEqual(huffman.mainBitFlow.asBinaryString,
                       "0011001100101101111111")
                   //   ^^^   ^   ^ ^   ^  ^
                   //   ##$   $   . E   +  +
        let string = (0..<1000).reduce(into: "") { acc, _ in
            acc.append(".") // 10
        }
        data = huffman.stringToBytes(string: string)
        huffman.genMainBitFlow(data: data)
        XCTAssertEqual(huffman.mainBitFlow.count, 1000 * 2)
    }

    func testCompressDecompress()  throws {
        let sourceData = huffman.stringToBytes(string: genString()) // 40 byte
        huffman.compress(data: sourceData)
        XCTAssertEqual(huffman.frequencyArr.count, 5) // 5 rows
        XCTAssertEqual(huffman.mainBitFlow.count, 64) // 8 byte
        let decompressData = huffman.decompress()!
        XCTAssertEqual(sourceData, decompressData)
    }
    
    /*func testIntToInt8Array()  throws {
        let data = Int.random(in: 0...Int.max)
        let arr = huffman.intToInt8Array(data: data)
        XCTAssertEqual(data.asBinaryString, arr.reduce(into: "") { $0 = $1.asBinaryString + $0 })
    }
    
    func testInt8ArrayToInt()  throws {
        let data = Int.random(in: 0...Int.max)
        let arr = huffman.intToInt8Array(data: data)
        XCTAssertEqual(data, huffman.int8ArrayToInt(data: arr))
    }*/
    
    func testSaveInt8ToIntHight() throws {
        let int8 = Int8(100)
        let int = Int(555555)
        XCTAssertEqual(huffman.saveInt8ToIntHight(int8: int8, int: int), 7205759403793349155)
    }
    
    func testReadInt8FromIntHight() throws {
        let int = Int(7205759403793349155)
        let (int8, newInt) = huffman.readInt8FromIntHight(int: int)
        XCTAssertEqual(int8, 100)
        XCTAssertEqual(newInt, 555555)
    }

    func testPackUnpackMainBitFlow() throws {
        let data = huffman.stringToBytes(string: genString())
        huffman.genFrequency(data: data)
        huffman.genTree()
        huffman.genCodes()
        huffman.genMainBitFlow(data: data)
        let origMainBitFlow = huffman.mainBitFlow
        let pack = huffman.packMainBitFlow()
        huffman.unpackMainBitFlow(data: pack)
        let unpackMainBitFlow = huffman.mainBitFlow
        XCTAssertEqual(origMainBitFlow, unpackMainBitFlow)
    }
    
    func testPackUnpack() throws {
        let data = huffman.stringToBytes(string: genString())
        let pack = huffman.pack(data: data)
        let clearHuffman = Huffman()
        let unpack = clearHuffman.unpack(data: pack)
        XCTAssertEqual(data, unpack)
    }
    
    func testNewData() {
        let data: [Int8] = genData()
        let pack = huffman.pack(data: data)
        let clearHuffman = Huffman()
        let unpack = clearHuffman.unpack(data: pack)
        XCTAssertEqual(huffman.mainBitFlow, clearHuffman.mainBitFlow)
        XCTAssertEqual(data, unpack)
    }
    
    func testCompressDecompressFile() throws {
        let inFilePath = (#file as NSString).deletingLastPathComponent + "/1.txt"
        let outFilePathCompress = inFilePath + ".compress"
        let outFilePathDecompress = inFilePath + ".decompress"
        try cf.compressFile(inFilePath: inFilePath, outFilePath: outFilePathCompress)
        try cf.decompressFile(inFilePath: outFilePathCompress, outFilePath: outFilePathDecompress)
        var data = FileManager.default.contents(atPath: inFilePath)!
        let hash1 = SHA256.hash(data: data)
        data = FileManager.default.contents(atPath: outFilePathDecompress)!
        let hash2 = SHA256.hash(data: data)
        XCTAssertEqual(hash1, hash2)
    }
}
