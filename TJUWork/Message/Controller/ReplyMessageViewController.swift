//
//  ReplyMessageViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/9/14.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import Foundation


class ReplyMessageViewController: UIViewController {
    
    fileprivate var textView: UITextView = {
        let textView = UITextView()
        textView.text = "编辑内容"
        textView.textColor = .lightGray
        textView.backgroundColor = .white
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return textView
    }()
    
    var HTMLString: String = "<p>编辑内容</p>" {
        didSet {
//            if let attributedString = try? NSAttributedString(data: (HTMLString.data(using: .unicode))!, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil) {
//                self.textView.attributedText = attributedString
//            }
        }
    }
    
    fileprivate let replyBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("发送", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor(hex6: 0x00518e)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 13
        return btn
    }()
    
    var tableView: UITableView!
    
    fileprivate var titleText: String = ""
    fileprivate var replyName: String = ""
    fileprivate var mid: String = ""
    fileprivate var sendUID: String = ""
    
    convenience init(mid: String, titleText: String, replyName: String, sendUID: String) {
        self.init()
        self.replyName = replyName
        self.titleText = "回复：" + titleText
        self.mid = mid
        self.sendUID = sendUID
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.register(SenderTableViewCell.self, forCellReuseIdentifier: "SenderTableViewCell")
        tableView.register(SenderMultiLinesTableViewCell.self, forCellReuseIdentifier: "SenderMultiLinesTableViewCell")
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        self.textView.delegate = self
        
        replyBtn.addTarget(self, action: #selector(replyMessageAction(_:)), for: .touchUpInside)
    }
    
}

extension ReplyMessageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 1 else {
            return 10
        }
        return 7.5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section == 2 else {
            return 0.0
        }
        return 55
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 1 else {
            return UIView()
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 7.5))
        let contentView = UIView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width-20, height: 7.5))
        let lineView = UIView(frame: CGRect(x: 50+20, y: 3, width: UIScreen.main.bounds.size.width-20-50-20-15, height: 1.5))
        contentView.backgroundColor = .white
        lineView.backgroundColor = UIColor(hex6: 0xe5edf3)
        
        view.addSubview(contentView)
        contentView.addSubview(lineView)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 2 else {
            return nil
        }
        
        replyBtn.removeFromSuperview()
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 55))
        view.backgroundColor = .clear
        
        view.addSubview(replyBtn)
        replyBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.height.equalTo(30)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section == 2 else {
            return UITableViewAutomaticDimension
        }
        return 350
    }
    
}

extension ReplyMessageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderMultiLinesTableViewCell") as! SenderMultiLinesTableViewCell
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.headIndent = 49
            let str = "标题："+self.titleText
            let attStr = NSMutableAttributedString(string: str)
            attStr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, str.count))
            attStr.addAttribute(.foregroundColor, value: UIColor.lightGray , range: NSMakeRange(3, str.count-3))
            cell.titleLabel.attributedText = attStr
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTableViewCell") as! SenderTableViewCell
            cell.titleLabel.textColor = .lightGray
            cell.titleLabel.text = "回复名义："
            cell.contentLabel.text = self.replyName
            return cell
        case 2:
            let cell = UITableViewCell()
            self.textView.removeFromSuperview()
            cell.contentView.backgroundColor = .clear
            cell.backgroundColor = .clear
            cell.contentView.addSubview(self.textView)
            textView.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(10)
                make.top.bottom.equalToSuperview()
            }
            return cell
        default: return UITableViewCell()
        }
        
    }
}

extension ReplyMessageViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let richTextVC = RichTextViewController(isReply: true)
        richTextVC.hidesBottomBarWhenPushed = true
        richTextVC.setHTML(self.HTMLString)
        richTextVC.delegate = self
        
        self.navigationController?.pushViewController(richTextVC, animated: true)
        return false
    }
    
}

extension ReplyMessageViewController {
    
    @objc func replyMessageAction(_ sender: UIButton) {
        var dic: [String:Any] = [:]
        
        dic["type"] = "0"
        dic["title"] = self.titleText
        dic["text"] = self.HTMLString
        dic["author"] = "0"
        //dic["deadline"] = ""
        dic["response_by"] = "0"
        dic["response_to"] = self.mid
        dic["receive_labels"] = []
        dic["receivers[0]"] = self.sendUID
        
        self.replyBtn.isEnabled = false
        self.textView.isUserInteractionEnabled = false
        
        PersonalMessageHelper.sendMessage(dictionary: dic, success: {
            NotificationCenter.default.post(name: NotificationName.NotificationRefreshInboxLists.name, object: nil)
            NotificationCenter.default.post(name: NotificationName.NotificationRefreshOutboxLists.name, object: nil)
            NotificationCenter.default.post(name: NotificationName.NotificationRefreshCalendar.name, object: nil)
//            let messageVC = self.navigationController?.viewControllers[0] as! MessageViewController
//            messageVC.tableView.mj_header.beginRefreshing()
            self.navigationController?.popToRootViewController(animated: true)
        }, failure: {
            self.replyBtn.isEnabled = true
            self.textView.isUserInteractionEnabled = true
        })
    }
    
}

extension ReplyMessageViewController: RichTextTransmitProtocol {
    
    func transmitText(_ text: String) {
        self.HTMLString = text
        if let attributedString = try? NSAttributedString(data: (text.data(using: .unicode))!, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil) {
            self.textView.attributedText = attributedString
        }
    }
    
}
