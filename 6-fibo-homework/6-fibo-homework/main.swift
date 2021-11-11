//
//  main.swift
//  6-fibo-homework
//
//  Created by руслан карымов on 11.11.2021.
//

import Foundation

class Fibo: iTask {
    
    var fiboArr = [Double]()
    var opCnt = 0
    
    func run(_ data: [String]) -> String {
        guard let N = Int(data[0]) else {
            return ""
        }
        if N == 0 || N == 1 {
            return String(N)
        }
        fiboArr = [0, 1]
        let res = String(format: "%.0f", fibo4(N))
        print(opCnt)
        return res
    }
    
    // рекурсия
    func fibo1(_ N: Int) -> Double {
        if N <= 1  {
            return fiboArr.last!
        }
        fiboArr.append(fiboArr.last! + fiboArr[fiboArr.count - 2])
        opCnt += 1
        return fibo1(N - 1)
    }

    // итерация
    func fibo2(_ N: Int) -> Double {
        var res: [Double] = [0, 1]
        for i in 2...N {
            res[i % 2] = res[0] + res[1]
            fiboArr.append(fiboArr.last! + fiboArr[fiboArr.count - 2])
            opCnt += 1
        }
        return res.max()!
    }
    
    // Через формулу золотого сечения
    func fibo3(_ N: Int) -> Double {
        let fi: Double = (1 + sqrt(5)) / 2
        return floor(pow(fi, Double(N)) / sqrt(5) + 0.5)
    }
    
  
    func matrixMul(_ m1: [[Double]], _ m2: [[Double]]) -> [[Double]]? {
        let rowCount1 = m1.count
        let colCount1 = m1[0].count
        
        let rowCount2 = m2.count
        let colCount2 = m2[0].count
        
        if (rowCount1 == 0) {
            return []
        }
        
        if colCount1 != rowCount2 {
            return nil
        }
        
        var res = [[Double]].init(repeating: [Double].init(repeating: 0.0, count: colCount2), count: rowCount1)
        for i in 0..<rowCount1 {
            for j in 0..<colCount2 {
                for k in 0..<colCount1 {
                    res[i][j] += m1[i][k] * m2[k][j]
                }
            }
        }
        
        return res
    }
    
    // Через возведение матрицы в степень.
    // F(N) = ((1 1) ^ (N-1)
    //         (1 0))
    func fibo4(_ N: Int) -> Double {
        let fiboMatrix: [[Double]] = [[1.0,1.0],
                                      [1.0,0.0]]
        var curMatrix = fiboMatrix
        if N != 0 {
            var degree = 2
            while degree < (N - 1) {
                curMatrix = matrixMul(curMatrix, curMatrix)!
                opCnt += 6
                degree *= 2
            }
            for _ in (degree / 2)..<(N - 1) {
                curMatrix = matrixMul(curMatrix, fiboMatrix)!
                opCnt += 1
            }
        }
        return curMatrix[0][0]
    }
}

let fibo = Fibo()
let tester = Tester(path: "/Users/ruslankarymov/Desktop/4.Fibo", task: fibo)
tester.runTests()
