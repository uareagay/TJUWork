//
//  DeadlineTableViewCell.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/2.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit

class DeadlineTableViewCell: UITableViewCell {
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex6: 0x00518e)
        label.text = "截止时间："
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        return label
    }()
    
    let dateLabel: PickerViewLabel = {
        let label = PickerViewLabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex6: 0x8b8b8b)
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd   HH:mm"
        label.text = formatter.string(from: Date(timeIntervalSinceNow: 0))
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        return label
    }()
    
    fileprivate let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        datePicker.locale = Locale(identifier: "zh_CN")
        return datePicker
    }()
    
    fileprivate let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex6: 0x8b8b8b)
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(bottomView)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(90)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right)
            make.top.bottom.equalToSuperview().inset(15)
            make.width.equalTo(128)
        }
        
        bottomView.snp.makeConstraints { make in
            make.left.equalTo(dateLabel.snp.left).offset(-3)
            make.right.equalTo(dateLabel.snp.right)
            make.top.equalTo(dateLabel.snp.bottom).offset(-2)
            make.height.equalTo(1)
        }
        
        dateLabel.inputView = datePicker
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
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

extension DeadlineTableViewCell {
    
    @objc func dateChanged(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd   HH:mm"
        dateLabel.text = formatter.string(from: datePicker.date)
    }
    
}
