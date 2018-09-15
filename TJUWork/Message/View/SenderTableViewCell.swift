//
//  SenderTableViewCell.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/23.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit

class SenderTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex6: 0x00518e)
        label.text = "发送单位："
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .lightGray
        label.text = "校团委"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        
        titleLabel.sizeToFit()
        contentLabel.sizeToFit()
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(5)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right)
            make.top.bottom.equalToSuperview().inset(5)
            //make.right.equalToSuperview().inset(15)
        }
        
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

