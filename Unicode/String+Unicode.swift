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

extension Array where Element: FixedWidthInteger {
	public struct Unicode {
		var array: [Element]
		
		var string: String? {
			return String.init(data: self.array.data, encoding: .utf8)
		}
	}
	
	var unicode: Unicode {
		return Unicode(array: self)
	}
}

extension FixedWidthInteger {
	public var hex: String {
		return String(self, radix: 16, uppercase: true)
	}
}
