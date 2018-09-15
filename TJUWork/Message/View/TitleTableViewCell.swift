//
//  TitleTableViewCell.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/31.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    let textField: UITextField = {
        let textField = UITextField()
        //textField.clearButtonMode = .whileEditing
        textField.borderStyle = UITextBorderStyle.none
        textField.returnKeyType = .done
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        return textField
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex6: 0x00518e)
        label.text = "标题："
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(55)
        }
        
        textField.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right)
            make.top.bottom.equalToSuperview().inset(10)
            make.right.equalToSuperview()
        }
        
        textField.delegate = self
    }
    
    override var frame: CGRect {
        didSet {
            var newFrame = frame
            newFrame.origin.x += 10
            newFrame.size.width -= 20
            super.frame = newFrame
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TitleTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        return false
    }
    
}


