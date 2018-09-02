//
//  DownMenuView.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/16.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit

protocol DropDownDelegate: class {
    
    func didSelectCell(_ number: Int);
    
    
}

class DownMenuView: UIView {
    
    var tableView: UITableView!
    fileprivate var titleArr: [String] = []
    
    weak var delegate: DropDownDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //32.5*3
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 0), style: .plain)
        tableView.estimatedRowHeight = 32.5
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.bounces = false
        
        
        self.addSubview(tableView)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setMunuTitles(_ titles: [String]) {
        
    }
    
    
    func showMenuView() {
        
        self.bringSubview(toFront: tableView)
        UIView.animate(withDuration: 0.25, animations: {
            self.tableView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 32.5*3)
        })
        
    }
    
    func hideMenuView() {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.tableView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 0)
        })
        
    }
    
    
}

extension DownMenuView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hideMenuView()
        delegate?.didSelectCell(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32.5
    }
    
}

extension DownMenuView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        //cell.selectionStyle = .none
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 32.5))
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        label.textAlignment = .center
        label.textColor = UIColor(hex6: 0x8db6d4)
        
        let lineView = UIView(frame: CGRect(x: 0, y: 32.5-0.5, width: 80, height: 0.5))
        lineView.alpha = 0.6
        lineView.backgroundColor = UIColor.gray
        
        if indexPath.row ==  2 {
            lineView.backgroundColor = .clear
        }
        
        cell.contentView.addSubview(label)
        cell.contentView.addSubview(lineView)
        
        switch indexPath.row {
        case 0:
            label.text = "发件箱"
        case 1:
            label.text = "草稿箱"
        case 2:
            label.text = "垃圾箱"
        default:
            label.text = ""
        }
        
        return cell
    }
    
}



