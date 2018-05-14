//
//  ConvertViewModel.swift
//  BiLangTests
//
//  Created by jay on 2018. 5. 14..
//  Copyright © 2018년 최광훈. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxBlocking
import RxTest
@testable import BiLang

class ConvertViewModelUTF82BitsTests: XCTestCase {
	
	var converter: StringConverter!
	var viewModel: ConvertViewModel!
	var bag: DisposeBag!
	
	var scheduler: TestScheduler!
	
	override func setUp() {
		super.setUp()
		converter = StringConverter(input: .utf8, output: .bits)
		viewModel = ConvertViewModel(converter: converter, placeholder: "")
		bag = DisposeBag()
		scheduler = TestScheduler(initialClock: 0)
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func test_inputUTF8toOutputBits() {
		let textInput = PublishRelay<String?>()
		let input = ConvertViewModel.Input(text: textInput.asSignal())
		let output = viewModel.bind(input: input)
		
		let observer = scheduler.createObserver(String?.self)
		
		output.text.asObservable().bind(to: observer).disposed(by: output.bag)
		
		scheduler.scheduleAt(1) {
			textInput.accept("hello")
		}
		
		scheduler.start()
		
		XCTAssertEqual(observer.events, [.next(1, "0110100001100101011011000110110001101111")])
	}
	
}
