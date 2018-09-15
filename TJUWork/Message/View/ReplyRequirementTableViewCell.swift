//
//  ReplyRequirementTableViewCell.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/2.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit

fileprivate let unSelectedImg = UIImage.resizedImage(image: UIImage(named: "类别未选中")!, scaledToWidth: 15.0)
fileprivate let selectedImg = UIImage.resizedImage(image: UIImage(named: "类别选中")!, scaledToWidth: 17.0)

class ReplyRequirementTableViewCell: UITableViewCell {
    
    enum ReplyType {
        case personal   //个人
        case college    //学院
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex6: 0x00518e)
        label.text = "回复要求："
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        return label
    }()
    
    let personalLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex6: 0x8b8b8b)
        label.text = "个人"
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        return label
    }()
    
    
    let personalBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(unSelectedImg, for: .normal)
        return btn
    }()
    
    let collegeLabel: PickerViewLabel = {
        let label = PickerViewLabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex6: 0x8b8b8b)
        label.text = "学院"
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        return label
    }()
    
    let collegeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(unSelectedImg, for: .normal)
        return btn
    }()
    
    var typeStatus: ReplyType? = nil {
        didSet {
            if typeStatus == .personal {
                personalBtn.setImage(selectedImg, for: .normal)
                collegeBtn.setImage(unSelectedImg, for: .normal)
                personalLabel.textColor = UIColor(hex6: 0x5874b1)
                collegeLabel.textColor = UIColor(hex6: 0x8b8b8b)
            } else {
                personalBtn.setImage(unSelectedImg, for: .normal)
                collegeBtn.setImage(selectedImg, for: .normal)
                personalLabel.textColor = UIColor(hex6: 0x8b8b8b)
                collegeLabel.textColor = UIColor(hex6: 0x5874b1)
            }
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(personalBtn)
        contentView.addSubview(personalLabel)
        contentView.addSubview(collegeBtn)
        contentView.addSubview(collegeLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(90)
        }
        
        personalBtn.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right)
            make.top.bottom.equalToSuperview().inset(15)
            make.width.equalTo(25)
        }
        
        personalLabel.snp.makeConstraints { make in
            make.left.equalTo(personalBtn.snp.right)
            make.top.bottom.equalToSuperview().inset(15)
            make.width.equalTo(40)
        }
        
        collegeBtn.snp.makeConstraints { make in
            make.left.equalTo(personalLabel.snp.right).offset(20)
            make.top.bottom.equalToSuperview().inset(15)
            make.width.equalTo(25)
        }
        
        collegeLabel.snp.makeConstraints { make in
            make.left.equalTo(collegeBtn.snp.right)
            make.top.bottom.equalToSuperview().inset(15)
            make.width.equalTo(40)
        }
        
        personalBtn.tag = 101
        collegeBtn.tag = 102
        
        personalBtn.addTarget(self, action: #selector(changeReplyType(_:)), for: .touchUpInside)
        collegeBtn.addTarget(self, action: #selector(changeReplyType(_:)), for: .touchUpInside)
        
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

extension ReplyRequirementTableViewCell {
    
    @objc func changeReplyType(_ sender: UIButton) {
        guard sender.tag == 101 else {
            typeStatus = .college
            return
        }
        typeStatus = .personal
    }
    
}
