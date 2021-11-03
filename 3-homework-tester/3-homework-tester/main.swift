//
//  main.swift
//  3-homework-tester
//
//  Created by руслан карымов on 03.11.2021.
//

import Foundation

protocol iTask {
    func run(_ data: [String]) -> String
}

struct Tester {
    let path: String
    let task: iTask
    
    func runTests() {
        var i = 0
        while true {
            let inFile = "\(path)/test.\(i).in"
            let outFile = "\(path)/test.\(i).out"
            if (!FileManager.default.fileExists(atPath: inFile) ||
                !FileManager.default.fileExists(atPath: outFile)) {
                break
            }
            let result = runTest(inFile, outFile)
            print("Test #\(i) - \(result)")
            i += 1
        }
    }
    
    private func runTest(_ inFile: String,_ outFile: String) -> Bool {
        do {
            let data = try String(contentsOfFile: inFile).components(separatedBy: "\r\n")
            let expect = try String(contentsOfFile: outFile)
            let actual = task.run(data)
            print(actual)
            return expect == actual
        } catch {
            return false
        }
    }
}

struct TaskString: iTask {
    func run(_ data: [String]) -> String {
        return String(data[0].count)
    }
}

let task = TaskString()
let tester = Tester(path: "/Users/ZZZ/Desktop/0.String", task: task)
tester.runTests()

