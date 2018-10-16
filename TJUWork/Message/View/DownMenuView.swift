//
//  DownMenuView.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/16.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit

protocol DropDownDelegate: class {
    
    func didSelectCell(_ typr: DownMenuView.MenuType);
    
    
}

class DownMenuView: UIView {
    
    var tableView: UITableView!
    fileprivate var titleArrs: [String] = ["发件箱", "草稿箱"]
    
    weak var delegate: DropDownDelegate?
    
    var selectedType: DownMenuView.MenuType = .inbox {
        didSet {
            switch selectedType {
            case .inbox:
                self.titleArrs = ["发件箱", "草稿箱"]
            case .outbox:
                self.titleArrs = ["收件箱", "草稿箱"]
            case .draft:
                self.titleArrs = ["收件箱", "发件箱"]
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //32.5*3
        //50*3
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 0), style: .plain)
//        tableView.estimatedRowHeight = 32.5
        tableView.rowHeight = 50
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
    
    
}

extension DownMenuView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hideMenuView()
        tableView.deselectRow(at: indexPath, animated: false)
        
        let menuString = self.titleArrs[indexPath.row]
        switch menuString {
        case "收件箱":
            self.selectedType = .inbox
            delegate?.didSelectCell(.inbox)
        case "发件箱":
            self.selectedType = .outbox
            delegate?.didSelectCell(.outbox)
        case "草稿箱":
            self.selectedType = .draft
            delegate?.didSelectCell(.draft)
        default:
            return
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 32.5
//    }
    
}

extension DownMenuView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        //cell.selectionStyle = .none
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 110, height: 50))
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        label.textAlignment = .center
        label.textColor = UIColor(hex6: 0x8db6d4)
        
//        let lineView = UIView(frame: CGRect(x: 0, y: 32.5-0.5, width: 80, height: 0.5))
        let lineView = UIView(frame: CGRect(x: 0, y: 50-0.5, width: 110, height: 0.5))
        lineView.alpha = 0.6
        lineView.backgroundColor = UIColor.gray
        
        if indexPath.row ==  1 {
            lineView.backgroundColor = .clear
        }
        
        cell.contentView.addSubview(label)
        cell.contentView.addSubview(lineView)
        
        switch indexPath.row {
        case 0:
            label.text = self.titleArrs[0]
        case 1:
            label.text = self.titleArrs[1]
        default:
            label.text = ""
        }
        
        return cell
    }
    
}

extension DownMenuView {
    
    func showMenuView() {
        self.tableView.reloadData()
        self.bringSubview(toFront: tableView)
        UIView.animate(withDuration: 0.25, animations: {
//            self.tableView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 32.5*2)
            self.tableView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50*2)
        })
    }
    
    func hideMenuView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.tableView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 0)
        })
    }
    
    enum MenuType {
        case inbox   //收件列表
        case outbox  //发件列表
        case draft   //草稿列表
    }
    
}



