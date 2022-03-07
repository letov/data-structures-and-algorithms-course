//
//  LinkList.swift
//  Cache
//
//  Created by руслан карымов on 07.03.2022.
//

import Foundation

struct LinkedList<T> {
    
    class Node<T> {
        var value: T
        var next: Node? = nil
        
        init(_ value: T, _ next: Node? = nil) {
            self.value = value
            self.next = next
        }
    }
    
    var head: Node<T>?
    var tail: Node<T>?
    
    var count: Int = 0
    
    mutating func push(_ item: T) {
        head = Node(item, head)
        if tail == nil {
            tail = head
        }
        count += 1
    }
    
    mutating func add(_ item: T) {
        if (head == nil) {
            push(item)
            return
        }
        tail!.next = Node(item)
        tail = tail!.next
        count += 1
    }
    
    mutating func removeLast() {
        var curItem = head
        var prevItem: Node<T>? = nil
        while curItem?.next != nil {
            prevItem = curItem
            curItem = curItem?.next
        }
        tail = prevItem
        tail?.next = nil
        count -= 1
    }
    
    mutating func insert(_ item: T, _ index: Int) {
        if index == 0 {
            push(item)
            return
        }
        var curItem = head
        var prevItem: Node<T>? = nil
        var curIndex = 0
        while curItem != nil {
            if curIndex == index {
                prevItem?.next = Node(item, curItem)
                break
            }
            prevItem = curItem
            curItem = curItem?.next
            curIndex += 1
        }
    }
    
    mutating func remove(_ index: Int) {
        if index == 0 {
            head = head?.next
        }
        var curItem = head
        var prevItem: Node<T>? = nil
        var curIndex = 0
        while curItem != nil {
            if curIndex == index {
                prevItem?.next = curItem?.next
                count -= 1
                break
            }
            prevItem = curItem
            curItem = curItem?.next
            curIndex += 1
        }
    }
    
    func get(_ index: Int) -> T? {
        var curItem = head
        var curIndex = 0
        while curItem != nil {
            if curIndex == index {
                return curItem?.value
            }
            curItem = curItem?.next
            curIndex += 1
        }
        return nil
    }
    
    func getAll() -> [T] {
        var curItem = head
        var result = [T]()
        while curItem != nil {
            result.append(curItem!.value)
            curItem = curItem?.next
        }
        return result
    }
}
