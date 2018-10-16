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
    fileprivate var isDisplayPeople: Bool!
    
    fileprivate var readArrs: [ReadPeople] = []
    fileprivate var unReadArrs: [ReadPeople] = []
    fileprivate var isDisplayRead: Bool = false
    fileprivate var readPercent: Float = 0.0
    
    fileprivate var responseArrs: [ResponsePeople] = []
    fileprivate var unResponseArrs: [ResponsePeople] = []
    fileprivate var isDisplayResponse: Bool = false
    fileprivate var responsePercent: Float = 0.0
    
    convenience init(mid: String, isReply: Bool, messageType: DownMenuView.MenuType, isReaded: Bool, isDisplayPeople: Bool = false) {
        self.init()
        self.mid = mid
        self.isReply = isReply
        self.messageType = messageType
        self.isReaded = isReaded
        self.isDisplayPeople = isDisplayPeople
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
        //tableView.allowsSelection = false
       
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
        
        if self.isDisplayPeople == true {
            let group = DispatchGroup()
            
            group.enter()
            PersonalMessageHelper.getReadPeoples(mid: self.mid!, success: { model in
                self.readArrs = model.data.finished
                self.unReadArrs = model.data.unfinished
                let hasRead: Float = Float(model.data.hasRead)
                let needRead: Float = Float(model.data.needRead)
                self.readPercent = hasRead * 100 / needRead
                
                group.leave()
            }, failure: {
                group.leave()
            })
            
            group.enter()
            PersonalMessageHelper.getResponsePeoples(mid: self.mid!, success: { model in
                self.responseArrs = model.data.finished
                self.unResponseArrs = model.data.unfinished
                let hasResponded: Float = Float(model.data.hasResponded)
                let needRespond: Float = Float(model.data.needRespond)
                self.responsePercent = hasResponded * 100 / needRespond
                
                group.leave()
            }, failure: {
                group.leave()
            })
            
            group.enter()
            PhoneBook.shared.getPhoneNumber(success: {
                group.leave()
            }, failure: {
                group.leave()
            })
            
            group.notify(queue: DispatchQueue.main) {
                self.tableView.reloadData()
            }

        }
        
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
        guard self.isDisplayPeople else {
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
        
        switch section {
        case 0:
            return 10
        case 1:
            return 7.5
        case 2:
            return 7.5
        case 3:
            return 7.5
        case 4:
            return 7.5
        case 5:
            return 10
        default:
            return 0.1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard self.isDisplayPeople else {
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
        
        switch section {
        case 0:
            return UIView()
        case 1...4:
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 7.5))
            let contentView = UIView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width-20, height: 7.5))
            let lineView = UIView(frame: CGRect(x: 50+20, y: 3, width: UIScreen.main.bounds.size.width-20-50-20-15, height: 1.5))
            contentView.backgroundColor = .white
            lineView.backgroundColor = UIColor(hex6: 0xe5edf3)
            
            view.addSubview(contentView)
            contentView.addSubview(lineView)
            return view
        case 5:
            return UIView()
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard self.isDisplayPeople else {
            guard section == 3 else {
                return 0.0
            }
            return 55
        }
        
        guard section == 5 else {
            return 0.0
        }
        return 55
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if !self.isDisplayPeople && section < 3 {
            return nil
        }
        
        if self.isDisplayPeople && section < 5 {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.isDisplayPeople else {
            return
        }
        
        if indexPath.section == 3 && indexPath.row == 0 {
//            tableView.deselectRow(at: indexPath, animated: true)
            self.isDisplayResponse = !self.isDisplayResponse
            self.tableView.reloadData()
        } else if indexPath.section == 4 && indexPath.row == 0 {
//            tableView.deselectRow(at: indexPath, animated: true)
            self.isDisplayRead = !self.isDisplayRead
            self.tableView.reloadData()
        }
    }
    
}

