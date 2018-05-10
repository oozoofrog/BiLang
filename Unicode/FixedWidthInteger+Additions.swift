//
//  BinaryInteger+Additions.swift
//  Unicode
//
//  Created by Kwanghoon Choi on 2018. 5. 11..
//  Copyright © 2018년 최광훈. All rights reserved.
//

import Foundation

extension FixedWidthInteger {
	var bytes: [UInt8] {
		let count = self.bitWidth / 8
		return (0..<count).map { index in self >> (index * 8)}.map { UInt8(truncatingIfNeeded: $0) }
	}
	var data: Data {
		return Data(bytes: self.bytes)
	}
}

extension Collection where Element: FixedWidthInteger {
	var bytes: [UInt8] {
		return self.map { $0.bytes }.joined().map { $0 }
	}
	var data: Data {
		return Data(bytes: self.map { $0.bytes }.joined().map { $0 })
	}
}
