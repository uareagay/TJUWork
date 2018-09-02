//
//  AddReceiverCollectionViewCell.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/8/2.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit

class AddReceiverCollectionViewCell: UICollectionViewCell {
    
    let addBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .blue
        btn.setImage(UIImage.resizedImage(image: UIImage(named: "加号")!, scaledToWidth: 20.0), for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 8.0
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(addBtn)
        addBtn.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
