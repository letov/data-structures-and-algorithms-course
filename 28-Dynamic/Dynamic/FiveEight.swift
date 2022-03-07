//
//  FiveEight.swift
//  Dynamic
//
//  Created by руслан карымов on 07.03.2022.
//

import Foundation

// Дано число N. Выяснить, сколько N-значных чисел можно составить,
// используя цифры 5 и 8, в которых три одинаковые цифры не стоят рядом?
//
//  suffix  1  2  3  4  5  6
//       5  1  1  2  3  5  8
//       8  1  1  2  3  5  8
//      55  0  1  1  2  3  5
//      88  0  1  1  2  3  5
//
//   count  2  4  6 10 16

class FiveEight {
    var fiboBeforeLast = 0
    var fiboLast = 1
    
    func calc(_ N: Int) -> Int {
        fibo(N)
        return fiboBeforeLast << 1 + fiboLast << 1
    }
    
    func fibo(_ N: Int) {
        if N <= 1  {
            return
        }
        swap(&fiboBeforeLast, &fiboLast)
        fiboLast += fiboBeforeLast
        fibo(N - 1)
    }
}
