//
//  ReceiverCollectionViewCell.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/8/1.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit

class ReceiverCollectionViewCell: UICollectionViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.text = "张三阿大女"
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        return label
    }()
    
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8.0
        return view
    }()
    
    let deleteBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .blue
        btn.setImage(UIImage.resizedImage(image: UIImage(named: "关闭")!, scaledToWidth: 16.0), for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.addSubview(backView)
        backView.addSubview(nameLabel)
        backView.addSubview(deleteBtn)
        
        //防止约束冲突
        //contentView.translatesAutoresizingMaskIntoConstraints = false
        
        backView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(3)
            make.bottom.top.equalToSuperview()
        }
        
        deleteBtn.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(25)
            make.right.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(7)
            make.left.equalToSuperview().inset(5)
            make.right.equalTo(deleteBtn.snp.left)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
