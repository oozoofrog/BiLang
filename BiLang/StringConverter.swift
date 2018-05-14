//
//  StringConverter.swift
//  BiLang
//
//  Created by Kwanghoon Choi on 2018. 5. 11..
//  Copyright © 2018년 최광훈. All rights reserved.
//

import Foundation

public struct StringConverter {
	
	public enum StringType {
		case utf8
		case bits
	}
	
	public let input: StringType
	public let output: StringType
	
	public init(input: StringType, output: StringType) {
		self.input = input
		self.output = output
	}
	
	public func convertedFrom(text: String) -> String? {
		return stringFrom(data: dataFrom(text: text, by: self.input), by: self.output)
	}
	
	public func dataFrom(text: String, by: StringType) -> Data? {
		switch by {
		case .utf8:
			return text.data(using: .utf8)
		case .bits:
			let bitStrings = text.splited(byStride: 8)
			let bytes: [UInt8] = bitStrings.compactMap { UInt8($0, radix: 2) }
			return Data(bytes: bytes)
		}
	}
	
	public func stringFrom(data: Data?, by: StringType) -> String? {
		switch by {
		case .utf8:
			return String(data: data ?? Data(), encoding: .utf8)
		case .bits:
			return data?.map { String.init($0, radix: 2, uppercase: true) }.map { String.init(repeating: "0", count: 8 - $0.count) + $0 }.joined()
		}
	}
}

extension String {
	func splited(byStride: Int, withTail: Bool = false) -> [String] {
		var strings: [String] = []
		var start = self.startIndex
		while start < self.endIndex {
			guard let next = self.index(start, offsetBy: byStride, limitedBy: self.endIndex) else {
				let last = self[start..<self.endIndex].description
				if withTail && last.isEmpty == false {
					strings.append(last)
				}
				break
			}
			strings.append(self[start..<next].description)
			start = next
		}
		return strings
	}
}
