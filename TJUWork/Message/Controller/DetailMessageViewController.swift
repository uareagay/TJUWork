//
//  DetailMessageViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/23.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit
import SnapKit

class DetailMessageViewController: UIViewController {
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        
       
        
        tableView.register(SenderTableViewCell.self, forCellReuseIdentifier: "SenderTableViewCell")
        tableView.register(SenderMultiLinesTableViewCell.self, forCellReuseIdentifier: "SenderMultiLinesTableViewCell")
        tableView.register(BodyContentsTableViewCell.self, forCellReuseIdentifier: "BodyContentsTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }
    
    
    
}

extension DetailMessageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 10
        case 1:
            return 7.5
        case 2:
            return 7.5
        case 3:
            return 10
        default:
            return 0.1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return UIView()
        case 1:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 7.5))
            let contentView = UIView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width-20, height: 7.5))
            let lineView = UIView(frame: CGRect(x: 50+20, y: 3, width: UIScreen.main.bounds.size.width-20-50-20-15, height: 1.5))
            contentView.backgroundColor = .white
            lineView.backgroundColor = UIColor(hex6: 0xe5edf3)
            
            view.addSubview(contentView)
            contentView.addSubview(lineView)
            return view
        case 2:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 7.5))
            let contentView = UIView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width-20, height: 7.5))
            let lineView = UIView(frame: CGRect(x: 50+20, y: 3, width: UIScreen.main.bounds.size.width-20-50-20-15, height: 1.5))
            contentView.backgroundColor = .white
            lineView.backgroundColor = UIColor(hex6: 0xe5edf3)
            
            view.addSubview(contentView)
            contentView.addSubview(lineView)
            return view
        case 3:
            return UIView()
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section == 3 && indexPath.row == 0 else {
            return UITableViewAutomaticDimension
        }
        
        return UITableViewAutomaticDimension
        
    }
    
    
    
}

extension DetailMessageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        case 2:
            return 1
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderMultiLinesTableViewCell") as! SenderMultiLinesTableViewCell
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.headIndent = 49
            //paragraphStyle.lineSpacing = 10
            
            let str = "标题：本次活动感谢同学们的大力支持和帮助，我不胜感激，临表涕零，持知所以"
            let attStr = NSMutableAttributedString(string: str)
            
            attStr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, str.count))
            attStr.addAttribute(.foregroundColor, value: UIColor.lightGray , range: NSMakeRange(3, str.count-3))
            
            cell.titleLabel.attributedText = attStr
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTableViewCell") as! SenderTableViewCell
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "作者："
                cell.contentLabel.text = "张三"
            case 1:
                cell.titleLabel.text = "发送单位："
                cell.contentLabel.text = "校团委"
            case 2:
                cell.titleLabel.text = "消息类别："
                cell.contentLabel.text = "通知消息"
            case 3:
                cell.titleLabel.text = "发送时间："
                cell.contentLabel.text = "2018-7-21  15:20:04"
            default:
                return UITableViewCell()
            }
            return cell
        case 2:
            return UITableViewCell()
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BodyContentsTableViewCell") as! BodyContentsTableViewCell
            
            return cell
        default:
            return UITableViewCell()
        }
        
        
    }
    
}

class NiuNiu: NSObject {
    
}

extension UIView {
//    func hehe() {
//        self.blockm
//    }
    struct victim {
        
    }
    var blockm: Int? {
        get {
            return 2
        }
    }
    
}

extension UIButton {
//    func heihei() {
//        blo
//    }
    
    //override var blockm: Int?
}



