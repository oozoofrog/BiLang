//
//  UnicodeTests.swift
//  UnicodeTests
//
//  Created by Kwanghoon Choi on 2018. 5. 7..
//  Copyright © 2018년 최광훈. All rights reserved.
//

import XCTest
@testable import Unicode

class UnicodeTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testUTF8Array() {
		let a = "안녕"
		let utf8array = a.unicode.codeunits.utf8
		let b: [UInt8] = [236, 149, 136, 235, 133, 149]
		let utf8string = b.unicode.string!
		XCTAssertEqual(utf8array, b)
		XCTAssertEqual(a, utf8string)
	}
	
	func testUTF16() {
		let a = "z水𝄞"
		let array = a.unicode.codeunits.utf16
		XCTAssertEqual(a, array.hex)
	}
	
}
