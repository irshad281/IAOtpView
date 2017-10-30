//
//  OTPView.swift
//  OTPView
//
//  Created by Innotical  Solutions  on 29/10/17.
//  Copyright © 2017 Innotical  Solutions . All rights reserved.
//

import Foundation
import UIKit

@objc protocol OtpDelegate {
    @objc optional func didChnageText(_ text:String , isValid:Bool)
}
class OtpField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        NotificationCenter.default.post(name: Notification.Name("Back"), object: self)
    }
    
}

extension OtpField {
    func isEmpty()-> Bool {
        guard let text = self.text else {
            return true
        }
        if text == "" {
           return true
        }
        return false
    }
}


@IBDesignable class IAOtpView: UIView {
    
   @IBInspectable var numberOfFields:Int = 4 {
        didSet{
            setupViews()
        }
    }
    
    @IBInspectable var font:UIFont = UIFont.boldSystemFont(ofSize: 18) {
        didSet{
            setupFonts()
        }
    }
    
    @IBInspectable var layerColor:UIColor = .lightGray {
        didSet{
            setupViews()
        }
    }
    
    private var otpFields:[OtpField]! = []
    private var borderLine:[UIImageView]! = []
    fileprivate var otpValue:String{
        get{
            var text:String = ""
            for field in self.otpFields {
                text.append(field.text!)
            }
            return text
        }
    }
    
    fileprivate var isValid:Bool{
        get{
            var valid:Bool = true
            for field in self.otpFields {
                if field.isEmpty() {
                    valid = false
                    break
                }
            }
            return valid
        }
    }
    var delegate:OtpDelegate?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(backPressed(notification:)), name: NSNotification.Name("Back"), object: nil)
    }
    
    func setupViews() {
        for subview in self.subviews{
            subview.removeFromSuperview()
            self.otpFields.removeAll()
            self.borderLine.removeAll()
        }
        let width = Int(Int(self.frame.width)/numberOfFields) - 5
        let height = self.frame.height
        for index in 0...numberOfFields - 1 {
            let frame = CGRect.init(x: CGFloat(index * (width + 5)), y: 0, width: CGFloat(width), height: height)
            let field = OtpField.init(frame: frame)
            field.tag = index
            field.keyboardType = .numberPad
            field.textAlignment = .center
            field.font = font
            field.delegate = self
            field.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
            let line = UIImageView.init(frame: CGRect.init(x: CGFloat(index * (width + 5)), y: height - 1, width: field.frame.width, height: 1))
            line.backgroundColor = layerColor
            self.otpFields.append(field)
            self.addSubview(field)
            self.addSubview(line)
            borderLine.append(line)
        }
    }
    
    func setupFonts() {
        for field in self.otpFields{
            field.font = font
        }
    }
    
    @objc fileprivate  func backPressed(notification:Notification) {
        guard let field = notification.object as? OtpField else {return}
        if field.tag != 0 && field.isEmpty(){
            otpFields[field.tag - 1].becomeFirstResponder()
            updateLines()
        }
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self, name: Notification.Name("Back"), object: nil)
    }
    
}




extension IAOtpView :UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = textField.text! as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        if (currentString as String).characters.count == 1 && string != ""{
            if textField.tag != (numberOfFields - 1) {
                otpFields[textField.tag + 1].becomeFirstResponder()
                if otpFields[textField.tag + 1].isEmpty(){
                    otpFields[textField.tag + 1].text = string
                }
            }
            updateLines()
        }
        return newString.characters.count <= 1
    }
    
    
    @objc func textDidChange(_ sender: UITextField) {
        guard let text = sender.text else {return}
        updateLines()
        self.delegate?.didChnageText?(self.otpValue, isValid: isValid)
        if text.characters.count == 0 {
            if sender.tag != 0{
               otpFields[sender.tag - 1].becomeFirstResponder()
            }
        }else if text.characters.count == 1 {
            if sender.tag != (numberOfFields - 1) {
               otpFields[sender.tag + 1].becomeFirstResponder()
            }
        }
    }
    
    func updateLines(){
        for (index , line) in self.borderLine.enumerated() {
            line.backgroundColor = otpFields[index].isEmpty() ? layerColor : .clear
        }
    }
}
