//
//  ScheduleMessageTableViewCell.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/20.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit
import SnapKit

class ScheduleMessageTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "关于2018年夏季研究生毕业典礼，毕业晚会和本科。。。"
        label.textColor = UIColor(hex6: 0x00518e)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "学工部"
        label.textColor = UIColor(hex6: 0x8db6d4)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2018/7/10  19:30"
        label.textColor = UIColor(hex6: 0x8db6d4)
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        return label
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex6: 0x00518e)
        return view
    }()
    
    
    //65
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        contentView.addSubview(lineView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        
        lineView.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
            make.width.equalTo(5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(3)
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(30)
            make.height.equalTo(29)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.left.equalToSuperview().inset(15)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        
        
        
    }
    
    override var frame: CGRect {
        didSet {
            var newFrame = frame
            newFrame.origin.x += 10
            newFrame.size.width -= 20
            newFrame.origin.y += 5
            newFrame.size.height -= 5
            super.frame = newFrame
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
