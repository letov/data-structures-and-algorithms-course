//
//  HashMapChaining.swift
//  HashMap
//
//  Created by руслан карымов on 24.12.2021.
//

import Foundation

struct HashMapChaining<V>: HashMap {
    class LinkedMap {
        var key: String
        var value: V
        
        var next: LinkedMap?
        
        init(key: String, value: V) {
            self.key = key
            self.value = value
        }
    }
    
    typealias Value = V
    typealias Map = LinkedMap
    var hashTable = Array<Map?>.init(repeating: nil, count: 10)
    var p = Int()
    var size = Int()
    var maxDepth: Int {
        var result = Int()
        for map in hashTable {
            var curDepth = Int()
            var map = map
            while (map != nil) {
                curDepth += 1
                map = map!.next
            }
            result = max(result, curDepth)
        }
        return result
    }
    
    func getHashCode(key: String) -> UInt {
        return HashFunc.pearson(key: key)
    }
    
    func hash(key: String) -> Int {
        let hashCode = getHashCode(key: key)
        return HashFunc.division(key: hashCode, M: hashTable.count)
    }
    
    mutating func rehash() {
         let oldHashTable = hashTable
         let newCapacity = HashFunc.maxPrimeErast((hashTable.count * 10) + 1)
         size = 0
         hashTable = Array<Map?>.init(repeating: nil, count: newCapacity)
         for oldMap in oldHashTable {
             var map: Map? = oldMap
             while (map != nil) {
                 insert(key: map!.key, value: map!.value)
                 map = map!.next
             }
         }
     }
    
    mutating func insert(key: String, value: V) {
        let idx = hash(key: key)
        var map: Map? = hashTable[idx]
        while (map != nil) {
            if map!.key == key {
                map!.value = value
                return
            } else {
                map = map!.next
            }
        }
        map = LinkedMap(key: key, value: value)
        map!.next = hashTable[idx]
        hashTable[idx] = map!
        size += 1
        if size >= hashTable.count {
            rehash()
        }
    }
    
    mutating func delete(key: String) {
        return
    }
    
    func search(key: String) -> V? {
        let idx = hash(key: key)
        var map: Map? = hashTable[idx]
        while (map != nil) {
            if map!.key == key {
                return map!.value
            }
            map = map!.next
        }
        return nil
    }
}
