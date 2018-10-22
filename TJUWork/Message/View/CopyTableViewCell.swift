//
//  CopyTableViewCell.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/10/22.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import Foundation


class CopyTableViewCell: UITableViewCell {
    
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex6: 0x00518e)
        label.text = "抄送消息"
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        return label
    }()
    
    fileprivate let copySwitch: UISwitch = {
        let copySwitch = UISwitch()
        return copySwitch
    }()
    
    var isCopy: Bool {
        return self.copySwitch.isOn
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(copySwitch)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(70)
        }
        
        copySwitch.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(15)
            //make.top.bottom.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            //make.right.equalToSuperview()
            //make.width.equalTo(130)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect {
        didSet {
            var newFrame = frame
            newFrame.origin.x += 10
            newFrame.size.width -= 20
            super.frame = newFrame
        }
    }
    
    
}

