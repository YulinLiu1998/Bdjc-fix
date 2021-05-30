//
//  Constant.swift
//  Bjdc
//
//  Created by 徐煜 on 2021/5/25.
//

import Foundation
import UIKit

var NavMenu:LMJDropdownMenu?
var NavMenu1:LMJDropdownMenu?

//正则表达式

let kPhoneRegEx = "^1\\d{10}$"
let kAuthCodeRegEx = "^\\d{6}$"
let kPasswordRegEx = "^[0-9a-zA-Z]{6,16}$"

extension UIView{
    @IBInspectable
    var radius: CGFloat{
        get{
            layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable
    var borderWidth: CGFloat{
        get{
            layer.borderWidth
        }
        set{
            layer.borderWidth = newValue
        }
    }
    @IBInspectable
    var borderColor: UIColor{
        get{
            layer.borderUIColor
        }
        set{
            layer.borderUIColor = newValue
        }
    }
}

extension CALayer {
    
    @IBInspectable
    var borderUIColor: UIColor {
        get {
            return UIColor(cgColor: self.borderColor!)
        } set {
            self.borderColor = newValue.cgColor
        }
    }
}
extension String{
    var isBlank: Bool{ self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    
    var isPhoneNum: Bool{ Int(self) != nil && NSRegularExpression(kPhoneRegEx).matches(self) }
    
    var isAuthCode: Bool{ Int(self) != nil && NSRegularExpression(kAuthCodeRegEx).matches(self) }
    
    var isPassword: Bool{ NSRegularExpression(kPasswordRegEx).matches(self) }
}
extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            fatalError("非法的正则表达式")//因不能确保调用父类的init函数
        }
    }
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
extension Optional where Wrapped == String{
    var unwrappedText: String { self ?? "" }
}
extension UITextField{
    var unwrappedText: String { text ?? "" }
    var exactText: String { unwrappedText.isBlank ? "" : unwrappedText }
    var isBlank: Bool { unwrappedText.isBlank }
}

extension UIButton{
    
    func setToEnabled(){
        isEnabled = true
        backgroundColor = .systemBlue
    }
    
    func setToDisabled(){
        isEnabled = false
        backgroundColor = .quaternaryLabel
    }
    //变成胶囊按钮
    func makeCapsule(_ color: UIColor = .label){
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
    }
}

extension UIViewController{
    // MARK: 点击空白处收起键盘
    func hideKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //保证tap手势不会影响到其他touch类控件的手势
        //若不设，则本页面有tableview时，点击cell不会触发didSelectRowAtIndex（除非长按）
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true) //让view中的所有textfield失去焦点--即关闭小键盘
    }
}

extension UITextField {
    
    private struct AssociatedObjectByHQ {
        static var clear = "AssociatedObjectByHQ.isSecureBeginClear"
        static var setSecureTextEntryChanged = false
    }
    
    public var isSecureBeginClear: Bool {
        get {
            objc_getAssociatedObject(self, &AssociatedObjectByHQ.clear) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectByHQ.clear, newValue, .OBJC_ASSOCIATION_COPY)
            if !newValue {
                if !AssociatedObjectByHQ.setSecureTextEntryChanged {
                    AssociatedObjectByHQ.setSecureTextEntryChanged = true
                    guard let m1 = class_getInstanceMethod(self.classForCoder, Selector(("setSecureTextEntry:"))) else {
                        return
                    }
                    guard let m2 = class_getInstanceMethod(self.classForCoder, #selector(hq_setSecureTextEntry(_:))) else {
                        return
                    }
                    method_exchangeImplementations(m1, m2)//这里如果使用kvo去监听isSecureTextEntry 在iOS 14之前会崩溃， isSecureTextEntry是一个协议方法，这里采用方法交换
                }
                 
                NotificationCenter.default.addObserver(self, selector: #selector(textDidBeginEditingNotificationFunc(_:)), name: UITextField.textDidBeginEditingNotification, object: nil)
            } else {
                NotificationCenter.default.removeObserver(self)
                endEditing(true)
            }
        }
    }
     
    @objc private func hq_setSecureTextEntry(_ new: Bool) {
        hq_setSecureTextEntry(new)
        if !isSecureBeginClear {
            if let text = self.text, isFirstResponder {
                self.text = ""
                self.insertText(text)
                self.insertText("")
            }
        }
    }
    
    @objc private func textDidBeginEditingNotificationFunc(_ notification: NSNotification) {
        if let textField = notification.object as? UITextField, textField == self, textField.isSecureTextEntry {
            if let text = textField.text {
                textField.text = ""
                textField.insertText(text)
                textField.insertText("")//防止再次输入时最后一个字符为明文
            }
        }
    }
}
