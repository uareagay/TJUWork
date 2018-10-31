//
//  PeopleSituationTableViewCell.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/10/13.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import Foundation


class PeopleSituationTableViewCell: UITableViewCell {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        return label
    }()
    
    let flagLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        return label
    }()
    
    let phoneBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.resizedImage(image: UIImage(named: "电话")!, scaledToWidth: 20.0), for: .normal)
        return btn
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(flagLabel)
        contentView.addSubview(phoneBtn)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(25)
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(150)
            make.height.equalTo(25)
        }
        flagLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.right).offset(10)
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(60)
        }
        phoneBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
            make.width.equalTo(50)
            make.centerY.equalToSuperview()
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
