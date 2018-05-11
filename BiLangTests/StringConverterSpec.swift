//
//  ViewModelSpec.swift
//  UnicodeTests
//
//  Created by Kwanghoon Choi on 2018. 5. 11..
//  Copyright © 2018년 최광훈. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxBlocking
import RxTest

import Quick
import Nimble

@testable import BiLang

class StringConverterSpec: QuickSpec {
	override func spec() {
		self.continueAfterFailure = false
		
		it("string splited by length") {
			let bits = "1111000000001111"
			expect(bits.splited(byStride: 8).joined(separator: " ")) == "11110000 00001111"
		}
		
		context("utf8 convert to bits") {
			var converter: StringConverter!
			beforeEach {
				converter = StringConverter(input: StringConverter.StringType.utf8, output: StringConverter.StringType.bits)
			}
			
			it("model input is text") {
				expect(converter.input) == .utf8
			}
			it("model output is bits") {
				expect(converter.output) == .bits
			}
			it("hello input은 output으로 바뀐다.") {
				expect(converter.convertedFrom(text: "hello")) == "0110100001100101011011000110110001101111"
			}
		}
		
		context("bits convert to utf8") {
			var converter: StringConverter!
			beforeEach {
				converter = StringConverter(input: .bits, output: .utf8)
			}
			
			it("model input is text") {
				expect(converter.input) == .bits
			}
			it("model output is bits") {
				expect(converter.output) == .utf8
			}
			it("hello input은 output으로 바뀐다.") {
				expect(converter.convertedFrom(text: "0110100001100101011011000110110001101111")) == "hello"
			}
		}
	}
}
