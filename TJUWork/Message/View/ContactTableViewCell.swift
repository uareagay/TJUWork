//
//  ContactTableViewCell.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/29.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit

fileprivate let selectedColor = UIColor(hex6: 0x8db6d4)
fileprivate let unselectedColor = UIColor.lightGray

class ContactTableViewCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "校党委"
        label.textColor = UIColor(hex6: 0x7d7d7d)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        return label
    }()
    
    let expandBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.resizedImage(image: UIImage(named: "+")!, scaledToWidth: 15.0), for: .normal)
        return btn
    }()
    
    let selectBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.resizedImage(image: UIImage(named: "联系人未选中")!, scaledToWidth: 18.0), for: .normal)
        return btn
    }()
    
    
    var isExpand: Bool = false {
        willSet {
            if newValue == true {
                expandBtn.setImage(UIImage.resizedImage(image: UIImage(named: "-")!, scaledToWidth: 15.0), for: .normal)
            } else {
                expandBtn.setImage(UIImage.resizedImage(image: UIImage(named: "+")!, scaledToWidth: 15.0), for: .normal)
            }
        }
    }
    
    var isAdd: Bool = false {
        willSet {
            if newValue == true {
                selectBtn.setImage(UIImage.resizedImage(image: UIImage(named: "联系人选中")!, scaledToWidth: 15.0), for: .normal)
                nameLabel.textColor = UIColor(hex6: 0x00518e)
            } else {
                selectBtn.setImage(UIImage.resizedImage(image: UIImage(named: "联系人未选中")!, scaledToWidth: 15.0), for: .normal)
                nameLabel.textColor = UIColor(hex6: 0x7d7d7d)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(expandBtn)
        contentView.addSubview(selectBtn)
        
        
        selectBtn.frame = CGRect(x: 10, y: 0, width: 25, height: 25)
        expandBtn.frame = CGRect(x: 35, y: 0, width: 25, height: 25)
        nameLabel.frame = CGRect(x: 60, y: 0, width: self.frame.size.width-60, height: 25)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
