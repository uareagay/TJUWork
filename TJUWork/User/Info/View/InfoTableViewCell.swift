//
//  InfoTableViewCell.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/14.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit
import SnapKit

class InfoTableViewCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "用户名："
        label.textColor = UIColor(hex6: 0x8db6d4)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "User"
        label.textColor = UIColor(hex6: 0x006cbe)
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        
        return label
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex6: 0x8db6d4)
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(lineView)
        
        nameLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.left.equalToSuperview().inset(15)
            make.width.equalTo(70)
        }
        infoLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.right.equalToSuperview().inset(15)
            make.width.equalTo(220)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
