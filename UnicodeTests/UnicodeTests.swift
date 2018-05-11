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
		let a = "a👠안녕"
		let array = a.unicode.codeunits.utf8
		print(array.map { $0.hex })
		print(a.data(using: .utf16)!.map { $0 })
		print([255, 254] + a.unicode.codeunits.utf16.bytes)
	}
	
}
