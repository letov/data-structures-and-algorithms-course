//
//  main.swift
//  Ideal
//
//  Created by руслан карымов on 09.01.2022.
//

import Foundation

protocol HashMap {
    associatedtype Value
    associatedtype Map
    var hashTable: Array<Map?> { get set }
    var size: Int { get set }
    func getHashCode(key: String) -> UInt
    func hash(key: String) -> Int
    mutating func add(key: String, value: Value)
    func search(key: String) -> Value?
}

class EngRusDicParser: NSObject, XMLParserDelegate {
    var xmlParser: XMLParser!
    var currentAr = Bool()
    var currentK = Bool()
    var currentTranslate = Bool()
    var currentEng = ""
    var currentRus = ""
    var parsedData = [String: String]()
 
    init(url: URL) {
        super.init()
        let parser = XMLParser(contentsOf: url)
        parser?.delegate = self
        parser?.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentAr = elementName == "ar"
        currentK = elementName == "k"
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let string = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if currentK {
            currentEng = string
        } else if currentAr && string == "\"" {
            currentTranslate.toggle()
        } else if currentTranslate {
            currentRus = string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentAr = !(elementName == "ar")
        currentK = !(elementName == "k")
        if (!currentAr) {
            parsedData[currentEng] = currentRus
        }
    }
}

struct EngRusDic {
    let file: URL
    let data: [String: String]
    init(fileName: String) {
        file = URL(fileURLWithPath: fileName)
        let engRusDicParser = EngRusDicParser(url: file)
        data = engRusDicParser.parsedData
    }
}

struct HashFunc {
    static let P: UInt = 655360001
    static var randA: UInt { UInt.random(in: 1..<P) }
    static var randB: UInt { UInt.random(in: 0...P) }
    
    static func pearson(key: String, maxByte: Int = 8) -> UInt {
        let table: Array<UInt8> = Array(arrayLiteral:
            98,  6, 85,150, 36, 23,112,164,135,207,169,  5, 26, 64,165,219, //  1
            61, 20, 68, 89,130, 63, 52,102, 24,229,132,245, 80,216,195,115, //  2
            90,168,156,203,177,120,  2,190,188,  7,100,185,174,243,162, 10, //  3
            237, 18,253,225,  8,208,172,244,255,126,101, 79,145,235,228,121, //  4
            123,251, 67,250,161,  0,107, 97,241,111,181, 82,249, 33, 69, 55, //  5
            59,153, 29,  9,213,167, 84, 93, 30, 46, 94, 75,151,114, 73,222, //  6
            197, 96,210, 45, 16,227,248,202, 51,152,252,125, 81,206,215,186, //  7
            39,158,178,187,131,136,  1, 49, 50, 17,141, 91, 47,129, 60, 99, //  8
            154, 35, 86,171,105, 34, 38,200,147, 58, 77,118,173,246, 76,254, //  9
            133,232,196,144,198,124, 53,  4,108, 74,223,234,134,230,157,139, // 10
            189,205,199,128,176, 19,211,236,127,192,231, 70,233, 88,146, 44, // 11
            183,201, 22, 83, 13,214,116,109,159, 32, 95,226,140,220, 57, 12, // 12
            221, 31,209,182,143, 92,149,184,148, 62,113, 65, 37, 27,106,166, // 13
            3, 14,204, 72, 21, 41, 56, 66, 28,193, 40,217, 25, 54,179,117, // 14
            238, 87,240,155,180,170,242,212,191,163, 78,218,137,194,175,110, // 15
            43,119,224, 71,122,142, 42,160,104, 48,247,103, 15, 11,138,239  // 16
        )
        var hash: UInt = 0
        for i in 0...(maxByte - 1) {
            var _hash: UInt8 = table[(Int(key.first?.asciiValue ?? 0) + i) % 256]
            for j in key {
                _hash = table[Int(_hash ^ UInt8(j.asciiValue ?? 0))]
            }
            hash += UInt(_hash) << (i * 8)
        }
        return hash
    }
    
    static func universal(key: UInt, A: UInt, B: UInt, M: Int) -> Int {
        return M == 0 ? 0 : Int(((UInt(A &* key) + B) % P) % UInt(M))
    }
}

struct IdealHashMap<V>: HashMap {
    var A: UInt
    var B: UInt
    
    struct HashMapi {
        var Ai: UInt
        var Bi: UInt
        var Ki: Int
        typealias Mapi = (key: String, value: V)
        
        var hashTablei: Array<Mapi?>
        var size = Int()
        
        init() {
            size = 0
            Ki = 0
            Ai = HashFunc.randA
            Bi = HashFunc.randB
            hashTablei = Array<Mapi?>.init(repeating: nil, count: 1)
        }
        
        func getHashCodei(key: String) -> UInt {
            return HashFunc.pearson(key: key)
        }
        
        func hashi(key: String) -> Int {
            let hashCode = getHashCodei(key: key)
            return HashFunc.universal(key: hashCode, A: Ai, B: Bi, M: Ki)
        }
        
        mutating func updatei(key: String, value: V) -> Bool {
            let idx = hashi(key: key)
            if hashTablei[idx] != nil && hashTablei[idx]!.key == key {
                hashTablei[idx] = (key: key, value: value)
                return true
            } else {
                return false
            }
        }
        
        mutating func addi(key: String, value: V) {
            if updatei(key: key, value: value) {
                return
            }
            size += 1
            Ki = size * size
            let oldHashTablei = hashTablei
            while true {
                hashTablei = Array<Mapi?>.init(repeating: nil, count: Ki)
                let idx = hashi(key: key)
                hashTablei[idx] = (key: key, value: value)
                var _size = 1
                for map in oldHashTablei {
                    if let map = map {
                        let idx = hashi(key: map.key)
                        if hashTablei[idx] != nil {
                            break
                        } else {
                            hashTablei[idx] = (key: map.key, value: map.value)
                            _size += 1
                        }
                    }
                }
                if size == _size{
                    break
                }
                Ai = HashFunc.randA
                Bi = HashFunc.randB
            }
        }
        
        func search(key: String) -> V? {
            let idx = hashi(key: key)
            return hashTablei[idx]?.value
        }
    }
    
    typealias Value = V
    typealias Map = HashMapi
    var hashTable: Array<Map?>
    var size = Int()
    
    var collisionCounter = Array<Int>()
    func memCounter() -> Int {
        return collisionCounter.map { $0 * $0 }.reduce(0, +)
    }

    init(hashTableCapacity: Int, A: UInt, B: UInt) {
        self.A = A
        self.B = B
        hashTable = Array<Map?>.init(repeating: nil, count: hashTableCapacity)
        collisionCounter = Array<Int>.init(repeating: 0, count: hashTableCapacity)
    }
    
    func getHashCode(key: String) -> UInt {
        return HashFunc.pearson(key: key)
    }
    
    func hash(key: String) -> Int {
        let hashCode = getHashCode(key: key)
        return HashFunc.universal(key: hashCode, A: A, B: B, M: hashTable.count)
    }
  
    mutating func add(key: String, value: V) {
        let idx = hash(key: key)
        if hashTable[idx] == nil {
            hashTable[idx] = HashMapi.init()
        } else {
            collisionCounter[idx] += 1
        }
        hashTable[idx]!.addi(key: key, value: value)
        size += 1
    }

    func search(key: String) -> V? {
        let idx = hash(key: key)
        return hashTable[idx]?.search(key: key)
    }
}
