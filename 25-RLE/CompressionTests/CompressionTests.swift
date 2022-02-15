//
//  CompressionTests.swift
//  CompressionTests
//
//  Created by руслан карымов on 13.02.2022.
//

import XCTest
import CryptoKit

class CompressionTests: XCTestCase {
    
    var rle: RLE!
    var cfRle: CompressFile!

    override func setUpWithError() throws {
        try super.setUpWithError()
        rle = RLE()
        cfRle = CompressFile(compressor: rle)
    }

    override func tearDownWithError() throws {
        rle = nil
        cfRle = nil
        try super.tearDownWithError()
    }

    func testStringToBytes() throws {
        XCTAssertEqual(rle.stringToBytes(string: "ABAABA"), [65, 66, 65, 65, 66, 65])
    }
    
    func testUIntToInt() throws {
        XCTAssertEqual(rle.uIntToInt(data: [0, 127, 128, 255]), [0, 127, -128, -1])
    }
    
    func testIntToUInt() throws {
        XCTAssertEqual(rle.intToUInt(data: [0, 127, -1, -128]), [0, 127, 255, 128])
    }
    
    func testCompressSimple() throws {
        let data = rle.uIntToInt(data: rle.stringToBytes(string: "ABAABA"))
        let compress = rle.compressSimple(data: data)
        XCTAssertEqual(compress, [1, 65, 1, 66, 2, 65, 1, 66, 1, 65])
    }

    func testCompress() throws {
        var data = rle.uIntToInt(data: rle.stringToBytes(string: "AABBCCCAS"))
        XCTAssertEqual(rle.compress(data: data), [2, 65, 2, 66, 3, 67, -2, 65, 83])
        data = rle.uIntToInt(data: rle.stringToBytes(string: "ABBABCCCDDDSDSA"))
        XCTAssertEqual(rle.compress(data: data), [-5, 65, 66, 66, 65, 66, 3, 67, 3, 68, -4, 83, 68, 83, 65])
        data = rle.uIntToInt(data: rle.stringToBytes(string: "ABBABCCC"))
        XCTAssertEqual(rle.compress(data: data), [-5, 65, 66, 66, 65, 66, 3, 67])
        let A128 = (1...128).reduce(into: "") { acc, _ in
            acc += "A"
        }
        data = rle.uIntToInt(data: rle.stringToBytes(string: A128 + "BB"))
        XCTAssertEqual(rle.compress(data: data), [127, 65, -3, 65, 66, 66])
        data = rle.uIntToInt(data: rle.stringToBytes(string: "FGHHIG"))
        XCTAssertEqual(rle.compress(data: data), [-6, 70, 71, 72, 72, 73, 71])
        let bytes = (0...127).reduce(into: [Int8]()) { acc, byte in
            acc.append(byte)
        }
        XCTAssertEqual(rle.compress(data: bytes + bytes).count, 128 * 2 + 3)
    }
    
    func testDecompress() throws {
        let data = rle.uIntToInt(data: rle.stringToBytes(string: "AABBCCCAS"))
        let compress = rle.compress(data: data)
        let bytes = rle.intToUInt(data: rle.decompress(data: compress))
        XCTAssertEqual(rle.bytesToString(bytes: bytes), "AABBCCCAS")
    }
    
    func testReadInt8() throws {
        let filePath = (#file as NSString).deletingLastPathComponent + "/file1"
        guard let file = FileHandle(forUpdatingAtPath: filePath) else {
            return
        }
        let bytes = try cfRle.readInt8(file: file, seekOffset: 0)
        XCTAssertEqual(bytes, [-128, -127, -126, -125])
    }
    
    func testCompressDecompressFile() throws {
        let inFilePath = (#file as NSString).deletingLastPathComponent + "/1.png"
        let outFilePathCompress = (#file as NSString).deletingLastPathComponent + "/1.png.compress"
        let outFilePathDecompress = (#file as NSString).deletingLastPathComponent + "/decompress.png"
        try cfRle.compressFile(inFilePath: inFilePath, outFilePath: outFilePathCompress)
        try cfRle.decompressFile(inFilePath: outFilePathCompress, outFilePath: outFilePathDecompress)
        var data = FileManager.default.contents(atPath: inFilePath)!
        let hash1 = SHA256.hash(data: data)
        data = FileManager.default.contents(atPath: outFilePathDecompress)!
        let hash2 = SHA256.hash(data: data)
        XCTAssertEqual(hash1, hash2)
    }
    
    func testEffective() throws {
        let files = ["1.png","1.txt","1.bmp","1.zip"]
        for file in files {
            let inFilePath = (#file as NSString).deletingLastPathComponent + "/" + file
            let outFilePathCompress = inFilePath + ".compress"
            try cfRle.compressFile(inFilePath: inFilePath, outFilePath: outFilePathCompress)
            let sizeOrig = try FileManager.default.attributesOfItem(atPath: inFilePath)[.size] as! Int
            let sizeCompressed = try  FileManager.default.attributesOfItem(atPath: outFilePathCompress)[.size] as! Int
            let effective: Float = ((Float(sizeOrig) - Float(sizeCompressed)) / Float(sizeOrig)) * 100.0
            print(inFilePath, effective)
        }
    }
}