extension DetailMessageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard self.isDisplayPeople else {
            return 4
        }
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard self.isDisplayPeople else {
//            switch section {
//            case 1:
//                return 4
//            case 2:
//                return 1 + self.downloadedFiles.count
//            default:
//                return 1
//            }
//        }
//
//        switch section {
//        case 1:
//            return 4
//        case 2:
//            return 1 + self.downloadedFiles.count
//        case 3:
//            return 1 + self.responseArrs.count
//        case 4:
//            return 1 + self.readArrs.count
//        default:
//            return 1
//        }
        switch section {
        case 1:
            return 4
        case 2:
            return 1 + self.downloadedFiles.count
        case 3:
            if self.isDisplayPeople {
                return !self.isDisplayResponse ? 1 : 1 + self.responseArrs.count + self.unResponseArrs.count
            } else {
                return 1
            }
        case 4:
            if self.isDisplayPeople {
                return !self.isDisplayRead ? 1 : 1 + self.readArrs.count + self.unReadArrs.count
            } else {
                return 1
            }
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.isDisplayPeople else {
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
                
                cell.selectionStyle = .none
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
                
                cell.selectionStyle = .none
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
                    
                    cell.selectionStyle = .none
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
                    
                    cell.selectionStyle = .none
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
                
                cell.selectionStyle = .none
                return cell
            default:
                return UITableViewCell()
            }
        }
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
            
            cell.selectionStyle = .none
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
            
            cell.selectionStyle = .none
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
                
                cell.selectionStyle = .none
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
                
                cell.selectionStyle = .none
                return cell
            default:
                return UITableViewCell()
            }
        case 3:
            guard indexPath.row == 0 else {
                let cell = PeopleSituationTableViewCell()
                if indexPath.row <= self.responseArrs.count {
                    let index = indexPath.row - 1
                    cell.nameLabel.text = self.responseArrs[index].name
                    cell.flagLabel.text = "已回复"
                    cell.flagLabel.textColor = .gray
                } else {
                    let index = indexPath.row - self.responseArrs.count - 1
                    cell.nameLabel.text = self.unResponseArrs[index].name
                    cell.flagLabel.text = "未回复"
                    cell.flagLabel.textColor = .red
                }
                cell.phoneBtn.isHidden = true
                
                cell.selectionStyle = .none
                return cell
            }
            
            return getSituationTypeTableViewCell("回复状态")
        case 4:
            guard indexPath.row == 0 else {
                let cell = PeopleSituationTableViewCell()
                if indexPath.row <= self.readArrs.count {
                    let index = indexPath.row - 1
                    cell.nameLabel.text = self.readArrs[index].name
                    cell.flagLabel.text = "已阅读"
                    cell.flagLabel.textColor = .gray
                    cell.phoneBtn.tag = Int(self.readArrs[index].uid) ?? 0
                } else {
                    let index = indexPath.row - self.readArrs.count - 1
                    cell.nameLabel.text = self.unReadArrs[index].name
                    cell.flagLabel.text = "未阅读"
                    cell.flagLabel.textColor = .red
                    cell.phoneBtn.tag = Int(self.unReadArrs[index].uid) ?? 0
                }
                
                cell.phoneBtn.addTarget(self, action: #selector(phoneTapped(_:)), for: .touchUpInside)
                
                cell.selectionStyle = .none
                return cell
            }
            return getSituationTypeTableViewCell("阅读状态")
        case 5:
            guard self.datailInformation != nil else {
                return UITableViewCell()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "BodyContentsTableViewCell") as! BodyContentsTableViewCell
            let HTMLString: String = self.datailInformation.data.text
            if let attributedString = try? NSAttributedString(data: HTMLString.data(using: .unicode)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil) {
                cell.contentLabel.attributedText = attributedString
            }
            
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}

extension DetailMessageViewController {
    func getSituationTypeTableViewCell(_ text: String) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        let backView = UIView()
        backView.backgroundColor = .white
        
        cell.contentView.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.bottom.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        titleLabel.textColor = UIColor(hex6: 0x00518e)
        backView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(80)
        }
        
        let btn = UIButton(type: .custom)
        if text == "回复状态" {
            btn.setTitle(String(self.responsePercent)+" %", for: .normal)
        } else {
            btn.setTitle(String(self.readPercent)+" %", for: .normal)
        }
        
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor(hex6: 0x00518e)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 8
        backView.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        
        let downBtn = UIButton(type: .custom)
        downBtn.isUserInteractionEnabled = false
        downBtn.setImage(UIImage.resizedImage(image: UIImage(named: "向下")!, scaledToWidth: 12.0), for: .normal)
        backView.addSubview(downBtn)
        downBtn.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.right.equalToSuperview().inset(15)
            make.width.equalTo(20)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func phoneTapped(_ sender: UIButton) {
        for userData in PhoneBook.shared.items where userData.uid == String(sender.tag) {
            if let phone = userData.phone {
                if let url = URL(string: "telprompt://\(phone)") {
                    UIApplication.shared.open(url)
                }
            }
            return
        }
        
    }
    
}
