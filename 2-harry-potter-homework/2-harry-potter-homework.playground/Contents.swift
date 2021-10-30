import Cocoa
import Darwin

let max = 24

for x in 0...max {
    for y in 0...max {
        print(
            // x < y                                                                        // 1
            // x == y                                                                       // 2
            // x == max - y                                                                 // 3
            // x < max - y + 5                                                              // 4
            // x == y / 2                                                                   // 5
            // x < 10 || y < 10                                                             // 6
            // x > max - 9 && y > max - 9                                                   // 7
            // x == 0 || y == 0                                                             // 8
            // x >= y + 11 || x <= y - 11                                                   // 9
            // x <= y - 1 && x * 2 >= y - 1                                                 // 10
            // x == 1 || y == 1 || x == max - 1 || y == max - 1                             // 11
            // pow(Decimal(x), 2) + pow(Decimal(y), 2) <= pow(Decimal(max - 4), 2)          // 12
            // x > max - y - 5 && x < max - y + 5                                           // 13
            // x > 0 && (100 / x) >= y                                                      // 14
            // (x + 10 <= y || x - 10 >= y) && (x + max - 4 >= y) && (x <= y + max - 4)     // 15
            // x + 9 >= y && x - 9 <= y && x <= max - y + 9 && x >= max - y - 9             // 16
            // ((x % (y + 1) == (y - 1) % (x + 1)) && x <= y) || y == 0                     // 17
            // (x < 2 || y < 2) && ((x != y) || x == 1)                                     // 18
            // x == 0 || y == 0 || x == max || y == max                                     // 19
            // x % 2 == y % 2                                                               // 20
            // x >= Int(sin(CGFloat(y) / 3) * 8 + 17)                                       // 21
            // x % 3 == (max - y) % 3                                                       // 22
            // x % 2 == (x + y) % 2 && x % 3 == 0                                           // 23
            // x == y || x == max - y                                                       // 24
            x % 6 == (y + x) % 6 || y % 6 == (y + x) % 6                                    // 25
            ? "#" : ".",
            separator: "", terminator: " ")
    }
    print("")
}
