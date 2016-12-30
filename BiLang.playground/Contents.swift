//: Playground - noun: a place where people can play

import UIKit

var str = "110001"

let ascii = str.characters.reversed().enumerated().reduce(0) { (result, element) -> Int in
    guard let value = Int(String(element.element)), 1 == value else {
        return result
    }
    
    return result + Int(powf(2, Float(element.offset)))
}

Character(UnicodeScalar(ascii)!)
