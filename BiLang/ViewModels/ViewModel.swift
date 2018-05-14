//
//  ViewModel.swift
//  BiLang
//
//  Created by jay on 2018. 5. 15..
//  Copyright © 2018년 최광훈. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxBlocking

protocol ViewModel {

	var bag: DisposeBag? { get }
	
}

protocol ViewModelInOut where Self: ViewModel {
	associatedtype Input
	associatedtype Output = ViewModelOutput
	
	
	mutating func bind(input: Input) -> Output
}

protocol ViewModelOutput {
	var bag: DisposeBag { get }
}
