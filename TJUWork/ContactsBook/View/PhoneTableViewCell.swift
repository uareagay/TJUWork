//
//  PhoneTableViewCell.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/28.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import UIKit

class PhoneTableViewCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "关于2018年夏季研究生毕业"
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        return label
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "1236372882"
        label.textColor = UIColor(hex6: 0x00518e)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.semibold)
        return label
    }()
    
    let phoneBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.resizedImage(image: UIImage(named: "电话")!, scaledToWidth: 25.0), for: .normal)
        return btn
    }()
    
    var isPhoned: Bool = true {
        didSet {
            if isPhoned == true {
                self.phoneLabel.textColor = UIColor(hex6: 0x00518e)
                self.phoneBtn.isHidden = false
            } else {
                self.phoneLabel.textColor = .gray
                self.phoneLabel.text = "无号码"
                self.phoneBtn.isHidden = true
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(phoneLabel)
        self.contentView.addSubview(phoneBtn)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(75)
            make.bottom.equalTo(self.contentView.snp.centerY)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(5)
            make.right.equalToSuperview().inset(75)
            make.top.equalTo(self.contentView.snp.centerY).offset(5)
        }
        
        phoneBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(5)
            make.width.equalTo(55)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
