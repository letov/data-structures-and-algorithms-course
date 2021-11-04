//
//  main.swift
//  4-lucky-tickets-homework
//
//  Created by руслан карымов on 04.11.2021.
//

import Foundation

class TaskLuckyTickets: iTask {
    
    private var combinationCountArr = [[Int]]()
    
    private var columnSum: [Int] {
        combinationCountArr.map { $0.reduce(0, +) }
    }
    
    private var result: String {
        String(Int(columnSum.reduce(0, { $0 + pow(Float($1), 2) } )))
    }
    
    private var N: Int = 0
    
    func run(_ data: [String]) -> String {
        guard let N = Int(data[0]) else {
            return ""
        }
        self.combinationCountArr = [[Int]].init(repeating: [Int].init(repeating: 0, count: 10),count: 10).enumerated().map {
            (index, col) -> [Int] in
            var coloumn = col
            coloumn[index] = 1
            return coloumn
        }
        self.N = N
        nextCombinationCountArr(1)
        return result
    }
    
   private func nextCombinationCountArr(_ digitNr: Int) {
       if (digitNr >= self.N) {
            return
        }
        self.combinationCountArr = [[Int]].init(repeating: [Int].init(repeating: 0, count: columnSum.count + 9),count: 10).enumerated().map {
            (index, col) -> [Int] in
            var coloumn = col
            coloumn.insert(contentsOf: columnSum, at: index)
            return Array(coloumn[0..<columnSum.count + 9])
        }
        combinationCountArr = combinationCountArr.first!.indices.map { index in
            combinationCountArr.map{ $0[index] }
        }
        nextCombinationCountArr(digitNr + 1)
    }
    
}

let task = TaskLuckyTickets()
let tester = Tester(path: "/Users/ruslankarymov/Desktop/1.Tickets", task: task)
tester.runTests()
