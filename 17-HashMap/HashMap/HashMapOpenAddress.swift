//
//  HashMapOpenAddress.swift
//  HashMap
//
//  Created by руслан карымов on 24.12.2021.
//

import Foundation

struct HashMapOpenAddress<V>: HashMap {
    typealias Value = V
    
    typealias Map = (key: String, value: V)
    
    var hashTable = Array<Map?>.init(repeating: nil, count: 10)
    
    var size = Int()
    
    func getHashCode(key: String) -> UInt {
        return HashFunc.pearson(key: key)
    }
    
    func hash(key: String) -> Int {
        let hashCode = getHashCode(key: key)
        return HashFunc.division(key: hashCode, M: hashTable.count)
    }
    
    func hash2(key: String) -> Int {
        let hashCode = getHashCode(key: key)
        return HashFunc.division(key: hashCode, M: hashTable.count - 1)
    }
    
    mutating func rehash() {
        let oldHashTable = hashTable
        let newCapacity = HashFunc.maxPrimeErast((hashTable.count * 10) + 1)
        size = 0
        hashTable = Array<Map?>.init(repeating: nil, count: newCapacity)
        for oldMap in oldHashTable {
            if let map = oldMap {
                insert(key: map.key, value: map.value)
            }
        }
    }
    
    func probingHash(key: String, probe: Int) -> Int {
        let hash = hash(key: key)
        let hash2 = hash2(key: key)
        return (hash + (probe * hash2)) % hashTable.count
    }
    
    mutating func insert(key: String, value: V) {
        var probe = 0
        var map: Map? = nil
        var idx = 0
        repeat {
            idx = probingHash(key: key, probe: probe)
            map = hashTable[idx]
            probe += 1
            if probe > hashTable.count {
                rehash()
            }
            if map != nil && map!.key == key {
                hashTable[idx]!.value = value
                return
            }
        } while map != nil
        hashTable[idx] = (key: key, value: value)
        size += 1
        if size * 2 >= hashTable.count {
            rehash()
        }
    }
    
    mutating func delete(key: String) {
        return
    }
    
    func search(key: String) -> V? {
        var probe = 0
        var idx = probingHash(key: key, probe: probe)
        var map: Map? = hashTable[idx]
        while map != nil {
            if map!.key == key {
                return map!.value
            }
            probe += 1
            if probe > hashTable.count {
                return nil
            }
            idx = probingHash(key: key, probe: probe)
            map = hashTable[idx]
        }
        return nil
    }
}
