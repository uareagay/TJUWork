//
//  CreateMessageViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/7/26.
//  Copyright © 2018年 赵家琛. All rights reserved.
//

import UIKit
import SnapKit
import SwiftMessages


class CreateMessageViewController: UIViewController {
    
    weak var delegete: AddAndDeleteReceiverProtocol?
    
    var treeTableView: TreeTableView!
    var entireUsersModel: EntireUsersModel!
    var entireLabelsModel: EntireLabelsModel!
    
    var tableView: UITableView!
    
    var pickerView: UIPickerView!
    
    var isReply: Bool = false {
        didSet {
            if isReply == true, oldValue == false {
                self.tableView.reloadData()
            } else if isReply == false, oldValue == true {
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate let emptyView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    deinit {
        print("wevjncqwejvnjwreqnvjqrnvjnq3vjn3qjvn")
    }
    
    fileprivate let popView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15.0
        
        guard UIScreen.main.bounds.height == 812 else {
            view.frame = CGRect(x: 35, y: 85, width: UIScreen.main.bounds.width-70, height: UIScreen.main.bounds.height-85-75)
            return view
        }
        view.frame = CGRect(x: 35, y: 100, width: UIScreen.main.bounds.width-70, height: UIScreen.main.bounds.height-100-110)
        
        return view
    }()
    
    fileprivate let  topLabel: UILabel = {
        let label = UILabel()
        label.text = "选取收件人"
        label.textColor = UIColor(hex6: 0x00518e)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.alpha = 0.6
        return label
    }()
    
    fileprivate let searchPeopleBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("搜索收件人", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        btn.setTitleColor(UIColor(hex6: 0x00518e), for: .normal)
        btn.titleLabel?.textAlignment = .right
        btn.contentHorizontalAlignment = .right
        btn.backgroundColor = .white
        return btn
    }()
    
    fileprivate let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex6: 0xe5edf3, alpha: 1.0)
        return view
    }()
    
    fileprivate let saveUsersBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("保存", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor(hex6: 0x00518e)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 13
        return btn
    }()
    
    fileprivate let cancelUsersBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("取消", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor(hex6: 0x00518e)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 13
        return btn
    }()
    
    fileprivate let sendBtn: UIButton = {
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
    
    fileprivate let storeDraftBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("存至草稿箱", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor(hex6: 0x00518e)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 13
        return btn
    }()
    
    var HTMLString: String = "" {
        didSet {
            //<p>编辑内容</p>
//            if let attributedString = try? NSAttributedString(data: (HTMLString.data(using: .unicode))!, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil) {
//                self.textView.attributedText = attributedString
//            }
        }
    }
    
    fileprivate var authorID: Int = 0
    
    fileprivate var textView: UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.textColor = .lightGray
        textView.backgroundColor = .white
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return textView
    }()
    
