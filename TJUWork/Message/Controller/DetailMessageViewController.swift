//
//  DetailMessageViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/23.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit
import SnapKit


fileprivate let WORK_FILE_ROOT_URL = "https://work-alpha.twtstudio.com"

class DetailMessageViewController: UIViewController {
    
    var tableView: UITableView!
    var downloadedFiles: [DownloadedFile] = []
    
    fileprivate let deleteBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("删除", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor(hex6: 0x00518e)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 13
        return btn
    }()
    
    fileprivate let replyBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("回复", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor(hex6: 0x00518e)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 13
        return btn
    }()
    
    fileprivate var datailInformation: DetailMessageModel!
    fileprivate var mid: String?
    fileprivate var isReply: Bool?
    fileprivate var messageType: DownMenuView.MenuType?
    fileprivate var isReaded: Bool!
    
    convenience init(mid: String, isReply: Bool, messageType: DownMenuView.MenuType, isReaded: Bool) {
        self.init()
        self.mid = mid
        self.isReply = isReply
        self.messageType = messageType
        self.isReaded = isReaded
//        if isReaded == false {
//            NotificationCenter.default.post(name: NotificationName.NotificationRefreshInboxLists.name, object: nil)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "详情"
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
       
        tableView.register(SenderTableViewCell.self, forCellReuseIdentifier: "SenderTableViewCell")
        tableView.register(SenderMultiLinesTableViewCell.self, forCellReuseIdentifier: "SenderMultiLinesTableViewCell")
        tableView.register(BodyContentsTableViewCell.self, forCellReuseIdentifier: "BodyContentsTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        
        deleteBtn.addTarget(self, action: #selector(deleteMessage(_:)), for: .touchUpInside)
        replyBtn.addTarget(self, action: #selector(replyMessage(_:)), for: .touchUpInside)
        
        
        PersonalMessageHelper.getDetailMessage(mid: mid!, success: { model in
            
            
            if self.isReaded == false {
                NotificationCenter.default.post(name: NotificationName.NotificationRefreshInboxLists.name, object: nil)
            }
            
            self.datailInformation = model
            if let file = model.data.file1 {
                self.downloadedFiles.append(file)
            }
            if let file = model.data.file2 {
                self.downloadedFiles.append(file)
            }
            if let file = model.data.file3 {
                self.downloadedFiles.append(file)
            }
            if let file = model.data.file4 {
                self.downloadedFiles.append(file)
            }
            if let file = model.data.file5 {
                self.downloadedFiles.append(file)
            }
            if let file = model.data.file6 {
                self.downloadedFiles.append(file)
            }
            
            self.tableView.reloadData()
        }, failure: {
            
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = .white
    }
   
    
}

extension DetailMessageViewController {
    
    @objc func deleteMessage(_ sender: UIButton) {
        
        let alertVC = UIAlertController(title: "删除", message: "确定要删除吗？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "不了", style: .default, handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        let deletAction = UIAlertAction(title: "删除", style: .default) { _ in
            if let type = self.messageType {
                switch type {
                case .inbox:
                    self.deleteBtn.isEnabled = false
                    self.replyBtn.isEnabled = false
                    
                    PersonalMessageHelper.deleteInbox(mid: [Int(self.mid!)!], success: {
                        NotificationCenter.default.post(name: NotificationName.NotificationRefreshInboxLists.name, object: nil)
                        NotificationCenter.default.post(name: NotificationName.NotificationRefreshCalendar.name, object: nil)
                        
                        self.navigationController?.popToRootViewController(animated: true)
                    }, failure: {
                        self.deleteBtn.isEnabled = true
                        self.replyBtn.isEnabled = true
                    })
                    
                case .outbox:
                    self.deleteBtn.isEnabled = false
                    self.replyBtn.isEnabled = false
                    
                    PersonalMessageHelper.deleteOutbox(mid: [Int(self.mid!)!], success: {
                        NotificationCenter.default.post(name: NotificationName.NotificationRefreshOutboxLists.name, object: nil)
                        NotificationCenter.default.post(name: NotificationName.NotificationRefreshCalendar.name, object: nil)
                        
                        self.navigationController?.popToRootViewController(animated: true)
                    }, failure: {
                        self.deleteBtn.isEnabled = true
                        self.replyBtn.isEnabled = true
                    })
                case .draft: break //不会执行
                }
            }
        }
        
        alertVC.addAction(cancelAction)
        alertVC.addAction(deletAction)
        self.present(alertVC, animated: true)
        
//        if let type = self.messageType {
//            switch type {
//            case .inbox:
//                PersonalMessageHelper.deleteInbox(mid: [Int(self.mid!)!], success: {
//                    NotificationCenter.default.post(name: NotificationName.NotificationRefreshInboxLists.name, object: nil)
//                    NotificationCenter.default.post(name: NotificationName.NotificationRefreshCalendar.name, object: nil)
////                    let messageVC = self.navigationController?.viewControllers[0] as! MessageViewController
////                    messageVC.refreshInboxLists()
////                    self.navigationController?.popViewController(animated: true)
//                    self.navigationController?.popToRootViewController(animated: true)
//                }, failure: {
//                    self.deleteBtn.isEnabled = true
//                    self.replyBtn.isEnabled = true
//                })
//
//            case .outbox:
//                PersonalMessageHelper.deleteOutbox(mid: [Int(self.mid!)!], success: {
//                    NotificationCenter.default.post(name: NotificationName.NotificationRefreshOutboxLists.name, object: nil)
//                    NotificationCenter.default.post(name: NotificationName.NotificationRefreshCalendar.name, object: nil)
////                    let messageVC = self.navigationController?.viewControllers[0] as! MessageViewController
////                    messageVC.refreshOutboxLists()
////                    self.navigationController?.popViewController(animated: true)
//                    self.navigationController?.popToRootViewController(animated: true)
//                }, failure: {
//                    self.deleteBtn.isEnabled = true
//                    self.replyBtn.isEnabled = true
//                })
//            case .draft: break //不会执行
//            }
//        }
        
    }
    
    @objc func replyMessage(_ sender: UIButton) {
        let replyName = self.datailInformation.data.responseBy == "0" ? "个人" : "标签"
        let replyVC = ReplyMessageViewController(mid: self.mid!, titleText: self.datailInformation.data.title, replyName: replyName, sendUID: self.datailInformation.data.sendUid)
        self.navigationController?.pushViewController(replyVC, animated: true)
    }
    
    @objc func downloadFile(_ sender: UIButton) {
        switch sender.tag {
        case 0...5:
            //let downloadVC = DownloadViewController(fileURL: URL(string: "https://work-alpha.twtstudio.com/file/2018-07-28-5b5be16c0160e.pdf")!)
            if let url = URL(string: WORK_FILE_ROOT_URL + self.downloadedFiles[sender.tag].href) {
                let downloadVC = DownloadViewController(fileURL: url)
                self.navigationController?.pushViewController(downloadVC, animated: true)
            }
            
        default:
            break
        }
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
        guard section == 3 else {
            return 0.0
        }
        return 55
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 3 else {
            return nil
        }
        
        if self.datailInformation == nil {
            return nil
        }
        
        deleteBtn.removeFromSuperview()
        replyBtn.removeFromSuperview()
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 55))
        view.backgroundColor = .clear
        
        if let reply = self.isReply {
            if reply == true {
                view.addSubview(deleteBtn)
                view.addSubview(replyBtn)
                deleteBtn.snp.makeConstraints { make in
                    make.top.equalToSuperview().inset(15)
                    make.height.equalTo(30)
                    make.width.equalTo(90)
                    make.right.equalTo(view.snp.centerX).offset(-17)
                }
                replyBtn.snp.makeConstraints { make in
                    make.top.equalToSuperview().inset(15)
                    make.height.equalTo(30)
                    make.width.equalTo(90)
                    make.left.equalTo(view.snp.centerX).offset(17)
                }
            } else {
                view.addSubview(deleteBtn)
                deleteBtn.snp.makeConstraints { make in
                    make.top.equalToSuperview().inset(15)
                    make.height.equalTo(30)
                    make.width.equalTo(100)
                    make.centerX.equalToSuperview()
                }
            }
            return view
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section == 2 && indexPath.row > 0 else {
            return UITableViewAutomaticDimension
        }
        return 25
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
            return 1+self.downloadedFiles.count
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard self.datailInformation != nil else {
                return UITableViewCell()
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderMultiLinesTableViewCell") as! SenderMultiLinesTableViewCell
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.headIndent = 49
            let str = "标题：" + self.datailInformation.data.title
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
                guard self.datailInformation != nil else {
                    return UITableViewCell()
                }
                cell.contentLabel.text = self.datailInformation.data.author
            case 1:
                cell.titleLabel.text = "发送单位："
                guard self.datailInformation != nil else {
                    return UITableViewCell()
                }
                cell.contentLabel.text = self.datailInformation.data.unit
            case 2:
                cell.titleLabel.text = "消息类别："
                guard self.datailInformation != nil else {
                    return UITableViewCell()
                }
                cell.contentLabel.text = self.datailInformation.data.type
            case 3:
                cell.titleLabel.text = "发送时间："
                guard self.datailInformation != nil else {
                    return UITableViewCell()
                }
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYY-MM-dd   HH:mm:ss"
                cell.contentLabel.text = formatter.string(from: self.datailInformation.data.from)
            default:
                return UITableViewCell()
            }
            return cell
        case 2:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTableViewCell") as! SenderTableViewCell
                cell.titleLabel.text = "附件："
                
                if self.downloadedFiles.count == 0 {
                    cell.contentLabel.text = "无"
                } else {
                    cell.contentLabel.text = ""
                }
                
                return cell
            case 1...6:
                let cell = UITableViewCell()
                let contentView = UIView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width-20, height: 25))
                contentView.backgroundColor = .white
                cell.backgroundColor = .clear
                
                let maxWidth = UIScreen.main.bounds.size.width-20-90-20
                let imgView = UIImageView(frame: CGRect(x: 70, y: 0, width: 15, height: 15))
                imgView.image = UIImage.resizedImage(image: UIImage(named: "附件")!, scaledToWidth: 15.0)
                let btn = UIButton(frame: CGRect(x: 90, y: 0, width: maxWidth, height: 15))
                //self.downloadedFiles[indexPath.row-1].originName+self.downloadedFiles[indexPath.row-1].href
                //btn.setTitle("sefiwehv.pdf", for: .normal)
                let file = self.downloadedFiles[indexPath.row-1]
                btn.setTitle(file.originName + "（" + file.size + "）", for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.regular)
                btn.setTitleColor(UIColor(hex6: 0x003A65), for: .normal)
                btn.titleLabel?.textAlignment = .left
                btn.contentHorizontalAlignment = .left
                contentView.addSubview(btn)
                contentView.addSubview(imgView)
                
                let btnSize = btn.sizeThatFits(CGSize(width: 400, height: 15))
                if btnSize.width < maxWidth {
                    btn.frame.size = CGSize(width: btnSize.width, height: 15)
                }
                
                btn.tag = indexPath.row-1
                btn.addTarget(self, action: #selector(downloadFile(_:)), for: .touchUpInside)
                
                cell.contentView.addSubview(contentView)
                return cell
            default:
                return UITableViewCell()
            }
        case 3:
            guard self.datailInformation != nil else {
                return UITableViewCell()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "BodyContentsTableViewCell") as! BodyContentsTableViewCell
            let HTMLString: String = self.datailInformation.data.text
            if let attributedString = try? NSAttributedString(data: HTMLString.data(using: .unicode)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil) {
                cell.contentLabel.attributedText = attributedString
            }
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



