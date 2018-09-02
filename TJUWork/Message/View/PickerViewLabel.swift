//
//  PickerViewLabel.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/31.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit

class PickerViewLabel: UILabel {
    
    private var _inputView: UIView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private var _inputAccessoryView: UIView = {
        let toolBar = UIToolbar()
        return toolBar
    }()
    
    
    override var isUserInteractionEnabled: Bool {
        set {
            
        } get {
            return true
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputView: UIView? {
        set {
            _inputView = newValue!
        } get {
            return _inputView
        }
    }
    
    override var inputAccessoryView: UIView? {
        set {
            _inputAccessoryView = newValue!
        } get {
            return _inputAccessoryView
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showPickerView(_:)))
        self.addGestureRecognizer(tapGesture)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showPickerView(_ gesture: UITapGestureRecognizer) {
        self.becomeFirstResponder()
    }
    
}