    fileprivate var messageTitle: String {
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TitleTableViewCell {
            return cell.textField.text ?? ""
        }
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell") as? TitleTableViewCell {
            return cell.textField.text ?? ""
        }
        return ""
    }
    
    fileprivate var messageName: MessageNameTableViewCell.MessageNameType? {
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? MessageNameTableViewCell {
            return cell.nameStatus
        }
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "MessageNameTableViewCell") as? MessageNameTableViewCell {
            return cell.nameStatus
        }
        return nil
    }
    
    fileprivate var selectedDatas: [String] {
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? ReceiverTableViewCell {
            return cell.selectedDatas
        }
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "ReceiverTableViewCell") as? ReceiverTableViewCell {
            return cell.selectedDatas
        }
        return []
    }
    
    fileprivate var isCopyMessage: Bool {
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? CopyTableViewCell {
            return cell.isCopy
        }
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "ReceiverTableViewCell") as? CopyTableViewCell {
            return cell.isCopy
        }
        return false
    }
    
    fileprivate var messageType: Int? {
        //0位通知，1为工作
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? MessageCategoryTableViewCell {
            if let status = cell.categoryStatus {
                if status == .inform {
                    return 0
                } else {
                    return 1
                }
            } else {
                return nil
            }
        }
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "MessageCategoryTableViewCell") as? MessageCategoryTableViewCell {
            if let status = cell.categoryStatus {
                if status == .inform {
                    return 0
                } else {
                    return 1
                }
            } else {
                return nil
            }
        }
        return nil
    }
    
    fileprivate var replyRequirement: ReplyRequirementTableViewCell.ReplyType? {
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? ReplyRequirementTableViewCell {
            return cell.typeStatus
        }
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "ReplyRequirementTableViewCell") as? ReplyRequirementTableViewCell {
            return cell.typeStatus
        }
        return nil
    }
    
    fileprivate var messageDeadline: String {
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 6, section: 0)) as? DeadlineTableViewCell {
            return cell.dateLabel.text ?? ""
        }
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "DeadlineTableViewCell") as? DeadlineTableViewCell {
            return cell.dateLabel.text ?? ""
        }
        return ""
    }
    
    fileprivate var draftTitle: String?
    fileprivate var draftText: String?
    fileprivate var draftType: String?
    
    
    convenience init(title: String, text: String, type: String? = nil) {
        self.init()
        self.draftTitle = title
        self.draftText = text
        self.draftType = type
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissTreeTableView(_:)))
        tapGestureRecognizer.delegate = self
        emptyView.isUserInteractionEnabled = true
        emptyView.addGestureRecognizer(tapGestureRecognizer)
        
        pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300))
        pickerView.delegate = self
        pickerView.dataSource = self
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.allowsSelection = false
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: "TitleTableViewCell")
        tableView.register(MessageNameTableViewCell.self, forCellReuseIdentifier: "MessageNameTableViewCell")
        tableView.register(ReceiverTableViewCell.self, forCellReuseIdentifier: "ReceiverTableViewCell")
        tableView.register(MessageCategoryTableViewCell.self, forCellReuseIdentifier: "MessageCategoryTableViewCell")
        tableView.register(ReplyRequirementTableViewCell.self, forCellReuseIdentifier: "ReplyRequirementTableViewCell")
        tableView.register(DeadlineTableViewCell.self, forCellReuseIdentifier: "DeadlineTableViewCell")
        tableView.register(CopyTableViewCell.self, forCellReuseIdentifier: "CopyTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        self.textView.delegate = self
        
        saveUsersBtn.addTarget(self, action: #selector(saveUsersAction(_:)), for: .touchUpInside)
        cancelUsersBtn.addTarget(self, action: #selector(cancelUsersAction(_:)), for: .touchUpInside)
        sendBtn.addTarget(self, action: #selector(sendMessage(_:)), for: .touchUpInside)
        storeDraftBtn.addTarget(self, action: #selector(storeDraft(_:)), for: .touchUpInside)
        searchPeopleBtn.addTarget(self, action: #selector(searchPeople(_:)), for: .touchUpInside)
        
        EntireUsersHelper.getEntireUsersInLabels(success: { model in
            self.entireUsersModel = model
            self.treeTableView = TreeTableView(frame: self.view.bounds, style: .plain, model)
        }, failure: {
            
        })
        
        EntireUsersHelper.getPersonalLabels(success: { model in
            self.entireLabelsModel = model
        }, failure: {
            
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "新建消息"
        self.navigationController?.navigationBar.barTintColor = UIColor(hex6: 0x00518e)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelSendMessage(_:)))
        
        topLabel.removeFromSuperview()
        topLineView.removeFromSuperview()
        
        saveUsersBtn.removeFromSuperview()
        cancelUsersBtn.removeFromSuperview()
        popView.removeFromSuperview()
        emptyView.removeFromSuperview()
        
        guard self.entireUsersModel != nil else {
            return
        }
        treeTableView.removeFromSuperview()
        treeTableView = TreeTableView(frame: self.view.bounds, style: .plain, self.entireUsersModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! ReceiverTableViewCell
        cell.collectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .left, animated: false)
    }
    
    
}

extension CreateMessageViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let richTextVC = RichTextViewController()
        richTextVC.hidesBottomBarWhenPushed = true
        richTextVC.setHTML(self.HTMLString)
        richTextVC.delegate = self
        
        self.navigationController?.pushViewController(richTextVC, animated: true)
        return false
    }
    
}

extension CreateMessageViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 1 else {
            return UIView()
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 1 else {
            return nil
        }
        return "编辑内容"
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section == 1 else {
            return 20
        }
        return 55
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 1 else {
            return nil
        }
        
        sendBtn.removeFromSuperview()
        storeDraftBtn.removeFromSuperview()
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 55))
        view.backgroundColor = .clear
        view.addSubview(sendBtn)
        view.addSubview(storeDraftBtn)
        
        sendBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.height.equalTo(30)
            make.width.equalTo(90)
            make.right.equalTo(view.snp.centerX).offset(-17)
        }
        storeDraftBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.height.equalTo(30)
            make.width.equalTo(90)
            make.left.equalTo(view.snp.centerX).offset(17)
        }
        
       return view
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section == 0 else {
            return 300
        }
        return 55
    }
    
}

