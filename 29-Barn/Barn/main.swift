//
//  main.swift
//  Barn
//
//  Created by руслан карымов on 08.03.2022.
//

import Foundation

class Barn {
    var N: Int // X
    var M: Int // Y
    var table: [[Int]]
    var line: [Int]
    var left: [Int]
    var right: [Int]
    
    init(N: Int, M: Int, prob: Double, seed: Int = 36) {
        table = [[Int]].init(repeating: [Int].init(repeating: 0, count: N), count: M)
        self.N = N
        self.M = M
        line = [Int].init(repeating: 0, count: N)
        left = [Int].init(repeating: 0, count: N)
        right = [Int].init(repeating: 0, count: N)
        randFill(prob: prob, seed: seed)
    }
    
    func randFill(prob: Double, seed: Int) {
        srand48(seed)
        for y in 0..<M {
            for x in 0..<N {
                table[y][x] = drand48() < prob ? 1 : 0
            }
        }
    }
    
    func show() {
        for y in 0..<M {
            print(table[y])
        }
    }
    
    func maxSquare4() -> Int {
        line = [Int].init(repeating: 0, count: M)
        var maxSquare = 0
        for xZero in 0..<N {
            for yZero in 0..<M {
                let square = getSquareAt4(xZero: xZero, yZero: yZero)
                maxSquare = max(maxSquare, square)
            }
        }
        return maxSquare
    }
    
    func getSquareAt4(xZero: Int, yZero: Int) -> Int {
        var maxSquare = 0
        var minHeight = M
        for width in 0..<N - xZero {
            let height = getHeightAt4(xZero: xZero + width, yZero: yZero, minHeight: minHeight)
            // boost 1
            if height == 0 {
                break;
            }
            minHeight = min(minHeight, height)
            let square = (width + 1) * minHeight
            maxSquare = max(maxSquare, square)
        }
        return maxSquare
    }
    
    func getHeightAt4(xZero: Int, yZero: Int, minHeight: Int) -> Int {
        for y in yZero..<M {
            let height = y - yZero
            // boost 2
            if table[y][xZero] != 0 || height >= minHeight {
                return height
            }
        }
        return M - yZero
    }
    
    func maxSquare3() -> Int {
        line = [Int].init(repeating: 0, count: M)
        var maxSquare = 0
        for yZero in 0..<M {
            calcHeightLine(yZero: yZero)
            for xZero in 0..<N {
                let square = getSquareAt3(xZero: xZero, yZero: yZero)
                maxSquare = max(maxSquare, square)
            }
        }
        return maxSquare
    }
    
    func getSquareAt3(xZero: Int, yZero: Int) -> Int {
        var maxSquare = 0
        var minHeight = M
        for width in 0..<N - xZero {
            let height = line[xZero + width]
            if height == 0 {
                break;
            }
            minHeight = min(minHeight, height)
            let square = (width + 1) * minHeight
            maxSquare = max(maxSquare, square)
        }
        return maxSquare
    }
    
    func calcHeightLine(yZero: Int) {
        for x in 0..<N {
            line[x] += table[yZero][x] == 0 ? 1 : -line[x]
        }
    }
    
    func maxSquare2() -> Int {
        line = [Int].init(repeating: 0, count: M)
        var maxSquare = 0
        for yZero in 0..<M {
            calcHeightLine(yZero: yZero)
            calcRightRanges()
            calcLeftRanges()
            for xZero in 0..<N {
                let height = line[xZero]
                let width = right[xZero] - left[xZero] + 1
                let square = height * width
                maxSquare = max(maxSquare, square)
            }
        }
        return maxSquare
    }
    
    func calcRightRanges() {
        var stack = [Int]()
        for x in 0..<N {
            while !stack.isEmpty {
                if line[stack.last!] > line[x] {
                    right[stack.removeLast()] = x - 1
                } else {
                    break;
                }
            }
            stack.append(x)
        }
        while !stack.isEmpty {
            right[stack.removeLast()] = N - 1
        }
    }
    
    func calcLeftRanges() {
        var stack = [Int]()
        for x in (0..<N).reversed() {
            while !stack.isEmpty {
                if line[stack.last!] > line[x] {
                    left[stack.removeLast()] = x + 1
                } else {
                    break;
                }
            }
            stack.append(x)
        }
        while !stack.isEmpty {
            left[stack.removeLast()] = 0
        }
    }

}
