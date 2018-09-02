//
//  SenderMultiLinesTableViewCell.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/23.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit

class SenderMultiLinesTableViewCell: UITableViewCell {
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex6: 0x00518e)
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        return label
    }()
    
    let whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(whiteView)
        whiteView.addSubview(titleLabel)
        
        //titleLabel.sizeToFit()
        whiteView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(5)
            make.right.equalToSuperview().inset(15)
        }
        
        
    }
    
//    override var frame: CGRect {
//        didSet {
//            var newFrame = frame
//            newFrame.origin.x += 10
//            newFrame.size.width -= 20
//            super.frame = newFrame
//        }
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