extension CreateMessageViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else {
            return 1
        }
        if isReply == true {
            return 7
        } else {
            return 5
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section == 0 else {
            let cell = UITableViewCell()
            self.textView.removeFromSuperview()
            cell.contentView.backgroundColor = .clear
            cell.backgroundColor = .clear
            cell.contentView.addSubview(self.textView)
            textView.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(10)
                make.top.bottom.equalToSuperview()
            }
            if let text = self.draftText {
                self.draftText = nil
                //self.HTMLString = text
                if let attributedString = try? NSAttributedString(data: (text.data(using: .unicode))!, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil) {
                    self.textView.attributedText = attributedString
                }
            }
            return cell
        }
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell") as! TitleTableViewCell
            if let title = self.draftTitle {
                self.draftTitle = nil
                cell.textField.text = title
            }

            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageNameTableViewCell") as! MessageNameTableViewCell
            
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
            let cancelItem = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(toolBarCancelAction(_:)))
            let doneItem = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(toolBarDoneAction(_:)))
            let flexItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolBar.items = [cancelItem, flexItem, doneItem]

            let inputView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: pickerView.frame.size.height+44))
            pickerView.frame = CGRect(x: 0, y: 44, width: inputView.frame.size.width, height: inputView.frame.size.height-44)
            inputView.backgroundColor = .clear
            inputView.addSubview(pickerView)
            inputView.addSubview(toolBar)
            
            //差点循环引用了...
            cell.collegeLabel.limitAction = { [weak self] in
                self?.tableView.isUserInteractionEnabled = false
            }
            
            cell.collegeLabel.inputView = inputView
            cell.pickerBtn.addTarget(self, action: #selector(pickerViewAppear(_:)), for: .touchUpInside)

            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverTableViewCell") as! ReceiverTableViewCell
            cell.delegate = self
            self.delegete = cell
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CopyTableViewCell") as! CopyTableViewCell
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCategoryTableViewCell") as! MessageCategoryTableViewCell
            cell.delegate = self
            if let type = self.draftType {
                self.draftType = nil
                if type == "0" {
                    cell.categoryStatus = .inform
                    //self.isReply = false
                } else {
                    cell.categoryStatus = .work
                    //self.isReply = true
                }
            }
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyRequirementTableViewCell") as! ReplyRequirementTableViewCell
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeadlineTableViewCell") as! DeadlineTableViewCell

            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
            let doneItem = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(toolBarCancelAction(_:)))
            let flexItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolBar.items = [flexItem, doneItem]
            cell.dateLabel.inputAccessoryView = toolBar

            cell.dateLabel.limitAction = {
                self.tableView.isUserInteractionEnabled = false
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}

extension CreateMessageViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard self.entireLabelsModel != nil else {
            return nil
        }
        return self.entireLabelsModel.data[row].name
    }

}

extension CreateMessageViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard self.entireLabelsModel != nil else {
            return 0
        }
        return self.entireLabelsModel.data.count
    }

}

extension CreateMessageViewController: AddAndDeleteReceiverProtocol {
    
    func deleteReceiverCell(_ indexPath: IndexPath) {

        let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! ReceiverTableViewCell

        cell.collectionView.deleteItems(at: [indexPath])

    }

    func addReceiverCell(_ extraDatas: [String]) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! ReceiverTableViewCell
        let oldCounts = cell.selectedDatas.count
        cell.selectedDatas.append(contentsOf: extraDatas)

        var indexPaths: [IndexPath] = []
        for i in 0..<extraDatas.count {
            indexPaths.append(IndexPath(row: oldCounts+i, section: 0))
        }
        cell.collectionView.insertItems(at: indexPaths)
    }

    func presentTreeTableView() {
        guard self.treeTableView != nil else {
            return
        }
        
        popView.addSubview(topLabel)
        popView.addSubview(searchPeopleBtn)
        popView.addSubview(topLineView)
        popView.addSubview(treeTableView)
        popView.addSubview(saveUsersBtn)
        popView.addSubview(cancelUsersBtn)
        emptyView.addSubview(popView)
        self.view.addSubview(emptyView)
        
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(6)
//            make.left.right.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
        searchPeopleBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.right.equalToSuperview().inset(20)
//            make.left.equalTo(topLabel.snp.right)
            make.width.equalTo(90)
            make.height.equalTo(34)
        }
        topLineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topLabel.snp.bottom).offset(6)
            make.height.equalTo(1.5)
        }
        treeTableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topLineView.snp.bottom)
            make.bottom.equalToSuperview().inset(50)
        }
        saveUsersBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(15)
            make.height.equalTo(30)
            make.width.equalTo(75)
            make.right.equalTo(popView.snp.centerX).offset(-20)
        }
        cancelUsersBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(15)
            make.height.equalTo(30)
            make.width.equalTo(75)
            make.left.equalTo(popView.snp.centerX).offset(20)
        }
    }
    
    @objc func dismissTreeTableView(_ sender: UIButton) {
        topLabel.removeFromSuperview()
        topLineView.removeFromSuperview()
        treeTableView.removeFromSuperview()
        saveUsersBtn.removeFromSuperview()
        cancelUsersBtn.removeFromSuperview()
        popView.removeFromSuperview()
        emptyView.removeFromSuperview()
    }
    
    @objc func searchPeople(_ sender: UIButton) {
        let searchVC = SearchPeopleViewController(self.entireUsersModel)
        //searchVC.delegate = self
        let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! ReceiverTableViewCell
        searchVC.delegate = cell
        self.navigationController?.pushViewController(searchVC, animated: true)
    }

}

