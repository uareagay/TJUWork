//
//  AddConferenceViewController.swift
//  TJUWork
//
//  Created by 赵家琛 on 2018/10/31.
//  Copyright © 2018 赵家琛. All rights reserved.
//

import UIKit

class AddConferenceViewController: UIViewController {
    fileprivate let emptyView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
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
    
    fileprivate var textView: UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.textColor = .black
        textView.backgroundColor = .white
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        textView.font = UIFont.systemFont(ofSize: 15)
        return textView
    }()
    
    fileprivate var entireUsersModel: EntireUsersModel!
    fileprivate var treeTableView: TreeTableView!
    weak var delegete: AddAndDeleteReceiverProtocol?
    fileprivate var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissTreeTableView(_:)))
        tapGestureRecognizer.delegate = self
        emptyView.isUserInteractionEnabled = true
        emptyView.addGestureRecognizer(tapGestureRecognizer)
        
        saveUsersBtn.addTarget(self, action: #selector(saveUsersAction(_:)), for: .touchUpInside)
        cancelUsersBtn.addTarget(self, action: #selector(cancelUsersAction(_:)), for: .touchUpInside)
        searchPeopleBtn.addTarget(self, action: #selector(searchPeople(_:)), for: .touchUpInside)
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 55
        tableView.register(ReceiverTableViewCell.self, forCellReuseIdentifier: "ReceiverTableViewCell")
        tableView.register(DeadlineTableViewCell.self, forCellReuseIdentifier: "DeadlineTableViewCell")
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: "TitleTableViewCell")
        //tableView.rowHeight = 55
        
        self.view.addSubview(tableView)
        
        
        EntireUsersHelper.getEntireUsersInLabels(success: { model in
            self.entireUsersModel = model
            self.treeTableView = TreeTableView(frame: self.view.bounds, style: .plain, model)
        }, failure: {
            
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "发起会议"
    }
}

extension AddConferenceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 4 else {
            return nil
        }
        return "会议内容"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else if section <= 3 {
            return 1.5
        } else {
            return 35
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        } else if section <= 3 {
            return self.displayLineView()
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
            return 250
        } else {
            return 55
        }
    }
}

extension AddConferenceViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell") as! TitleTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell") as! TitleTableViewCell
            cell.titleLabel.text = "地点："
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverTableViewCell") as! ReceiverTableViewCell
            cell.delegate = self
            self.delegete = cell
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeadlineTableViewCell") as! DeadlineTableViewCell
            cell.titleLabel.text = "开始时间："
            return cell
        case 4:
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
        default:
            return UITableViewCell()
        }
    }
}

extension AddConferenceViewController: AddAndDeleteReceiverProtocol {
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
}

extension AddConferenceViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: self.emptyView)
        guard self.popView.frame.contains(touchPoint) else {
            return true
        }
        return false
    }
}

extension AddConferenceViewController {
    @objc func saveUsersAction(_ sender: UIButton) {
        delegete?.addReceiverCell!(uids: self.treeTableView.selectedUsers)
        dismissTreeTableView(sender)
        treeTableView = TreeTableView(frame: self.view.bounds, style: .plain, self.entireUsersModel)
    }
    
    @objc func cancelUsersAction(_ sender: UIButton) {
        dismissTreeTableView(sender)
        treeTableView = TreeTableView(frame: self.view.bounds, style: .plain, self.entireUsersModel)
    }
    
    @objc func searchPeople(_ sender: UIButton) {
        let searchVC = SearchPeopleViewController(self.entireUsersModel)
        //searchVC.delegate = self
        let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! ReceiverTableViewCell
        searchVC.delegate = cell
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func displayLineView() -> UIView {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 7.5))
//        let contentView = UIView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width-20, height: 7.5))
//        let lineView = UIView(frame: CGRect(x: 50+20, y: 3, width: UIScreen.main.bounds.size.width-20-50-20-15, height: 1.5))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 1.5))
        let contentView = UIView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width-20, height: 1.5))
        let lineView = UIView(frame: CGRect(x: 50+20, y: 0, width: UIScreen.main.bounds.size.width-20-50-20-15, height: 1.5))
        contentView.backgroundColor = .white
        lineView.backgroundColor = UIColor(hex6: 0xe5edf3)
        
        view.addSubview(contentView)
        contentView.addSubview(lineView)
        return view
    }
}
