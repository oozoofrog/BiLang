//
//  ConvertViewModel.swift
//  BiLang
//
//  Created by jay on 2018. 5. 14..
//  Copyright © 2018년 최광훈. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ConvertViewModel {
	
	var bag: DisposeBag?
	let converter: StringConverter
	let placeholder: String
	
	init(converter: StringConverter, placeholder: String) {
		self.converter = converter
		self.placeholder = placeholder
	}
	
}

extension ConvertViewModel: ViewModel {}
extension ConvertViewModel: ViewModelInOut {
	struct Input {
		let text: Signal<String?>
	}
	struct Output {
		let bag: DisposeBag
		let text: Signal<String?>
	}
	
	mutating func bind(input: ConvertViewModel.Input) -> ConvertViewModel.Output {
		let bag = DisposeBag()
		self.bag = bag
		let convert = self.converter.convertedFrom
		let outputText = input.text.map { convert($0 ?? self.placeholder) }
		return Output(bag: bag, text: outputText)
	}
}
