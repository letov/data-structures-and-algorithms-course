//
//  main.swift
//  Cache
//
//  Created by руслан карымов on 07.03.2022.
//

import Foundation

struct LRU<KEY_TYPE,VALUE_TYPE> where KEY_TYPE: Equatable {
    let maxCacheSize = 10
    typealias T = (key: KEY_TYPE, value: VALUE_TYPE)
    var storage = LinkedList<T>()
    
    var count: Int {
        storage.count
    }
    
    mutating func add(key: KEY_TYPE, value: VALUE_TYPE) {
        if storage.count >= maxCacheSize {
            storage.removeLast()
        }
        storage.push((key: key, value: value))
    }
    
    mutating func get(key: KEY_TYPE) -> VALUE_TYPE? {
        var curItem = storage.head
        var curIndex = 0
        while curItem != nil {
            if curItem!.value.key == key {
                let item = curItem!.value
                storage.remove(curIndex)
                storage.push(item)
                return item.value
            }
            curItem = curItem!.next
            curIndex += 1
        }
        return nil
    }
}