extension CreateMessageViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: self.emptyView)
        guard self.popView.frame.contains(touchPoint) else {
            return true
        }
        return false
    }

}

extension CreateMessageViewController {
    @objc func toolBarCancelAction(_ button: UIBarButtonItem) {
        self.view.endEditing(true)
        self.tableView.isUserInteractionEnabled = true
    }

    @objc func toolBarDoneAction(_ button: UIBarButtonItem) {
        self.view.endEditing(true)
        guard self.entireLabelsModel != nil else {
            return
        }
        
        let index = self.pickerView.selectedRow(inComponent: 0)
        let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! MessageNameTableViewCell
        cell.collegeLabel.text = self.entireLabelsModel.data[index].name
        self.authorID = Int(self.entireLabelsModel.data[index].lid)!
        self.tableView.isUserInteractionEnabled = true
    }

    @objc func pickerViewAppear(_ sender: UIButton) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! MessageNameTableViewCell
        self.tableView.isUserInteractionEnabled = false
        cell.collegeLabel.becomeFirstResponder()
    }
    
    @objc func saveUsersAction(_ sender: UIButton) {
        delegete?.addReceiverCell!(uids: self.treeTableView.selectedUsers)
        dismissTreeTableView(sender)
        treeTableView = TreeTableView(frame: self.view.bounds, style: .plain, self.entireUsersModel)
    }
    
    @objc func cancelUsersAction(_ sender: UIButton) {
        dismissTreeTableView(sender)
        treeTableView = TreeTableView(frame: self.view.bounds, style: .plain, self.entireUsersModel)
    }
    
    @objc func sendMessage(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "确认发送吗？", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .default)
        let saveChangeAction = UIAlertAction(title: "发送", style: .default) { _ in
            self.sendMessageLogic()
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(saveChangeAction)
        
        self.present(alertVC, animated: true)
    }
    
    func sendMessageLogic() {
        var dic: [String:Any] = [:]
        let type: Int? = self.messageType
        let title: String = self.messageTitle
        let name: MessageNameTableViewCell.MessageNameType? = self.messageName
        let deadline: String = self.messageDeadline
        let reply: ReplyRequirementTableViewCell.ReplyType? = self.replyRequirement
        let uidArrs: [String] = self.selectedDatas
        
        guard name != nil else {
            let rvc = UIAlertController(title: nil, message: "请选择消息名义", preferredStyle: .alert)
            self.present(rvc, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            })
            return
        }
        
        if  name == .college && self.authorID == 0 {
            let rvc = UIAlertController(title: nil, message: "请选择学院", preferredStyle: .alert)
            self.present(rvc, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            })
            return
        }
        
        guard type != nil else {
            let rvc = UIAlertController(title: nil, message: "请选择消息类别", preferredStyle: .alert)
            self.present(rvc, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            })
            return
        }
        
        guard title != "" && self.HTMLString != ""  else {
            let rvc = UIAlertController(title: nil, message: "标题和内容不能为空", preferredStyle: .alert)
            self.present(rvc, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            })
            return
        }
        
        dic["type"] = String(type!)
        dic["title"] = title
        dic["text"] = self.HTMLString
        dic["author"] = String(self.authorID)
        
        if type == 1 {
            dic["deadline"] = deadline
        }
        //dic["deadline"] = ""
        
        dic["response_to"] = "0"
        
        if type == 1 {
            guard reply != nil else {
                let rvc = UIAlertController(title: nil, message: "请选择回复人", preferredStyle: .alert)
                self.present(rvc, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                    self.presentedViewController?.dismiss(animated: true, completion: nil)
                })
                return
            }
            if reply == .college {
                dic["response_by"] = "1"
            } else {
                dic["response_by"] = "0"
            }
        } else {
            dic["response_by"] = "0"
        }
        
        if uidArrs.count == 0 {
            let rvc = UIAlertController(title: nil, message: "请选择收件人", preferredStyle: .alert)
            self.present(rvc, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            })
            return
        }
        
        for i in 0..<uidArrs.count {
            dic["receivers[\(i)]"] = uidArrs[i]
        }
        
        if type == 1 {
            var count = 0
            for i in 0..<uidArrs.count {
                let uid = uidArrs[i]
                if let lid = lookForLid(uid: uid) {
                    dic["receive_labels[\(count)]"] = lid
                    count += 1
                }
            }
        } else {
            dic["receive_labels"] = []
        }
        
        let isCopy = self.isCopyMessage
        if isCopy == true {
            dic["copy"] = "1"
        } else {
            dic["copy"] = "0"
        }
        
        self.sendBtn.isEnabled = false
        self.storeDraftBtn.isEnabled = false
        self.tableView.isUserInteractionEnabled = false
        
        PersonalMessageHelper.sendMessage(dictionary: dic, success: {
            NotificationCenter.default.post(name: NotificationName.NotificationRefreshInboxLists.name, object: nil)
            //NotificationCenter.default.post(name: NotificationName.NotificationRefreshOutboxLists.name, object: nil)
            NotificationCenter.default.post(name: NotificationName.NotificationRefreshCalendar.name, object: nil)
            //            let messageVC = self.navigationController?.viewControllers[0] as! MessageViewController
            //            messageVC.tableView.mj_header.beginRefreshing()
            self.navigationController?.popViewController(animated: true)
        }, failure: {
            self.sendBtn.isEnabled = true
            self.storeDraftBtn.isEnabled = true
            self.tableView.isUserInteractionEnabled = true
        })
    }

    @objc func storeDraft(_ sender: UIButton) {
        var dic: [String:Any] = [:]
        let type: Int? = self.messageType
        let title: String = self.messageTitle
        
        guard type != nil else {
            let rvc = UIAlertController(title: nil, message: "请选择消息类别", preferredStyle: .alert)
            self.present(rvc, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            })
            return
        }
        
        guard title != "" && self.HTMLString != ""  else {
            let rvc = UIAlertController(title: nil, message: "标题和内容不能为空", preferredStyle: .alert)
            self.present(rvc, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            })
            return
        }
        
        dic["type"] = String(type!)
        dic["title"] = title
        dic["text"] = self.HTMLString
        dic["response_to"] = "0"
        
        self.sendBtn.isEnabled = false
        self.storeDraftBtn.isEnabled = false
        self.tableView.isUserInteractionEnabled = false
        
        PersonalMessageHelper.saveDraft(dictionary: dic, success: {
//            let messageVC = self.navigationController?.viewControllers[0] as! MessageViewController
//            messageVC.tableView.mj_header.beginRefreshing()
            NotificationCenter.default.post(name: NotificationName.NotificationRefreshDraftLists.name, object: nil)
            self.navigationController?.popViewController(animated: true)
        }, failure: {
            self.sendBtn.isEnabled = true
            self.storeDraftBtn.isEnabled = true
            self.tableView.isUserInteractionEnabled = true
        })
    }
    
    func lookForLid(uid: String) -> String? {
        for index in 0..<self.entireUsersModel.data.count {
            let lid = self.entireUsersModel.data[index].labelID
            for i in 0..<self.entireUsersModel.data[index].users.count {
                if self.entireUsersModel.data[index].users[i].uid == uid {
                    return lid
                }
            }
            
        }
        return nil
    }
    
    @objc func cancelSendMessage(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(title: "取消发送吗？", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        let saveChangeAction = UIAlertAction(title: "继续编辑", style: .default)
        alertVC.addAction(cancelAction)
        alertVC.addAction(saveChangeAction)
        
        self.present(alertVC, animated: true)
    }

}

extension CreateMessageViewController: InformAndReplyProtocol {
    
    func foldTableView(_ isFold: Bool) {
        self.isReply = !isFold
    }
    
}

extension CreateMessageViewController: RichTextTransmitProtocol {
    
    func transmitText(_ text: String) {
        self.HTMLString = text
        if let attributedString = try? NSAttributedString(data: (text.data(using: .unicode))!, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil) {
            self.textView.attributedText = attributedString
        }
    }
    
}
