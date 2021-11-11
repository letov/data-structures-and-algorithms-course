//
//  tester.swift
//  4-lucky-tickets-homework
//
//  Created by руслан карымов on 04.11.2021.
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
            let (result, time) = runTest(inFile, outFile)
            print("Test #\(i) - \(result) - \(time) ms")
            i += 1
        }
    }
    
    private func runTest(_ inFile: String,_ outFile: String) -> (Bool, Int) {
        do {
            let data = try String(contentsOfFile: inFile).components(separatedBy: "\r\n").map {
                $0.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            let expect = try String(contentsOfFile: outFile).trimmingCharacters(in: .whitespacesAndNewlines)
            let start = DispatchTime.now()
            let actual = task.run(data).trimmingCharacters(in: .whitespacesAndNewlines)
            let end = DispatchTime.now()
            let time = (end.uptimeNanoseconds - start.uptimeNanoseconds) / 1000000
            print("expect \(expect) | actual \(actual)")
            return (expect == actual, Int(time))
        } catch {
            return (false, 0)
        }
    }
}
