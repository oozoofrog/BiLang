//: Playground - noun: a place where people can play

import Foundation

var a: UInt8 = 128
var b: Int8 = -2
var c: Int = 1234

extension BinaryInteger {
	var bytes: [UInt8] {
		let count = self.bitWidth / 8
		return (0..<count).map { index in self >> (index * 8)}.map { UInt8(truncatingIfNeeded: $0) }
	}
	var data: Data {
		return Data(bytes: self.bytes)
	}
}

extension Collection where Element: BinaryInteger {
	var data: Data {
		return self.map { $0.bytes }.joined().map { $0 }.data
	}
}


print(a.bytes)
print(b.bytes)
print(c.bytes)

print(a.data.map { $0 })
print(b.data)
print(c.data)
