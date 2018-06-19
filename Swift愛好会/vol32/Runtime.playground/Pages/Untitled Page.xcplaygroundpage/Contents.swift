//: Playground - noun: a place where people can play

import Foundation
import ObjectiveC

//struct Animal {}
//var Key: UInt8 = 0
//var animal = Animal()
//objc_setAssociatedObject(animal, &Key, "hello!", .OBJC_ASSOCIATION_RETAIN)
//objc_getAssociatedObject(animal, &Key)

//class Person : NSObject  // ← NSObjectから派生させる
//{
//  var name = ""
//  var email = ""
//  var age = 0
//}
//
//var p1 = Person()
//p1.setValue("Jhone Doe", forKey: "name")


struct Fox {
}

struct StructMetadataLayout {}

let type: Any.Type = Fox.self
let base = unsafeBitCast(type, to: UnsafeMutablePointer<Int>.self)
//まずは構造体のタイプの生ポインタを取得します。
//タイプの生ポインタはUnsafeMutablePointer<Int>と同様であるためキャストに成功します。
//AnyにしているのはIntのポインタと同じメモリ表現にするためです
//https://qiita.com/omochimetaru/items/64b073c5d6bcf1bbbf99

let metadata = UnsafeMutableRawPointer(base.advanced(by: -1)).assumingMemoryBound(to: StructMetadataLayout.self)


