//
//  String+Unicode.swift
//  Unicode
//
//  Created by Kwanghoon Choi on 2018. 5. 7..
//  Copyright © 2018년 최광훈. All rights reserved.
//

import Foundation

extension String {
	public struct Unicode {
		var string: String
		
		var codeunits: CodeUnits {
			return CodeUnits(unicode: self)
		}
	}
	
	public struct CodeUnits {
		var unicode: Unicode
		
		var utf8: [Swift.Unicode.UTF8.CodeUnit] {
			return self.unicode.string.utf8.map { $0 }
		}
		
		var utf16: [Swift.Unicode.UTF16.CodeUnit] {
			return self.unicode.string.utf16.map { $0 }
		}
	}
	
	public var unicode: Unicode {
		return Unicode(string: self)
	}
}

extension Array where Element == UInt8 {
	public struct Unicode {
		var array: [UInt8]
		
		var string: String? {
			var utf8 = self.array.map { CChar(bitPattern: $0) }
			if let last = utf8.last, last != 0 {
				utf8.append(0)
			}
			return String(utf8String: &utf8)
		}
	}
	
	var unicode: Unicode {
		return Unicode(array: self)
	}
}

extension FixedWidthInteger {
	public var hex: String {
		let hex = String(self, radix: 16, uppercase: true)
		return hex
	}
}

extension Collection where Element: FixedWidthInteger {
	var hex: String {
		return self.map { $0.hex }.joined(separator: " ")
	}
}
