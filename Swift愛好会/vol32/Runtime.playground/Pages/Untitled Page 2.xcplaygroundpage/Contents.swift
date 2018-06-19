//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)

func dumpMemory(_ p: UnsafeRawPointer, _ size: Int) {
  let addr = unsafeBitCast(p, to: UnsafeMutablePointer<Int>.self)
  var p = p.bindMemory(to: UnsafeMutablePointer<Int>.self, capacity: size)
  for i in 0..<size {
    if i % 8 == 0 {
      if i != 0 {
        print()
      }
      print(String(format: "[0x%016lx]", addr + UInt64(i)), terminator: "")
    }
    print(String(format: " %02x", p[i]), terminator: "")
  }
  print()
}

struct SA {
  var v1: UInt32 = 0xA1B1C1D1
  var v2: UInt32 = 0xA2B2C2D2
  var v3: UInt32 = 0xA3B3C3D3
  var v4: UInt32 = 0xA4B4C4D4
}

//var x = SA()
//let p = UnsafeRawPointer(UnsafeMutablePointer<SA>(&x))
//dumpMemory(p, MemoryLayout<SA>.size)

//リトルエンディアン
dumpMemory(SA.self, Int.self)

