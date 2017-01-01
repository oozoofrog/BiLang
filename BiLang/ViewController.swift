//
//  ViewController.swift
//  BiLang
//
//  Created by hoonhoon on 2016. 12. 30..
//  Copyright © 2016년 최광훈. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard

extension UIView {
    func endEditingWithTrue() {
        self.endEditing(true)
    }
}

extension UIBarButtonItem {
    static var flexibleItem: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
}

class TextUtil {
    static func radixed(source: String, radix: RadixType, seperator: String = " ", defaultPrefix: String = "0") -> (String, Data) {
        guard let data = source.data(using: .utf8) else {
            return ("", Data.init(count: 8))
        }
        return radixed(source: data, radix: radix, seperator: seperator, defaultPrefix: defaultPrefix)
    }
    static func radixed(source: Data, radix: RadixType, seperator: String = " ", defaultPrefix: String = "0") -> (String, Data) {
        let radixedStrings = source.reduce("") { (append, binary) -> String in
            var radixedString: String = .init(binary, radix: radix.rawValue)
            let remain = 8 - radixedString.lengthOfBytes(using: .ascii)
            if 0 < remain {
                radixedString = (0..<remain).reduce(defaultPrefix){$0.0 + defaultPrefix} + radixedString
            }
            return append + radixedString + seperator
        }
        
        return (radixedStrings, source)
    }
    static func unradixed(source: String, seperator: String = " ") -> Data {
        let hexFromSource: (String) -> Int = { source in
            return source.replacingOccurrences(of: seperator, with: "").characters.reversed().enumerated().reduce(0) { (result, element) -> Int in
                guard let value = Int(String(element.element)), 1 == value else {
                    return result
                }
                
                return result + Int(powf(2, Float(element.offset)))
            }
        }
        return source.components(separatedBy: seperator).reduce(Data(), { (result, radixedString) -> Data in
            let value = hexFromSource(radixedString)
            guard Int(UInt8.max) > value else {
                return result
            }
            var ascii: UInt8 = UInt8(value)
            let buffer: UnsafeRawPointer = withUnsafePointer(to: &ascii){UnsafeRawPointer($0)}
            return result + Data(bytes: buffer, count: 1)
        })
    }
    
}

enum RadixType: Int {
    case binary = 2
    case octal = 8
    case decimal = 10
    case duodecimal = 12
    case haxadecimal = 16
}

class ViewController: UIViewController {

    var destinationData: Data? = Data()
    
    @IBOutlet weak var showSegment: UISegmentedControl!
    
    @IBOutlet weak var destinationTextView: UITextView!
    @IBOutlet weak var sourceTextView: UITextView!
    
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let doneItem = UIBarButtonItem()
        doneItem.title = "닫기"
        doneItem.target = self.sourceTextView
        doneItem.action = #selector(sourceTextView.endEditingWithTrue)
        let toolbar = UIToolbar()
        toolbar.setItems([.flexibleItem, doneItem], animated: false)
        toolbar.sizeToFit()
        sourceTextView.inputAccessoryView = toolbar
        UITextView.appearance().tintColor = .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(destinationTextToClipboard))
        destinationTextView.addGestureRecognizer(tap)
        
        showSegment.rx.selectedSegmentIndex
        .distinctUntilChanged()
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] (selectedSegmentIndex) in
            self?.sourceTextView.text = self?.destinationTextView.text
        })
        .addDisposableTo(disposeBag)
        
        sourceTextView.rx.text.orEmpty.throttle(0.25, scheduler: MainScheduler.instance)
        .distinctUntilChanged()
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] (text) in
            print("source -> \(text)")
            switch self?.showSegment.selectedSegmentIndex {
            case 0?:
                let (convertedText, data) = TextUtil.radixed(source: text, radix: .binary)
                self?.destinationTextView.text = convertedText
                self?.destinationData = data
            case 1?:
                let data = TextUtil.unradixed(source: text)
                guard let text = String(data: data, encoding: .utf8) else {
                    return
                }
                self?.destinationTextView.text = text
            default: break
            }
        })
        .addDisposableTo(disposeBag)
        
        RxKeyboard.instance.visibleHeight.asObservable().observeOn(MainScheduler.instance)
        .distinctUntilChanged()
        .bindNext { [weak self] (height) in
            UIView.animate(withDuration: 0.25, animations: {
                self?.bottomMargin.constant = height
            })
        }
        .addDisposableTo(disposeBag)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            self?.sourceTextView.becomeFirstResponder()
        }
    }

    func destinationTextToClipboard() {
        UIPasteboard.general.string = destinationTextView.text
        self.prompt("Copied to Clipboard", autoclosing: 0.25)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

