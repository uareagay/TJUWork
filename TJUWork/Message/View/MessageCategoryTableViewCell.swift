//
//  MessageCategoryTableViewCell.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/31.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit


protocol InformAndReplyProtocol: class {
    func foldTableView(_ isFold: Bool);
}

fileprivate let unSelectedImg = UIImage.resizedImage(image: UIImage(named: "类别未选中")!, scaledToWidth: 15.0)
fileprivate let selectedImg = UIImage.resizedImage(image: UIImage(named: "类别选中")!, scaledToWidth: 17.0)

fileprivate var gapWidth: CGFloat {
    guard UIScreen.main.bounds.size.width == 320 else {
        return 10
    }
    return 1
}

class MessageCategoryTableViewCell: UITableViewCell {
    
    weak var delegate: InformAndReplyProtocol?
    
    enum MessageCategoryName {
        case inform//通知信息
        //case conference//会议信息
        case work//工作信息
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex6: 0x00518e)
        label.text = "消息类别："
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        return label
    }()
    
    let informLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex6: 0x8b8b8b)
        label.text = "通知信息"
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        return label
    }()
    
    
    let informBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(unSelectedImg, for: .normal)
        return btn
    }()
    
//    let conferenceLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .left
//        label.textColor = UIColor(hex6: 0x8b8b8b)
//        label.text = "会议信息"
//        label.font = UIFont.systemFont(ofSize: fontFloat, weight: UIFont.Weight.regular)
//        return label
//    }()
//
//    let conferenceBtn: UIButton = {
//        let btn = UIButton()
//        btn.setImage(unSelectedImg, for: .normal)
//        return btn
//    }()
    
    let workLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex6: 0x8b8b8b)
        label.text = "工作信息"
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        return label
    }()
    
    let workBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(unSelectedImg, for: .normal)
        return btn
    }()
    
//    fileprivate let pieceWidth: CGFloat = (UIScreen.main.bounds.size.width-10-10-15-90-10)/3
    
    var categoryStatus: MessageCategoryName? = nil {
        didSet {
            
            if let status = categoryStatus {
                switch status {
                case .inform:
                    informBtn.setImage(selectedImg, for: .normal)
                    workBtn.setImage(unSelectedImg, for: .normal)
                    informLabel.textColor = UIColor(hex6: 0x5874b1)
                    workLabel.textColor = UIColor(hex6: 0x8b8b8b)
                    delegate?.foldTableView(true)
                case .work:
                    informBtn.setImage(unSelectedImg, for: .normal)
                    workBtn.setImage(selectedImg, for: .normal)
                    informLabel.textColor = UIColor(hex6: 0x8b8b8b)
                    workLabel.textColor = UIColor(hex6: 0x5874b1)
                    delegate?.foldTableView(false)
                }
            }
            
//            switch categoryStatus {
//            case .inform?:
//                informBtn.setImage(selectedImg, for: .normal)
////                conferenceBtn.setImage(unSelectedImg, for: .normal)
//                workBtn.setImage(unSelectedImg, for: .normal)
//                informLabel.textColor = UIColor(hex6: 0x5874b1)
////                conferenceLabel.textColor = UIColor(hex6: 0x8b8b8b)
//                workLabel.textColor = UIColor(hex6: 0x8b8b8b)
////            case .conference:
////                informBtn.setImage(unSelectedImg, for: .normal)
////                conferenceBtn.setImage(selectedImg, for: .normal)
////                workBtn.setImage(unSelectedImg, for: .normal)
////                informLabel.textColor = UIColor(hex6: 0x8b8b8b)
////                conferenceLabel.textColor = UIColor(hex6: 0x5874b1)
////                workLabel.textColor = UIColor(hex6: 0x8b8b8b)
//            case .work:
//                informBtn.setImage(unSelectedImg, for: .normal)
////                conferenceBtn.setImage(unSelectedImg, for: .normal)
//                workBtn.setImage(selectedImg, for: .normal)
//                informLabel.textColor = UIColor(hex6: 0x8b8b8b)
////                conferenceLabel.textColor = UIColor(hex6: 0x8b8b8b)
//                workLabel.textColor = UIColor(hex6: 0x5874b1)
//            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        titleLabel.snp.makeConstraints { make in
//            make.left.equalToSuperview().inset(20)
//            make.top.bottom.equalToSuperview().inset(10)
//            make.width.equalTo(90)
//        }
//
//        personalBtn.snp.makeConstraints { make in
//            make.left.equalTo(titleLabel.snp.right).offset(5)
//            make.top.bottom.equalToSuperview().inset(15)
//            make.width.equalTo(25)
//        }
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(informBtn)
        contentView.addSubview(informLabel)
//        contentView.addSubview(conferenceBtn)
//        contentView.addSubview(conferenceLabel)
        contentView.addSubview(workBtn)
        contentView.addSubview(workLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(90)
        }
        
        informBtn.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right)
            make.top.bottom.equalToSuperview().inset(5)
            make.width.equalTo(25)
        }
        
        informLabel.snp.makeConstraints { make in
            make.left.equalTo(informBtn.snp.right)
            make.top.bottom.equalToSuperview().inset(15)
            make.width.equalTo(70)
        }
        
//        conferenceBtn.snp.makeConstraints { make in
//            make.left.equalTo(informLabel.snp.right)
//            make.top.bottom.equalToSuperview().inset(5)
//            make.width.equalTo(15)
//        }
//
//        conferenceLabel.snp.makeConstraints { make in
//            make.left.equalTo(conferenceBtn.snp.right)
//            make.top.bottom.equalToSuperview().inset(15)
//            make.width.equalTo(pieceWidth-15)
//        }
        
        workBtn.snp.makeConstraints { make in
            make.left.equalTo(informLabel.snp.right).offset(gapWidth)
            make.top.bottom.equalToSuperview().inset(5)
            make.width.equalTo(25)
        }
        
        workLabel.snp.makeConstraints { make in
            make.left.equalTo(workBtn.snp.right)
            make.top.bottom.equalToSuperview().inset(15)
            make.width.equalTo(70)
        }
        
        informBtn.addTarget(self, action: #selector(changeCategoryName(_:)), for: .touchUpInside)
//        conferenceBtn.addTarget(self, action: #selector(changeCategoryName(_:)), for: .touchUpInside)
        workBtn.addTarget(self, action: #selector(changeCategoryName(_:)), for: .touchUpInside)
        
        informBtn.tag = 101
//        conferenceBtn.tag = 102
        workBtn.tag = 103
        
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
    
    @objc func changeCategoryName(_ sender: UIButton) {
        switch sender.tag {
        case 101:
            categoryStatus = .inform
//        case 102:
//            categoryStatus = .conference
        case 103:
            categoryStatus = .work
        default:
            return
        }
    }
    
}
