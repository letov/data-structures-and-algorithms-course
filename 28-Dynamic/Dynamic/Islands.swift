//
//  Islands.swift
//  Dynamic
//
//  Created by руслан карымов on 08.03.2022.
//

import Foundation

/*
 Каждый элемент квадратной матрицы размеренности N x N равен нулю, либо единице. Найдите количество «островов», образованных единицами. Под «островом» понимается группа единиц (либо одна единица), со всех сторон окруженная нулями (или краями матрицы). Единицы относятся к одному «острову», если из одной из них можно перейти к другой «наступая» на единицы, расположенные в соседних клетках. Соседними являются клетки, граничащие по горизонтали или вертикали.
 */

class Islands {
    var table: [[Int]]
    init(_ N: Int) {
        table = [[Int]].init(repeating: [Int].init(repeating: 0, count: N), count: N)
        for i in 0..<N {
            for j in 0..<N {
                if Int.random(in: 0...2) == 0 {
                    table[i][j] = 1
                }
            }
        }
    }
    
    func show() {
        for i in table {
            print(i)
        }
    }
    
    func calc() -> Int {
        var result = 0
        for i in 0..<table.count {
            for j in 0..<table.count {
                if table[i][j] == 1 {
                    result += 1
                    unset(i, j)
                }
            }
        }
        return result
    }
    
    func unset(_ i: Int, _ j: Int) {
        if i < 0 || i >= table.count {
            return
        }
        if j < 0 || j >= table.count {
            return
        }
        if table[i][j] == 0 {
            return
        }
        table[i][j] = 0
        unset(i - 1, j)
        unset(i + 1, j)
        unset(i, j - 1)
        unset(i, j + 1)
    }
}
